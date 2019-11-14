function [ x ] = iSTFT_OLA( input, stride_in_samples )
[ number_of_frequency_bins , number_of_time_steps ] = size(input);
output = zeros(1, stride_in_samples * (number_of_time_steps));

for time_frame_index = 1:number_of_time_steps
    time_frame = input(:, time_frame_index);
    
    current_idft = ifft(time_frame, number_of_frequency_bins)';
    
    current_time_offset = 1 + (stride_in_samples * (time_frame_index - 1));
    current_time_end = current_time_offset + length(current_idft) - 1;
    
    if current_time_end > length(output)
        current_time_end = length(output);
        current_idft = current_idft(1:(current_time_end - current_time_offset + 1));
    end
    
    output(1, current_time_offset:current_time_end) = output(1, current_time_offset:current_time_end) + current_idft;
end

x = output;

end