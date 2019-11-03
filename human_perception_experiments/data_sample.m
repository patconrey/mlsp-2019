function [sampled_data] = data_sample(data, n)
   indices = randperm(length(data));
   indices = indices(1:n);
   sampled_data = data(indices, 2);
end

