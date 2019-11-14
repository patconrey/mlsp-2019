function [ output_signal ] = processing_selected_random_phase(input_signal)
%% README
% This function will alter the phase of high frequency bands. It will add a
% random number to the phase at each time bin.

[spect, f_axis, t_axis] =  create_complex_spectrogram( input_signal, 16000, 512, 256 );
[number_of_channels, number_of_time_bins] = size(spect);
positive_frequency_spect = spect(1 : floor(number_of_channels / 2), :);
positive_frequency_phase = angle(positive_frequency_spect);

[number_of_positive_channels, ~] = size(positive_frequency_spect);
high_frequency_band = positive_frequency_spect(floor(end - (number_of_positive_channels / 3) + 1) : end, :);
[number_of_high_frequency_channels, ~] = size(high_frequency_band);

random_phase_vectors = (2 * pi * rand(1, number_of_time_bins)) - pi;
random_phase_vectors = repmat(random_phase_vectors, number_of_high_frequency_channels, 1);
altered_high_frequency_band = angle(high_frequency_band) + random_phase_vectors;

phase_of_altered_spectrogram = [altered_high_frequency_band; positive_frequency_phase(1 : end - number_of_high_frequency_channels, :)];

total_altered_phase = [ -1 * flipud(phase_of_altered_spectrogram); phase_of_altered_spectrogram];
output_signal_spect = abs(spect) .* exp(1j * total_altered_phase);

signal = iSTFT_OLA( output_signal_spect, 256 );

disp(size(signal));

output_signal = [];
end

