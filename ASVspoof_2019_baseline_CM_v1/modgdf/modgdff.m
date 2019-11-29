function [coefficients] = modgdff(signal, nfft, gamma, alpha, lifter_length, number_of_coefficients, verbose)
signal = hamming(length(signal))' .* signal;

% Premphasize signal

preemphasis_filter_b = [1 -.97];
preemphasized_signal = filter(preemphasis_filter_b, 1, signal);

% Plot spectra

if verbose
    figure(1);
    subplot(3, 1, 1);
    plot(1:320, signal); xlabel("Samples"); ylabel("Amplitude");
    title("Signal");
    
    subplot(3, 1, 2);
    spectrum_original = fft(signal, nfft);
    plot((1:320) / 320, abs(spectrum_original(1:320))); xlabel("Frequency"); ylabel("Amplitude [dB]");
    title("Original Spectrum");
    
    subplot(3, 1, 3);
    spectrum_emphasized = fft(preemphasized_signal, nfft);
    plot((1:320) / 320, abs(spectrum_emphasized(1:320))); xlabel("Frequency"); ylabel("Amplitude [dB]");
    title("Emphasized Spectrum");
end

% DFTs

signal = preemphasized_signal;

X = fft(signal, nfft);

y = (1:length(signal)) .* signal;
Y = fft(y, nfft);

% Cepstral Smoothing

cepstrum = real(ifft(log(abs(fft(signal, nfft)))));
lifter_1 = (1:floor(lifter_length / 2)) ./ floor(lifter_length / 2);
lifter = [lifter_1 fliplr(lifter_1)];
smooth_cepstrum = filter(lifter, 1, cepstrum);

if verbose
    figure(2);
    subplot(2, 1, 1);
    plot((1:320) / 320, cepstrum(1:320)); xlabel("Frequency"); ylabel("Amplitude");
    title("Original Cepstrum");
    
    subplot(2, 1, 2);
    plot((1:320) / 320, smooth_cepstrum(1:320)); xlabel("Frequency"); ylabel("Amplitude");
    title("Smoothed Cepstrum");
end

% Compute Group Delay

S = smooth_cepstrum;
X_r = real(X);
X_i = imag(X);
Y_r = real(Y);
Y_i = imag(Y);

% tau_regular = (X_r .* Y_r + Y_i .* X_i) ./ (abs(X) .^ 2);

% Compute MODGDF

tau = ((X_r .* Y_r) + (Y_i .* X_i)) ./ (S.^(2 * gamma));
tau_m = (tau ./ abs(tau)) .* (abs(tau) .^ alpha);

modgdf = tau_m;

if verbose
    figure(3)

    subplot(2, 1, 1);
    plot((1:320) / 320, abs(tau_m(1:320))); xlabel("Frequency"); ylabel("Samples");
    title("Modified Group Delay");

    subplot(2, 1, 2);
    plot((1:320) / 320, tau_regular(1:320)); xlabel("Frequency"); ylabel("Samples");
    title("Regular Group Delay");
end

coefficients = dct(abs(tau_m), number_of_coefficients);

end

