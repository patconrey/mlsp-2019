function [output_signal, w_pass] = processing_band_stop(input_signal, w_pass)
    %% README
    
    % This processing block is a band pass filter.
    
    %% Script
    if nargin == 1
        w_low = random_number_generator([0.25 0.75]);
        w_high = random_number_generator([w_low, w_low+0.1]);
        w_pass = [w_low w_high];
    end
    output_signal = bandstop(input_signal, w_pass);
end