function [X_I, X_Q] = stft_fbs_real(x, wind, N, spacing)
% Implements STFT
if ~isvector(x) || ~isvector(wind)
    error('Signal and window must be vectors.');
end

if size(x,1) == 1
    x = x.';
end
if size(wind,1) == 1
    wind = wind.';
end

N_w = length(wind);
if nargin < 4
    spacing = 1;
    if nargin < 3
        N = N_w
    end
end

f = linspace(0, 1, N+1); 
f = f(1:end-1); 
n = (0:length(x)-1)';

i_sig = cos(2*pi*n*f);
q_sig = sin(2*pi*n*f);

x_matrix = x*ones(size(f));
X_I = filter(wind, 1, x_matrix.*i_sig);
X_Q = filter(wind, 1, x_matrix.*q_sig);

if (spacing > 1) && (spacing == floor(spacing))
    X_I_dec = [];
    X_Q_dec = [];
    for chan = 1:N
        X_I_dec = [X_I_dec, decimate(X_I(:,chan),spacing)];
        X_Q_dec = [X_Q_dec, decimate(X_Q(:,chan),spacing)];
    end
    X_I = X_I_dec;
    X_Q = X_Q_dec;
end

X_I = X_I.';
X_Q = X_Q.';
end

