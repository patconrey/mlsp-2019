function [output_signal] = processing_highpass(input_signal)
    %% README
    
    % This processing block is a high pass filter.
    
    %% Script
    w_pass = random_number_generator([0 1]);
    output_signal = highpass(input_signal, w_pass);
end

