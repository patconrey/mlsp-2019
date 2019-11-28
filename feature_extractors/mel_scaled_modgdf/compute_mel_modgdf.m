%% Config

DFT_LENGTH = 512;
LIFTER_LENGTH = 12;
GAMMA = 0.3;
ALPHA = 0.4;

%% Read in Data

[signal, fs] = audioread("welcome16k.wav");

%% Create Mel Filter Banks
hz2mel = @(hz)(1127*log(1+hz/700)); % Hertz to mel warping function
mel2hz = @(mel)(700*exp(mel/1127)-700); % mel to Hertz warping function

number_of_filters = 32;
length_of_each_filter = floor(DFT_LENGTH/2) + 1;
frequency_limits = [0 fs/2];
[ filter_bank, ~, ~ ] = trifbank( number_of_filters, length_of_each_filter, frequency_limits, fs, hz2mel, mel2hz );

%% Get MODGDF

[group_phase, cepstral_features, t] = mel_modified_group_delay_feature(signal, fs, filter_bank);