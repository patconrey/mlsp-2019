function log_string = processing_log(function_name, specifications)
%% README
% This function outputs a string to track the preprocessing done on each
% sample

%% Script
if function_name == 'processing_high_pass'
    spec_string = sprintf('%3.3f', specifications);
elseif function_name == 'processing_low_pass'
    spec_string = sprintf('%3.3f', specifications);
elseif function_name == 'processing_band_pass'
    spec_string = sprintf('%3.3f %3.3f', specifications(1), specifications(2));
else
    spec_string = 'Error';
end
log_string = horzcat(function_name, ' ', spec_string);
end

