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

clear; close all; clc;

% add required libraries to the path
addpath(genpath('LFCC'));
addpath(genpath('CQCC_v1.0'));
addpath(genpath('GMM'));
addpath(genpath('bosaris_toolkit'));
addpath(genpath('tDCF_v1'));
addpath("modgdf");

% set here the experiment to run (access and feature type)
access_type = 'LA'; % LA for logical or PA for physical

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
protocolFile = fullfile(pathToDatabase, horzcat('ASVspoof2019_', access_type, '_cm_protocols'), horzcat('ASVspoof2019.', access_type, '.cm.train.trn.txt'));

% read development protocol
fileID = fopen(protocolFile);
protocol = textscan(fileID, '%s%s%s%s%s');
fclose(fileID);

% get file and label lists
filelist = protocol{2};
attackType = protocol{4};
key = protocol{5};

% get indices of genuine and spoof files
bonafideIdx = find(strcmp(key,'bonafide'));
spoofIdx = find(strcmp(key,'spoof'));

%% Bona fide Feature Extraction

disp('Extracting training features for BONA FIDE data...');
genuineFeatureCell = cell(size(bonafideIdx));
parfor i=1:length(bonafideIdx)
    filePath = fullfile(pathToDatabase,['ASVspoof2019_' access_type '_train/flac'],[filelist{bonafideIdx(i)} '.flac']);
    [x,fs] = audioread(filePath);
    [~, cepstral_features, ~] = modified_group_delay_feature(x, fs);
    genuineFeatureCell{i} = cepstral_features;
end
disp('Done!');
save("features/train_bonafide_modgdf_dd2_30.mat", "genuineFeatureCell");

%% Spoofed Feature Extraction

% extract features for SPOOF training data and store in cell array
disp('Extracting training features for SPOOF data...');
spoofFeatureCell = cell(size(spoofIdx));
parfor i=1:length(spoofIdx)
    filePath = fullfile(pathToDatabase,['ASVspoof2019_' access_type '_train/flac'],[filelist{spoofIdx(i)} '.flac'])
    [x,fs] = audioread(filePath);
    [~, cepstral_features, ~] = modified_group_delay_feature(x, fs);
    spoofFeatureCell{i} = cepstral_features;
end
disp('Done!');
save("features/train_spoofed_modgdf_dd2_30.mat", "spoofFeatureCell");

disp('Training feature generation complete!');