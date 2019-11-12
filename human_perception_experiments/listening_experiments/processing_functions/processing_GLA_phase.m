function [output_signal, hop_length] = processing_GLA_phase(input_signal, hop_length)
    %% README
    
    % This processing block reconstructs the input signal with a phase
    % generated by the Griffin and Lim Algorithm starting with a completely
    % randomized phase. The thing that changes between tests is the hop
    % length.
    
    %% Script
    % Initialize
    win_length = 512;
    iterations = 32;
    
    if nargin == 1
       hop_length = floor(random_number_generator([128 512]));
    end
    
% Modified Hamming window
%     a = 0.54;
%     b = -0.46;
%     phi = pi/win_length;
%     wind = 2/sqrt(4*a^2+2*b^2)*(a+b*cos(2*pi*(0:win_length-1)'/win_length+phi));
    % Use a rectangular window for arbitrary window spacing
    wind = rectwin(win_length);
    
    % Acquire the magnitude only
    spectrogram = STFT_DFT(input_signal, win_length, hop_length, wind);
    signal_mag = abs(spectrogram);
    
    % Run function
    output_signal = GLA(signal_mag, win_length, hop_length, wind, iterations);
end

