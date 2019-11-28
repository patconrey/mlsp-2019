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
addpath("../feature_extractors/mel_scaled_modgdf");

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
protocolFile = fullfile(pathToDatabase, horzcat('ASVspoof2019_', access_type, '_cm_protocols'), horzcat('ASVspoof2019.', access_type, '.cm.eval.trl.txt'));

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

%% Config

DFT_LENGTH = 512;
fs = 16000;

%% Create Mel Filter Banks
hz2mel = @(hz)(1127*log(1+hz/700)); % Hertz to mel warping function
mel2hz = @(mel)(700*exp(mel/1127)-700); % mel to Hertz warping function

number_of_filters = 32;
length_of_each_filter = floor(DFT_LENGTH/2) + 1;
frequency_limits = [0 fs/2];
[ filter_bank, ~, ~ ] = trifbank( number_of_filters, length_of_each_filter, frequency_limits, fs, hz2mel, mel2hz );

%% Feature extraction and scoring of data

evaluationFeatureCell = cell(size(filelist));
parfor i=1:length(filelist)
    filePath = fullfile(pathToDatabase,['ASVspoof2019_' access_type '_eval/flac'],[filelist{i} '.flac']);
    [x,fs] = audioread(filePath);
    [~, cepstral_features, ~] = mel_modified_group_delay_feature(x, fs, filter_bank);
    evaluationFeatureCell{i} = cepstral_features;
end

save("eval_melmodgdf_features.mat", "evaluationFeatureCell");

disp('Done!');