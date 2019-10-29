function result = random_number_generator(range)
%% README

    % This function returns a random number in a specific range
    % INPUT
    %   range -- [upper_bound, lower_bound] -- 1x2 vector
    % OUTPUT
    %   result -- 1x1 random number
    
%% Script
    if nargin == 1
        upper_bound = range(2);
        lower_bound = range(1);
        result = (upper_bound-lower_bound)*rand(1)+lower_bound;
    end
end

