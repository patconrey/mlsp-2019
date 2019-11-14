function [output_signal, band_limits] = processing_mid_phase_band(input_signal, band_limits)
    %% README
    
    % This processing block reconstructs the input signal with the original
    % phase, but the top third strip of the original phase has been randomized.
    
    %% Script
    max_phase = 1; % This is the number that the ramp will reach before returning to 0.
    
    N = 256;
    [X_I, X_Q] = stft_fbs_real(input_signal, hamming(N), N);
    X_mag = sqrt(X_I.^2+X_Q.^2);
    X_phase = angle(X_I-1j*X_Q); % This ranges from -pi -> pi
    
    if nargin == 1
        low = floor(floor(size(X_phase,1)/2) * 0.333);
        high = floor(floor(size(X_phase,1)/2) * 0.666);
        band_limits = [low, high];
    else
        low = band_limits(1);
        high = band_limits(2);
    end
    
    % This block of code will add a constant to the phase band
    % rand_phase_block = 0.5 * ones(1, size(X_phase,2));
    % rand_phase_block = repmat(rand_phase_block, high-low+1, 1);
    
    % This block of code will add a random number between -.5 and .5 to
    % each time bin
    % rand_phase_block = rand(1, size(X_phase,2)) - 0.5;
    % rand_phase_block = repmat(rand_phase_block, high-low+1, 1);
    
    % This block of code will add a linearly increasing triangular ramp
    % starting at 0, reaching 1, and ending at 0 to the phase.
    rand_phase_block = [0 : 2 * max_phase / (size(X_phase, 2) - 1) : max_phase, max_phase : - 2 * max_phase / (size(X_phase, 2) - 1) : 0];
    rand_phase_block = repmat(rand_phase_block, high-low+1, 1);
    
    phase = X_phase + pi; % Set the lowest to zero and the highest to pi.
    
    phase(low:high,:) = phase(low:high,:) + rand_phase_block;
    phase(size(phase,1)-high:size(phase,1)-low,:) = -flipud(phase(low:high,:) + rand_phase_block);
    phase = mod(phase, 2 * pi) - pi;
    
    Y = X_mag.*exp(1j*phase);
    output_signal = real(iSTFT_FBS(Y));
end

