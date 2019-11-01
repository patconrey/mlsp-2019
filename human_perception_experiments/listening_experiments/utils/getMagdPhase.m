function [mag, dphase] = getMagdPhase(I,Q,fs)
% Returns the magnitude and phase derivative
if any(size(I) ~= size(Q))
    error('Real and imaginary matrices must sbe of the same size.');
end
if nargin < 3
    fs = 1;
end

mag = sqrt(I.^2+Q.^2);
I_diff = [I(:,1), fs*diff(I,1,2)];
Q_diff = [Q(:,1), fs*diff(Q,1,2)];
dphase = (Q.*I_diff-I.*Q_diff)./mag.^2;

dphase(:,1) = angle(I(:,1) - 1j*Q(:,1));
end

