function [ x ] = iSTFT_FBS( input )
%%% Feel free to use your own inputs
%%% Output is the time-domain signal using FBS
spect = input;
[number_of_frequency_channels, number_of_time_steps] = size(spect);

n = 1:number_of_time_steps;
output = zeros(1, number_of_time_steps);
for frequency_channel_index = 0:(number_of_frequency_channels - 1)
    frequency_channel = spect(frequency_channel_index + 1, :);
    omega_k = 2 * pi * frequency_channel_index / number_of_frequency_channels;
    phase_shift = exp(1j * omega_k * n);
    
    time_contribution_from_frequency = frequency_channel .* phase_shift;
    
    output = output + time_contribution_from_frequency;
end

x = output;

end
