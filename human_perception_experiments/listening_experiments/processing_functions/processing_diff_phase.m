function [output_signal, dphase] = processing_diff_phase(input_signal, dphase)
    %% README
    
    % This processing block reconstructs the input signal with a different
    % phase
    
    %% Script
    N = 256;
    fs = 16000;
    [X_I, X_Q] = stft_fbs_real(input_signal, hamming(N), N);
    [X_mag, X_dphase] = getMagdPhase(X_I, X_Q, fs);
    if nargin == 1
        dphase = zeros(size(X_dphase));
        half_dphase = random_number_generator([-pi, pi],[size(X_dphase,1)/2-1, size(X_dphase,2)]);
        dphase(2:end/2,:) = half_dphase;
        dphase(end/2+1,:) = random_number_generator([0, pi], [1, size(X_dphase,2)]);
        dphase(end/2+2:end,:) = -flipud(half_dphase);
    end
    output_signal = istft_MagdPhase(X_mag, dphase, fs);
end

