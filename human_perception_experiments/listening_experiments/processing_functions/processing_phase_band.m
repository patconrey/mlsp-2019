function [output_signal, band_limits] = processing_phase_band(input_signal, band_limits)
    %% README
    
    % This processing block reconstructs the input signal with the original
    % phase, but a strip of the original phase has been randomized.
    
    %% Script
    N = 256;
    fs = 16000;
    [X_I, X_Q] = stft_fbs_real(input_signal, hamming(N), N);
    X_mag = sqrt(X_I.^2+X_Q.^2);
    X_phase = angle(X_I-1j*X_Q);
    if nargin == 1
        low = floor(random_number_generator([2, floor(size(X_phase,1)/2)]));
        high = floor(random_number_generator([low+1, floor(size(X_phase,1)/2)]));
        band_limits = [low, high];
    else
        low = band_limits(1);
        high = band_limits(2);
    end
    % Generate a block of random phase 
    rand_phase_block = unwrap(random_number_generator([-pi, pi], [high-low+1, size(X_phase,2)]));
    phase = X_phase;
    phase(low:high,:) = rand_phase_block;
    phase(size(phase,1)-high:size(phase,1)-low,:) = -flipud(rand_phase_block);
    Y = X_mag.*exp(1j*phase);
    output_signal = real(iSTFT_FBS(Y));
end

