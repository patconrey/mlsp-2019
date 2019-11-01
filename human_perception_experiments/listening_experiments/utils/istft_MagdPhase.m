function [x] = istft_MagdPhase(X_mag, X_dph, fs, spacing)
% Resynthesizes the signal x from the magnitude and phase-derivative of its 
% STFT
if any(size(X_mag) ~= size(X_dph))
    error('Magnitude and phase matrices must be of the same size.');
end
N = size(X_mag,1);
if nargin < 4
    spacing = 1;
    if nargin < 3
        fs = 1;
    end
end

X_mag = X_mag.';
X_dph = X_dph.';

if (spacing > 1) && (spacing == floor(spacing))
    X_mag_int = [];
    X_dph_int = [];
    for chan = 1:N
        X_mag_int = [X_mag_int, interp(X_mag(:, chan), spacing)];
        X_dph_int = [X_dph_int, interp(X_dph(:, chan), spacing)];
    end
    X_mag = X_mag_int;
    X_dph = X_dph_int;
end

N_frame = size(X_mag,1);
f = linspace(0, 1, N+1);
f = f(1:end-1);
n = (0:N_frame-1)';

X_dph(2:end, :) = X_dph(2:end, :)/fs;
X_ph = cumsum(X_dph);

mod_sig = cos(2*pi*n*f+X_ph);

x = sum(X_mag .* mod_sig, 2);
end