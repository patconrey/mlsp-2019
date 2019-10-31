function output_signal = processing_high_pass(input_signal)
    % This function is a black box to the rest of the
    % experiment pipeline. It needs to take in a column vector waveform of arbitrary
    % length and output a column vector waveform. The sampling frequency is assumed to be 16kHz.
    % This function can do anything to the waveform; the only thing that matters is 
    % its input and its output.
    %
    % Use this as a template for other processing blocks.
    
    %% README
    
    % This processing block is a high pass filter.
    
    %% Script
    w_pass = random_number_generator([0 1]);
    output_signal = highpass(input_signal, w_pass);
end

