function [output_signal, downsample_factor] = processing_dnsmpl_alias(input_signal, downsample_factor)
    %% README
    
    % This processing block downsamples the input without filtering to add
    % aliasing, then upsamples to return to 16kHz sample rate.
    
    %% Script
    if nargin == 1
        downsample_factor = floor(random_number_generator([1 11]));
    end
    downsampled_signal = input_signal(1:downsample_factor:end);
    output_signal = resample(downsampled_signal, downsample_factor, 1);
end