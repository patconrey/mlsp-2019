function [signal] = read_in_sample(path, maximum_duration_in_seconds)
fs = 16000;
[ signal, ~ ] = audioread(path);
if length(signal) > maximum_duration_in_seconds * fs
    signal = signal(1:maximum_duration_in_seconds * fs, 1);
end
end

