%% README

% This script will generate experiment sets according to the parameters
% provided below. Here, an experiment set is defined to mean 4 processed
% sample of data. One of these samples will be from an outlier class
% (either spoofed or bonafide), while three of the samples will be from the
% other class. The choice between which class is the majority for a given
% experiment is decided randomly. The script outputs a .mat file following
% this structure:
% Experiment sources is an array of structs each with the following
% properties.
%   - label: Indicates which class has majority
%   - processing: function handle to use to process samples
%   - spoofed_samples: A cell array of filenames corresponding to spoofed 
%       audio samples. There will be 3 elements if label == "spoofed".
%   - bonafide_samples: A cell array of filenames corresponding to bonafide 
%       audio samples. There will be 3 elements if label == "bonafide".
%   - output_spoofed: an array of the output filenames for the spoofed
%       class
%   - output_bonafide: an array of the output filenames for the bonafide
%       class
%   - presentation: an array of the filenames in the order they ought to be
%       presented in, according to the method Rich suggested.
%   - index_of_outlier: the index of the outlyling sample relative to
%       presentation

%% Config
% Choose 'Mark' or 'Pat'
Machine = "Pat";

addpath("listening_experiments/processing_functions");
addpath("listening_experiments/utils");

% The next two parameters determine the processing to apply to data samples
% as well as the number of experiment sets for each method of procesing.
experiment_processing_functions = { @processing_none, @processing_awgn, @processing_band_pass, @processing_band_stop, @processing_diff_dphase, @processing_dnsmpl_alias, @processing_GLA_phase, @processing_high_pass, @processing_high_phase_band, @processing_low_pass, @processing_low_phase_band, @processing_mid_phase_band };
number_of_samples_for_processing = [ 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ];

% If an audio sample is longer than this parameter, it will be truncated.
max_duration_in_seconds = 5;

% This is the directory we'll save the processed audio files to.
if Machine == "Mark"
    path_to_processed_signals = "listening_experiments\artifacts\";
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

%% Check assertions

assert(length(experiment_processing_functions) == length(number_of_samples_for_processing), "Must provide equal number of processing functions as number of samples per processing function.")
% assert(isequal(experiment_processing_functions(1), @processing_none), "First processing function must be @processing_none."); % Assert that at least the first processing function is for an example.

%% Load in protocol files

protocol = table2array(readtable(path_to_protocol_file, "Delimiter", " ", "ReadVariableNames", false));

indices_for_spoofed_data = protocol(:, 5) == "spoof";
indices_for_bonafide_data = protocol(:, 5) == "bonafide";

protocol_spoofed = protocol(indices_for_spoofed_data, :);
protocol_bonafide = protocol(indices_for_bonafide_data, :);

%% Create experiment sets

experiment_sources = [];

% Loop through the processing functions and generate the appropriate number
% of experiment sets for each one, according to the numbers provided in 
% number_of_samples_for_processing.
for processing_function_index = 1:length(experiment_processing_functions)
    number_of_sets = number_of_samples_for_processing(processing_function_index);
    
    % Generate experiment sets for each processing function.
    for local_set_index = 1:number_of_sets
        is_majority_spoofed = randi([0 1], 1);

        experiment_label = "bonafide";
        if is_majority_spoofed
            experiment_label = "spoofed";
        end

        number_spoofed_samples = 1;
        if is_majority_spoofed
            number_spoofed_samples = 3;
        end
        spoofed_samples = data_sample(protocol_spoofed, number_spoofed_samples);

        number_bonafide_samples = 3;
        if is_majority_spoofed
            number_bonafide_samples = 1;
        end
        bonafide_samples = data_sample(protocol_bonafide, number_bonafide_samples);
        
        global_experiment_index = local_set_index + sum(number_of_samples_for_processing(1 : processing_function_index - 1));
        experiment_sources(global_experiment_index).label = experiment_label;
        experiment_sources(global_experiment_index).processing = experiment_processing_functions(processing_function_index);
        experiment_sources(global_experiment_index).input_spoofed = spoofed_samples;
        experiment_sources(global_experiment_index).input_bonafide = bonafide_samples;
    end
end

%% Process the data in experiment set

% Loop through experiment sources and process the data in input_spoofed and
% inpute_bonafide according to the processing function specifed. Then, save
% those artifacts and add the filenames to the struct
for experiment_index = 1:length(experiment_sources)
    experiment = experiment_sources(experiment_index);
    processing_function = experiment.processing{1};
    
    % Loop through spoofed inputs
    previous_args = [];
    for spoof_index = 1:length(experiment.input_spoofed)
        file_name = experiment.input_spoofed{spoof_index};
        spoofed_sample_path = path_to_audio_data + file_name + ".flac";
        spoofed_audio = read_in_sample(spoofed_sample_path, max_duration_in_seconds);
        
        if spoof_index == 1
            [processed_sample, new_args] = processing_function(spoofed_audio);
            previous_args = new_args;
        else
            processed_sample = processing_function(spoofed_audio, previous_args);
        end
        
        path_for_processed_artifact = path_to_processed_signals + file_name + ".spoofed.processed.flac";
        write_sample(path_for_processed_artifact, processed_sample, fs);
        
        experiment_sources(experiment_index).output_spoofed(spoof_index) = path_for_processed_artifact;
    end
    
    % Loop through bonafide inputs
    for bonafide_index = 1:length(experiment.input_bonafide)
        file_name = experiment.input_bonafide{bonafide_index};
        bonafide_sample_path = path_to_audio_data + file_name + ".flac";
        bonafide_audio = read_in_sample(bonafide_sample_path, max_duration_in_seconds);
        
        processed_sample = processing_function(bonafide_audio, previous_args);
        path_for_processed_artifact = path_to_processed_signals + file_name + ".bonafide.processed.flac";
        write_sample(path_for_processed_artifact, processed_sample, fs);
        
        experiment_sources(experiment_index).output_bonafide(bonafide_index) = path_for_processed_artifact;
    end 
end

%% Create presentation order

% Loop through each experiment source and decide the presentation order for
% each one.
for experiment_index = 1:length(experiment_sources)
    experiment = experiment_sources(experiment_index);
    spoofed_sources = experiment.output_spoofed;
    bonafide_sources = experiment.output_bonafide;
    label = experiment.label;
    
    is_majority_spoofed = label == "spoofed";
    
    presentation = strings(1, 4);
    index_of_outlier = 2 + randi([0 1], 1);
    if is_majority_spoofed
        presentation(1, 1) = spoofed_sources(1);
        presentation(1, 4) = spoofed_sources(2);
        presentation(1, 2 + abs(3 - index_of_outlier)) = spoofed_sources(3);
        presentation(1, index_of_outlier) = bonafide_sources;
    else
        presentation(1, 1) = bonafide_sources(1);
        presentation(1, 4) = bonafide_sources(2);
        presentation(1, 2 + abs(3 - index_of_outlier)) = bonafide_sources(3);
        presentation(1, index_of_outlier) = spoofed_sources;
    end
    
    experiment_sources(experiment_index).presentation = presentation;
    experiment_sources(experiment_index).index_of_outlier = index_of_outlier;
end

%% Shuffle experiment data

% This will leave the first experiment source as an example.
experiment_sources = experiment_sources([ 1, 1 + randperm(length(experiment_sources) - 1)]);

%% Create Table

save(path_to_experiment_table, "experiment_sources");