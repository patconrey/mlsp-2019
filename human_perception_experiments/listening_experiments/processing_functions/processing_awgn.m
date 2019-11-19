function [output_signal, snr] = processing_awgn(input_signal, snr)
    %% README
    
    % This processing block adds white Gaussian noise to the signal at 
    % random SNR (between -10 and 10dB).
    
    %% Script
    if nargin == 1
        snr = random_number_generator([5 15]);
    end
    output_signal = awgn(input_signal, snr, 'measured');
end

