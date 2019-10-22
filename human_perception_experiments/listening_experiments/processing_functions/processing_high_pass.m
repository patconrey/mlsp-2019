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
    
    Fstop = 0.3;             % Stopband Frequency
    Fpass = 0.35;             % Passband Frequency
    Dstop = 0.0001;          % Stopband Attenuation
    Dpass = 0.057501127785;  % Passband Ripple
    dens  = 20;              % Density Factor
    
    [N, Fo, Ao, W] = firpmord([Fstop, Fpass], [0 1], [Dstop, Dpass]);
    b  = firpm(N, Fo, Ao, W, {dens});
    
    output_signal = filter(b, 1, input_signal);
end

