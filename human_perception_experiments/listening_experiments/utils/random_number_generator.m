function result = random_number_generator(range, sz)
%% README

    % This function returns a random number in a specific range
    % INPUT
    %   range -- [upper_bound, lower_bound] -- 1x2 vector
    %   size -- [dim1, dim2, ... dimN]
    % OUTPUT
    %   result -- 1x1 random number or random vector of specified size
    
%% Script
    if nargin == 1
        upper_bound = range(2);
        lower_bound = range(1);
        result = (upper_bound-lower_bound)*rand(1)+lower_bound;
    elseif nargin == 2
        upper_bound = range(2);
        lower_bound = range(1);
        result = (upper_bound-lower_bound)*rand(sz)+lower_bound*ones(sz);
    end
end

