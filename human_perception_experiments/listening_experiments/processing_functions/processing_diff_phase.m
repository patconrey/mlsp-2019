function [output_signal, phase] = processing_diff_phase(input_signal, phase)
    %% README
    
    % This processing block reconstructs the input signal with a different
    % phase. The default is a random phase, which sounds like static. Thus,
    % it is recommended that a phase from different, equal-length signal is
    % used.
    
    %% Script
    N = 256;
    fs = 16000;
    [X_I, X_Q] = stft_fbs_real(input_signal, hamming(N), N);
    X_mag = getMagdPhase(X_I, X_Q, fs);
    if nargin == 1
        phase = zeros(size(X_mag));
        half_phase = random_number_generator([-pi, pi],[size(X_mag,1)/2-1, size(X_mag,2)]);
        phase(2:end/2,:) = half_phase;
        phase(end/2+1,:) = random_number_generator([0, pi], [1, size(X_mag,2)]);
        phase(end/2+2:end,:) = -flipud(half_phase);
    end
    Y = X_mag.*exp(1j*phase);
    output_signal = real(iSTFT_FBS(Y));
end

