%% README

% This script is an easy way to try different processing techniques on a
% spoofed speech sample and a bonafide speech sample. The Config section
% contains some simple environment details which should all be pretty self
% explanatory.

% This pipeline is configured to require as little tampering as possible.
% This script will load in the audio files designated in the Config section
% by the parameters, path_to_bonafide_speech and path_to_spoofed_speech,
% and shorten them so they are no longer than the maximum_sample_duration_in_seconds config
% parameter. It will show spectrograms of the signals if the config
% parameter to do so, should_show_spectrograms, is set to true. The window
% for the spectrogram is a Hamming window with a length specified by the
% config parameter spectrogram_window_length.

% All of the custom processing for a given experiment is abstracted to a
% processing function, which follows the naming convention
% "processing_<experiment_details>.m". This allows for immediate
% generalization and easy verification of individual results. All of the
% experiments should come with their own processing function and that
% processing function name should be specified in the Google sheet along
% with the other details of the experiment. Pass in the custom processing
% function by setting the processing_function config parameter equal to a
% handle associated with the processing function you'd like to use.

% After processing is completed, this script will show
% spectrograms of the processed signals, save the resulting
% signals to the paths specified in the config parameters
% path_to_bonafide_post_artifact and path_to_spoofed_post_artifact, and
% play the processed signals with a pause between each one. Whether
% or not the script will show the spectrograms, save the audio artifacts,
% or play the audio artifacts is decided by config parameters you can set.

%% Config

fs = 16000; % Hertz
should_show_spectrograms = true;
spectrogram_window_length = 512;
should_save_audio = true;
should_play_audio = false;

path_to_bonafide_speech = "bonafide.flac";
path_to_spoofed_speech = "spoof.flac";
path_to_bonafide_post_artifact = "artifacts/bonafide.random_phase.flac";
path_to_spoofed_post_artifact = "artifacts/spoof.random_phase.flac";

maximum_sample_duration_in_seconds = 3;

path_to_processing_functions = "processing_functions";
addpath(path_to_processing_functions);
processing_function = @processing_diff_phase;

addpath("utils");

%% Read audio

[ spoof, ~ ] = audioread(path_to_spoofed_speech);
if length(spoof) > maximum_sample_duration_in_seconds * fs
    spoof = spoof(1:maximum_sample_duration_in_seconds * fs, 1);
end
[ bonafide, ~ ] = audioread(path_to_bonafide_speech);
if length(bonafide) > maximum_sample_duration_in_seconds * fs
    bonafide = bonafide(1:maximum_sample_duration_in_seconds * fs, 1);
end

%% PLOT SPECTROGRAM BEFORE PROCESSING
if should_show_spectrograms
    [ spect_spoof, f_axis, t_axis ] = create_spectrogram(spoof, fs, spectrogram_window_length);
    plot_spectrogram(spect_spoof(1:spectrogram_window_length/2, :), f_axis, t_axis, 1); title("Spoof before processing");
    
    [ spect_bonafide, f_axis, t_axis ] = create_spectrogram(bonafide, fs, spectrogram_window_length);
    plot_spectrogram(spect_bonafide(1:spectrogram_window_length/2, :), f_axis, t_axis, 2); title("Bonafide before processing");
end

%% Process audio

spoofed_filtered = processing_function(spoof);
bonafide_filtered = processing_function(bonafide);

%% SPECTROGRAM AFTER PROCESSING
if should_show_spectrograms
    [ spect_spoof_post, f_axis, t_axis ] = create_spectrogram(spoofed_filtered, fs, spectrogram_window_length);
    plot_spectrogram(spect_spoof_post(1:spectrogram_window_length/2, :), f_axis, t_axis, 3); title("Spoof after processing");
    
    [ spect_bonafide_post, f_axis, t_axis ] = create_spectrogram(bonafide_filtered, fs, spectrogram_window_length);
    plot_spectrogram(spect_bonafide_post(1:spectrogram_window_length/2, :), f_axis, t_axis, 4); title("Bonafide after processing");
end

%% PLAY AUDIO

if should_save_audio
    audiowrite(path_to_bonafide_post_artifact, bonafide_filtered ./ max(bonafide_filtered), fs);
    audiowrite(path_to_spoofed_post_artifact, spoofed_filtered ./ max(spoofed_filtered), fs);
end

if should_play_audio
    soundsc(bonafide_filtered ./ max(bonafide_filtered), fs);
    pause;
    soundsc(spoofed_filtered ./ max(spoofed_filtered), fs);
end
