function [ spect, f_axis, t_axis ] = create_spectrogram( signal, fs, window_length )
% This function creates a spectrogram of the input signal. The input
% parameter fs corresponds to the sampling frequency. This function uses a
% Hamming window as the analysis window and its length is specified by the
% input parameter window_length. Since we are using a Hamming window, the
% maximum allowable downsampling ratio is given by half of the
% window_length. If the window_length is odd, then we floor the result to
% the nearest integer.
%
% This function outputs a spectrogram and the corresponding frequency and
% time axes which can be used to display it. The frequency axis goes from 0
% Hz to the Nyquist limit, so, when displaying the spectrogram, be sure to
% consider only show the positive frequency components. 

downsample_ratio = floor(window_length / 2);

number_of_time_steps = ceil(length(signal) / downsample_ratio);
w = hamming(window_length);
output = zeros(window_length, number_of_time_steps);

for k = 1:window_length
    
    n = 1:window_length;
    omega_k = 2 * pi * (k - 1) / (window_length - 1);
    
    real_branch_filter =  cos(omega_k .* n)' .* w;
    complex_branch_filter = sin(omega_k .* n)' .* w;
    real_branch = filter(real_branch_filter, 1, signal);
    complex_branch = filter(complex_branch_filter, 1, signal);
    
    total = real_branch.^2 + complex_branch.^2;
    
    output(k, :) = decimate(total, downsample_ratio);
end

spect = output;
f_axis = 0.5 * fs * (0 : floor(window_length / 2) - 1) / floor(window_length / 2);
t_axis = length(signal) * (0 : number_of_time_steps - 1) / (number_of_time_steps * fs);
end

