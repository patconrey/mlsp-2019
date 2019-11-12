function [x] = iSTFT_FBS(input)
%%% Feel free to use your own inputs
%%% Output is the time-domain signal using FBS
N = size(input,1);
x = zeros(size(input,2),1);
for k = 0:N-1
   w_k = 2*pi*k/N;
   current = exp(1j*w_k*(0:length(x)-1)');
   x = x + (input(k+1,:).').*current;
end
w = hamming(N);
x = x./(N*w(1));
end
