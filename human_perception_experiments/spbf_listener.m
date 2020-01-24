%% README

% This script will help us choose which samples are good for human
% perception tests.

%% Config
% Choose 'Mark' or 'Pat'
Machine = "Mark";
class_type = 'spoofed';

addpath("listening_experiments/processing_functions");
addpath("listening_experiments/utils");

% This is the directory we'll save the processed audio files to.
if Machine == "Mark"
    path_to_processed_signals = "artifacts\";
elseif Machine == "Pat"
    path_to_processed_signals = "artifacts/";
end

% This is the path we'll save the final experiment table to.
path_to_experiment_table = "experiments.mat";

% This file will be used as the source of the spoofed and bonafide audio.
if Machine == "Mark"
    path_to_protocol_file = "F:\MLSP\LA\ASVspoof2019_LA_cm_protocols\ASVspoof2019.LA.cm.dev.trl.txt";
elseif Machine == "Pat"
    path_to_protocol_file = "../dataset/LA/ASVspoof2019_LA_cm_protocols/ASVspoof2019.LA.cm.dev.trl.txt";
end

% Set this parameter to be the directory path to the audio data.
if Machine == "Mark"
    path_to_audio_data = "F:\MLSP\LA\ASVspoof2019_LA_dev\flac\";
elseif Machine == "Pat"
    path_to_audio_data = "../dataset/LA/ASVspoof2019_LA_dev/flac/";
end

% All our data has a sampling frequency of 16kHz so this should remain
% unchanged.
fs = 16000;

%% Load in protocol files

protocol = table2array(readtable(path_to_protocol_file, "Delimiter", " ", "ReadVariableNames", false));

indices_for_spoofed_data = protocol(:, 5) == "spoof";
indices_for_bonafide_data = protocol(:, 5) == "bonafide";

protocol_spoofed = protocol(indices_for_spoofed_data, :);
protocol_bonafide = protocol(indices_for_bonafide_data, :);

%% Play files from class
user_input = ' ';
acceptable = [];
if strcmp(class_type, 'spoofed')
    prot = protocol_spoofed;
else
    prot = protocol_bonafide;
end

while ~strcmp(user_input, 'e')
    % Select/import file
    file_name = data_sample(prot, 1);
    file_name = strcat(file_name{1,1},'.flac');
    file_path = strcat(path_to_audio_data, file_name);
    current = audioread(file_path);
    
    % Play file
    soundsc(current, fs);
    
    % Get user input
    user_input = input('> ', 's');
    
    if strcmp(user_input, 'y')
        acceptable = vertcat(acceptable, file_name);
        size(acceptable)
    end
end

%% Write to file
file_dest = sprintf('good_%s.csv', class_type);
writematrix(acceptable, file_dest);