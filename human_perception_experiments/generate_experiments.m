%% Config

addpath("listening_experiments/processing_functions");

% experiment_parameters = [ 
%     @processing_diff_phase, 5;
%     @processing_template, 2;
%     @processing_awgn, 4;
% ];

number_of_experiments = 10;

max_duration_in_seconds = 2;

path_to_processed_signals = "artifacts/";

path_to_experiment_table = "experiment_table.mat";

path_to_protocol_file = "../dataset/LA/ASVspoof2019_LA_cm_protocols/ASVspoof2019.LA.cm.eval.trl.txt";

path_to_audio_data = "../dataset/LA/ASVspoof2019_LA_eval/flac/";

% This should specify:
%   - processing functions
%   - number of experiments
%   - max duration of any sample
%   - output path for artifacts of processing
%   - output path for experiments table

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

%% Load in protocol files

protocol = table2array(readtable(path_to_protocol_file, "Delimiter", " ", "ReadVariableNames", false));

indices_for_spoofed_data = protocol(:, 5) == "spoof";
indices_for_bonafide_data = protocol(:, 5) == "bonafide";

protocol_spoofed = protocol(indices_for_spoofed_data, :);
protocol_bonafide = protocol(indices_for_bonafide_data, :);

%% Create experiment sets

% Experiment sources is an array of structs each with the following properties
%   - label: Indicates which class has majority
%   - spoofed_samples: A cell array of filenames corresponding to spoofed 
%       audio samples. There will be 3 elements if label == "spoofed".
%   - bonafide_samples: A cell array of filenames corresponding to bonafide 
%       audio samples. There will be 3 elements if label == "bonafide".
experiment_sources = [];
for experiment_index = 1:number_of_experiments
    is_majority_spoofed = randi([0 1], 1);
    
    experiment_label = "bonafide";
    if is_majority_spoofed
        experiment_label = "spoofed";
    end
    experiment_sources(experiment_index).label = experiment_label;
    
    number_spoofed_samples = 1;
    if is_majority_spoofed
        number_spoofed_samples = 3;
    end
    
    number_bonafide_samples = 3;
    if is_majority_spoofed
        number_bonafide_samples = 1;
    end
    
    % Draw samples
    spoofed_samples = data_sample(protocol_spoofed, number_spoofed_samples);
    bonafide_samples = data_sample(protocol_bonafide, number_bonafide_samples);
    experiment_sources(experiment_index).spoofed_samples = spoofed_samples;
    experiment_sources(experiment_index).bonafide_samples = bonafide_samples;
end

