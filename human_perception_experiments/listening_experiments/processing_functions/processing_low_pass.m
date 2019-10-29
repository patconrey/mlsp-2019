function output_signal = processing_low_pass(input_signal)
    %% README
    
    % This processing block is a lowpass filter.
    
    %% Script
    w_pass = random_number_generator([0 1]);
    output_signal = lowpass(input_signal, w_pass);
end

