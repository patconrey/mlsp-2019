function [X_dph] = vocoder_792(X_dph, M, L)
% phase vocoder to slow down and speed up the speech

X_dph(:, 2:end) = X_dph(:, 2:end) * L / M;

end

