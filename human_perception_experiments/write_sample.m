function [] = write_sample(filename, data, fs)
data = data ./ max(abs(data));
audiowrite(filename, data, fs);
end

