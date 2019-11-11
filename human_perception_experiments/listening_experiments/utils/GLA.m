function [x] = GLA(Y_mag, win_length, hop_length, n_iter, phase_init)
% This function implements the Griffin-Lim MSTFT reconstruction algorithm
% (LSEE-MSTFTM)

% Initialize
if nargin < 4
    n_iter = 32;
end
% Modified Hamming window
a = 0.54;
b = -0.46;
phi = pi/win_length;
wind = 2/sqrt(4*a^2+2*b^2)*(a+b*cos(2*pi*(0:win_length-1)'/win_length+phi));
% Calculate this power once only
wind_energy = sum(wind.^2);
% Use given phase
if nargin == 5
    phase = phase_init;
else
    % Otherwise, randomly initialize phase
    % Ensure Hermitian conjugate symmetry
    phase = zeros(size(Y_mag));
    half_phase = random_number_generator([-pi, pi],[size(Y_mag,1)/2-1, size(Y_mag,2)]);
    phase(2:end/2,:) = half_phase;
    phase(end/2+1,:) = random_number_generator([0, pi], [1, size(Y_mag,2)]);
    phase(end/2+2:end,:) = -flipud(half_phase);
    phase = unwrap(phase);
end

% Run the iterative algorithm
for iter = 1:n_iter
    % Calculate X_hat from given magnitude and current phase estimate
    X_hat = Y_mag.*exp(1j*phase);
    % Initialize new x variable
    x = zeros(((size(X_hat,2)-1)*hop_length)+win_length,1);
    % For each column of the STFT...
    for m = 1:size(X_hat,2)
        % Reconstruct the segment
        x_seg = ifft(X_hat(:,m), win_length);
        
        % Find the beginning and end indices of the segment in time
        start_ind = (m-1)*hop_length+1;
        end_ind = start_ind+length(x_seg)-1;
        % Sum terms at the corresponding indices
        x(start_ind:end_ind) = x(start_ind:end_ind) + x_seg.*wind/wind_energy;
    end
    % Get the new phase
    phase = unwrap(angle(STFT_DFT(x, win_length, hop_length, wind)));
end
x = real(x);
end

