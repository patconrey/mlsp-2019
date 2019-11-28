%% Config

DFT_LENGTH = 640;
LIFTER_LENGTH = 12;
GAMMA = 0.3;
ALPHA = 0.4;

%% Read in Data

[signal, fs] = audioread("welcome16k.wav");

%% Get MODGDF

[group_phase, cepstral_features, t] = modified_group_delay_feature(signal, fs);

% modgdffs = zeros(12, size(segments, 1));
% for segment_index = 1:size(segments, 2)
%     segment = segments(:, segment_index);
%     modgdffs(:, segment_index) = modgdff(segment', DFT_LENGTH, GAMMA, ALPHA, LIFTER_LENGTH, 12,false);
% end

% plot(coefficients); xlabel("Frequency"); ylabel("Samples");
% title("Modified Group Delay");