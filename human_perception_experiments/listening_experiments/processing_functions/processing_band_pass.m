function [output_signal, w_pass] = processing_band_pass(input_signal, w_pass)
    %% README
    
    % This processing block is a band pass filter.
    
    %% Script
    if nargin == 1
        w_low = random_number_generator([0.25 0.75]);
        w_high = random_number_generator([w_low 0.75]);
        w_pass = [w_low w_high];
    end
    output_signal = bandpass(input_signal, w_pass);
end

