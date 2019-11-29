%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ASVspoof 2019
% Automatic Speaker Verification Spoofing and Countermeasures Challenge
%
% http://www.asvspoof.org/
%
% ============================================================================================
% Matlab implementation of spoofing detection baseline system based on:
%   - linear frequency cepstral coefficients (LFCC) features + Gaussian Mixture Models (GMMs)
%   - constant Q cepstral coefficients (CQCC) features + Gaussian Mixture Models (GMMs)
% ============================================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear; close all; clc;

% add required libraries to the path
addpath(genpath('LFCC'));
addpath(genpath('CQCC_v1.0'));
% addpath(genpath('GMM'));
addpath(genpath('bosaris_toolkit'));
addpath(genpath('tDCF_v1'));
addpath("modgdf");
addpath("mel_scaled_modgdf");

% set here the experiment to run (access and feature type)
access_type = 'LA'; % LA for logical or PA for physical
feature_type = 'melmodgdf'; % LFCC, CQCC, melmodgdf, modgdf

% TODO: in this code we assume that the data follows the directory structure:
%
% ASVspoof_root/
%   |- LA
%      |- ASVspoof2019_LA_dev_asv_scores_v1.txt
% 	   |- ASVspoof2019_LA_dev_v1/
% 	   |- ASVspoof2019_LA_protocols_v1/
% 	   |- ASVspoof2019_LA_train_v1/
%   |- PA
%      |- ASVspoof2019_PA_dev_asv_scores_v1.txt
%      |- ASVspoof2019_PA_dev_v1/
%      |- ASVspoof2019_PA_protocols_v1/
%      |- ASVspoof2019_PA_train_v1/

pathToASVspoof2019Data = '../dataset/';

pathToDatabase = fullfile(pathToASVspoof2019Data, access_type);
trainProtocolFile = fullfile(pathToDatabase, horzcat('ASVspoof2019_', access_type, '_cm_protocols'), horzcat('ASVspoof2019.', access_type, '.cm.train.trn.txt'));
devProtocolFile = fullfile(pathToDatabase, horzcat('ASVspoof2019_', access_type, '_cm_protocols'), horzcat('ASVspoof2019.', access_type, '.cm.dev.trl.txt'));

% read train protocol
fileID = fopen(trainProtocolFile);
protocol = textscan(fileID, '%s%s%s%s%s');
fclose(fileID);

% get file and label lists
filelist = protocol{2};
key = protocol{5};

% get indices of genuine and spoof files
bonafideIdx = find(strcmp(key,'bonafide'));
spoofIdx = find(strcmp(key,'spoof'));

%% Create Mel Filter Banks
hz2mel = @(hz)(1127*log(1+hz/700)); % Hertz to mel warping function
mel2hz = @(mel)(700*exp(mel/1127)-700); % mel to Hertz warping function

number_of_filters = 32;
length_of_each_filter = floor(DFT_LENGTH/2) + 1;
frequency_limits = [0 fs/2];
[ filter_bank, ~, ~ ] = trifbank( number_of_filters, length_of_each_filter, frequency_limits, fs, hz2mel, mel2hz );

%% Feature extraction for training data

% extract features for GENUINE training data and store in cell array
disp('Extracting features for BONA FIDE training data...');
% genuineFeatureCell = cell(size(bonafideIdx));
% for i=1:length(bonafideIdx)
%     filePath = fullfile(pathToDatabase,['ASVspoof2019_' access_type '_train/flac'],[filelist{bonafideIdx(i)} '.flac']);
%     [x,fs] = audioread(filePath);
%     if strcmp(feature_type,'LFCC')
%         [stat,delta,double_delta] = extract_lfcc(x,fs,20,512,20);
%         genuineFeatureCell{i} = [stat delta double_delta]';
%     elseif strcmp(feature_type,'CQCC')
%         genuineFeatureCell{i} = cqcc(x, fs, 96, fs/2, fs/2^10, 16, 29, 'ZsdD');
%     elseif strcmp(feature_type, 'melmodgdf')
%         genuineFeatureCell{i} = modified_group_delay_feature(x, fs);
%     end
% end
genuineFeatureCell = load("features/train_bonafide_melmodgdf.mat").genuineFeatureCell;
genuineFeatureCell = cellfun(@transpose, genuineFeatureCell, 'UniformOutput', false);
disp('Done!');

% FeatureCells must be column wise (i.e., every column is a sample);
% 90   405

% extract features for SPOOF training data and store in cell array
disp('Extracting features for SPOOF training data...');
% spoofFeatureCell = cell(size(spoofIdx));
% parfor i=1:length(spoofIdx)
%     filePath = fullfile(pathToDatabase,['ASVspoof2019_' access_type '_train/flac'],[filelist{spoofIdx(i)} '.flac'])
%     [x,fs] = audioread(filePath);
%     if strcmp(feature_type,'LFCC')
%         [stat,delta,double_delta] = extract_lfcc(x,fs,20,512,20);
%         spoofFeatureCell{i} = [stat delta double_delta]';
%     elseif strcmp(feature_type,'CQCC')
%         spoofFeatureCell{i} = cqcc(x, fs, 96, fs/2, fs/2^10, 16, 29, 'ZsdD');
%     elseif strcmp(feature_type, 'melmodgdf')
%         genuineFeatureCell{i} = modified_group_delay_feature(x, fs);
%     end
% end
spoofFeatureCell = load("features/train_spoofed_melmodgdf.mat").spoofFeatureCell;
spoofFeatureCell = cellfun(@transpose, spoofFeatureCell, 'UniformOutput', false);
disp('Done!');

%% GMM training BONA FIDE

% train GMM for BONA FIDE data
disp('Training GMM for BONA FIDE...');
[genuineGMM.m, genuineGMM.s, genuineGMM.w] = vl_gmm([genuineFeatureCell{:}], 512, 'verbose', 'MaxNumIterations',10);
disp('Done!');

%% Prepare SPOOF features

% Randomly sample 'spoofFeatureCell' down to 1/8 the original size
disp('Sampling SPOOF');
targetSize = 2850;
while size(spoofFeatureCell,1) > targetSize
    didx = floor(rand()*size(spoofFeatureCell,1))+1;
    spoofFeatureCell(didx,:) = [];
end
disp('Done!');

%% GMM training SPOOF

% train GMM for SPOOF data
disp('Training GMM for SPOOF...');
[spoofGMM.m, spoofGMM.s, spoofGMM.w] = vl_gmm([spoofFeatureCell{:}], 512, 'verbose', 'MaxNumIterations',10);
disp('Done!');


%% Feature extraction and scoring of development data

% read development protocol
fileID = fopen(devProtocolFile);
protocol = textscan(fileID, '%s%s%s%s%s');
fclose(fileID);

% get file and label lists
filelist = protocol{2};
attackType = protocol{4};
key = protocol{5};

% process each development trial: feature extraction and scoring
scores_cm = zeros(size(filelist));
disp('Computing scores for development trials...');
for i=1:length(filelist)
    filePath = fullfile(pathToDatabase,['ASVspoof2019_' access_type '_dev/flac'],[filelist{i} '.flac']);
    [x,fs] = audioread(filePath);
    % featrue extraction
    x_fea = [];
    if strcmp(feature_type,'LFCC')
        [stat,delta,double_delta] = extract_lfcc(x,fs,20,512,20);
        x_fea = [stat delta double_delta]';
    elseif strcmp(feature_type,'CQCC')
        x_fea = cqcc(x, fs, 96, fs/2, fs/2^10, 16, 29, 'ZsdD');
    elseif strcmp(feature_type, 'modgdf')
        [~, x_fea, ~] = modified_group_delay_feature(x, fs);
        x_fea = x_fea';
    elseif strcmp(feature_type, 'melmodgdf')
        [~, cepstral_features, ~] = mel_modified_group_delay_feature(x, fs, filter_bank);
        x_fea = cepstral_features';
    end
    
    % score computation
    llk_genuine = mean(compute_llk(x_fea,genuineGMM.m,genuineGMM.s,genuineGMM.w));
    llk_spoof = mean(compute_llk(x_fea,spoofGMM.m,spoofGMM.s,spoofGMM.w));
    % compute log-likelihood ratio
    scores_cm(i) = llk_genuine - llk_spoof;
end
disp('Done!');

% save scores to disk
fid = fopen(fullfile('cm_scores',['scores_cm_' access_type '_' feature_type '.txt']), 'w');
for i=1:length(scores_cm)
    fprintf(fid,'%s %s %s %.6f\n',filelist{i},attackType{i},key{i},scores_cm(i));
end
fclose(fid);

%% compute performance
evaluate_tDCF_asvspoof19(fullfile('cm_scores', ['scores_cm_' access_type '_' feature_type '.txt']), fullfile(pathToASVspoof2019Data, access_type, 'ASVspoof2019_LA_asv_scores', ['ASVspoof2019.' access_type '.asv.dev.gi.trl.scores.txt']));
