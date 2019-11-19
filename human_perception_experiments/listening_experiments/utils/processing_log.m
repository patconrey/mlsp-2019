function log_string = processing_log(path_to_experiment_table, file_name, function_handle, specifications)
%% README
% This function outputs a string to track the preprocessing done on each
% sample

%% Script
if isequal(function_handle, @processing_high_pass)
    function_name = 'processing_high_pass';
    spec_string = sprintf('%3.3f', specifications);
elseif isequal(function_handle, @processing_low_pass)
    function_name = 'processing_low_pass';
    spec_string = sprintf('%3.3f', specifications);
elseif isequal(function_handle, @processing_band_pass)
    function_name = 'processing_band_pass';
    spec_string = sprintf('%3.3f %3.3f', specifications(1), specifications(2));
elseif isequal(function_handle, @processing_awgn)
    function_name = 'processing_awgn';
    spec_string = sprintf('%3.3f', specifications);
elseif isequal(function_handle, @processing_band_stop)
    function_name = 'processing_band_stop';
    spec_string = sprintf('%3.3f %3.3f', specifications(1), specifications(2));
elseif isequal(function_handle, @processing_diff_dphase)
    function_name = 'processing_diff_dphase';
    spec_string = [];
elseif isequal(function_handle, @processing_dnsmpl_alias)
    function_name = 'processing_dnsmpl_alias';
    spec_string = sprintf('%d', specifications);
elseif isequal(function_handle, @processing_GLA_phase)
    function_name = 'processing_GLA_phase';
    spec_string = sprintf('%d', specifications);
elseif isequal(function_handle, @processing_high_phase_band)
    function_name = 'processing_high_phase_band';
    spec_string = sprintf('%d %d', specifications(1), specifications(2));
elseif isequal(function_handle, @processing_low_phase_band)
    function_name = 'processing_low_phase_band';
    spec_string = sprintf('%d %d', specifications(1), specifications(2));
elseif isequal(function_handle, @processing_mid_phase_band)
    function_name = 'processing_mid_phase_band';
    spec_string = sprintf('%d %d', specifications(1), specifications(2));
elseif isequal(function_handle, @processing_none)
    function_name = 'processing_none';
    spec_string = [];
else
    spec_string = 'Error';
end
log_string = strcat(path_to_experiment_table, '; ', file_name, '; ', function_name, '; ', spec_string);
fid = fopen('log.txt', 'at');
fprintf(fid, '%s\n', log_string);
fclose(fid);
end

