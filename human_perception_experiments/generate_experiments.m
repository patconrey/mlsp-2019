%% Config

addpath("listening_experiments/processing_functions");

experiment_processing_functions = { @processing_diff_phase, @processing_template };
number_of_samples_for_processing = [ 5, 3 ];

max_duration_in_seconds = 2;

path_to_processed_signals = "artifacts/";

path_to_experiment_table = "experiment_table.mat";

path_to_protocol_file = "../dataset/LA/ASVspoof2019_LA_cm_protocols/ASVspoof2019.LA.cm.eval.trl.txt";

path_to_audio_data = "../dataset/LA/ASVspoof2019_LA_eval/flac/";

fs = 16000;

% Experiments table:
%   id | processing | input spoofed | input bonafide | output spoofed |
%   output bonafide | presentation 
%   
%   - id: integer referring to the id of the experiment
%   - processing: the name of the processing function
%   - input spoofed: an array of the names of the input files that were
%       spoofed
%   - input bonafide: an array of the names of the input files that were
%       bonafide
%   - output spoofed: an array of the output filenames for the spoofed
%       class
%   - output bonafide: an array of the output filenames for the bonafide
%       class
%   - presentation: an array of the filenames in the order they ought to be
%       presented in

%% Check assertions

assert(length(experiment_processing_functions) == length(number_of_samples_for_processing), "Must provide equal number of processing functions as number of samples per processing function.")

%% Load in protocol files

protocol = table2array(readtable(path_to_protocol_file, "Delimiter", " ", "ReadVariableNames", false));

indices_for_spoofed_data = protocol(:, 5) == "spoof";
indices_for_bonafide_data = protocol(:, 5) == "bonafide";

protocol_spoofed = protocol(indices_for_spoofed_data, :);
protocol_bonafide = protocol(indices_for_bonafide_data, :);

%% Create experiment sets

% Experiment sources is an array of structs each with the following properties
%   - label: Indicates which class has majority
%   - processing: function handle to use to process samples
%   - spoofed_samples: A cell array of filenames corresponding to spoofed 
%       audio samples. There will be 3 elements if label == "spoofed".
%   - bonafide_samples: A cell array of filenames corresponding to bonafide 
%       audio samples. There will be 3 elements if label == "bonafide".
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
    for spoof_index = 1:length(experiment.input_spoofed)
        file_name = experiment.input_spoofed{spoof_index};
        spoofed_sample_path = path_to_audio_data + file_name + ".flac";
        spoofed_audio = read_in_sample(spoofed_sample_path, max_duration_in_seconds);
        
        processed_sample = processing_function(spoofed_audio);
        path_for_processed_artifact = path_to_processed_signals + file_name + ".spoofed.processed.flac";
        write_sample(path_for_processed_artifact, processed_sample, fs);
        
        experiment_sources(experiment_index).output_spoofed(spoof_index) = path_for_processed_artifact;
    end
    
    % Loop through bonafide inputs
    for bonafide_index = 1:length(experiment.input_bonafide)
        file_name = experiment.input_bonafide{bonafide_index};
        bonafide_sample_path = path_to_audio_data + file_name + ".flac";
        bonafide_audio = read_in_sample(bonafide_sample_path, max_duration_in_seconds);
        
        processed_sample = processing_function(bonafide_audio);
        path_for_processed_artifact = path_to_processed_signals + file_name + ".bonafide.processed.flac";
        write_sample(path_for_processed_artifact, processed_sample, fs);
        
        experiment_sources(experiment_index).output_bonafide(bonafide_index) = path_for_processed_artifact;
    end
    
end
