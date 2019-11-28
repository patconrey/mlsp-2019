%% Config

DFT_LENGTH = 640;
LIFTER_LENGTH = 12;
GAMMA = 0.3;
ALPHA = 0.4;

%% Read in Data

[signal, fs] = audioread("welcome16k.wav");
signal = signal(1:320)';
segments = buffer(signal, 320, 160);

% fs = 16000;
% y1 = sin(2 * pi * .09 * (1:(0.02 * fs)));
% y2 = sin(2 * pi * .3 * (1:(0.02 * fs)));
% signal = y1 + y2;
% 
% signal = hamming(length(signal))' .* signal;

%% Get MODGDF

[group_phase, cepstral_features, t] = modified_group_delay_feature("welcome16k.wav");

% modgdffs = zeros(12, size(segments, 1));
% for segment_index = 1:size(segments, 2)
%     segment = segments(:, segment_index);
%     modgdffs(:, segment_index) = modgdff(segment', DFT_LENGTH, GAMMA, ALPHA, LIFTER_LENGTH, 12,false);
% end

% plot(coefficients); xlabel("Frequency"); ylabel("Samples");
% title("Modified Group Delay");