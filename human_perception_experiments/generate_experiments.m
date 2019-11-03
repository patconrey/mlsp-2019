%% Config

addpath("listening_experiments/processing_functions");

% experiment_parameters = [ 
%     @processing_diff_phase, 5;
%     @processing_template, 2;
%     @processing_awgn, 4;
% ];

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

protocol = readtable(path_to_protocol_file, "Delimiter", " ", "ReadVariableNames", false);
