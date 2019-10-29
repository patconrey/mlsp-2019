function [output_signal] = processing_highpass(input_signal)
    %% README
    
    % This processing block is a high pass filter.
    
    %% Script
    w_pass = 0.325;
    output_signal = highpass(output_signal, w_pass);
end

