function [output_signal, w_pass] = processing_low_pass(input_signal, w_pass)
    %% README
    
    % This processing block is a lowpass filter.
    
    %% Script
    if nargin == 1
        w_pass = random_number_generator([0 .75]);
    end
    output_signal = lowpass(input_signal, w_pass);
end

