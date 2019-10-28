function output_signal = processing_awgn(input_signal)
    % This function is a black box to the rest of the
    % experiment pipeline. It needs to take in a column vector waveform of arbitrary
    % length and output a column vector waveform. The sampling frequency is assumed to be 16kHz.
    % This function can do anything to the waveform; the only thing that matters is 
    % its input and its output.
    %
    % Use this as a template for other processing blocks.
    
    %% README
    % This processing block adds white Gaussian noise to the signal at SNR -5dB.
    
    %% Script
    
    output_signal = awgn(input_signal, 10);
end

