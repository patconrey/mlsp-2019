% This script uses the defined processing function to create a new
% processed dataset from the LA data folder

%% Set paths to source and destination
path_to_database = 'F:\MLSP\LA';
path_to_source = fullfile(path_to_database,'ASVspoof2019_LA_train/flac');
path_to_destination = fullfile(path_to_database,'ASVspoof2019_LA_train_processed');
file_list = dir(fullfile(path_to_source, '*.flac'));
% MAKE SURE to do this for training, development, and/or evaluation data
% (whatever is going to be used)

%% Choose a processing function
addpath(fullfile('listening_experiments', 'processing_functions'));
processing_function = @no_processing;

%% Process and save to destination
for k=1:length(file_list)
    % Read in the file for this iteration
    base_file = file_list(k).name;
    current_file = fullpath(path_to_source,base_file);
    [current_audio, fs] = audioread(current_file);
    % Process the data
    processed_audio = processing_function(current_audio);
    % Write processed data to new location
    new_file = fullpath(path_to_destination,base_file);
    audiowrite(new_file, processed_audio, fs);
end