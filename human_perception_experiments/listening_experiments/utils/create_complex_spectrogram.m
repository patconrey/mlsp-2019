function [ spect, f_axis, t_axis ] = create_complex_spectrogram( input, fs, number_of_channels, stride_in_samples )
% Feel free to use your own inputs
% Output is the spectogram using the FT method for STFTs
window = hamming(number_of_channels);

number_of_time_frames = ceil(length(input) / stride_in_samples);
output = zeros(number_of_channels, number_of_time_frames);
for time_frame_index = 1:number_of_time_frames
    time_start_index = 1 + stride_in_samples * (time_frame_index - 1);
    time_end_index = time_start_index + number_of_channels - 1;
    
    difference_from_end_of_signal_to_window_length = 0;
    if time_end_index > length(input)
        difference_from_end_of_signal_to_window_length = time_end_index - length(input);
        time_end_index = length(input);
    end
    
    time_frame = [input(time_start_index:time_end_index, 1); zeros(difference_from_end_of_signal_to_window_length, 1)];
    windowed_time_frame = time_frame .* window;
    frequency_components = fft(windowed_time_frame, number_of_channels);
    output(:, time_frame_index) = frequency_components;
end

spect = output;
f_axis = 0.5 * fs * (0 : floor(number_of_channels / 2) - 1) / floor(number_of_channels / 2);
t_axis = length(input) * (0 : number_of_time_frames - 1) / (number_of_time_frames * fs);

end