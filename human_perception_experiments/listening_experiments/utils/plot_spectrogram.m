function [] = plot_spectrogram(spectrogram, f_axis, t_axis, figure_number)
    % This function with display a spectrgram at a specified figure
    % number. This function takes in an f_axis and a t_axis. If you're
    % obtaining the spectrogram from the function create_spectrogram, then
    % the axis inputs correspond to the outputs of create_spectrogram.
    
    figure(figure_number);
    imagesc(t_axis, f_axis, 10*log10(abs(spectrogram)));
    axis xy;
    colormap("jet");
    xlabel("Time [seconds]"); ylabel("Frequency [Hertz]"); colorbar;    
end