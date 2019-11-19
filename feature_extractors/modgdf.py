import librosa
import numpy as np
import scipy as sp
from utils import buffer
import math

def modgdf(x, n_fft, sampling_rate = 16000, frame_length_seconds = 0.02, frame_overlap_seconds = 0.01, lifter_length = 8, gamma = 0.9, alpha = 0.4):
    y = x * np.arange(0, len(x))

    # Compute windowed segments
    frame_length_samples, frame_overlap_samples = int(math.floor(frame_length_seconds * sampling_rate)), int(math.floor(frame_overlap_seconds * sampling_rate))
    frames_x, frames_y = buffer(x, frame_length_samples, frame_overlap_samples, 'nodelay'), buffer(y, frame_length_samples, frame_overlap_samples, 'nodelay')
    window = np.hamming(frame_length_samples)
    window = window[:, np.newaxis]
    frames_x, frames_y = frames_x * window, frames_y * window

    # Compute DFT of windowed segments
    X, Y = np.fft.fftshift(np.fft.fft(frames_x, n_fft, axis = 0)), np.fft.fftshift(np.fft.fft(frames_y, n_fft, axis = 0))

    # Compute cepstrally smoothed version of X
    cepstrum_X = np.fft.ifft(np.log(np.abs(X))).real
    b, a = np.ones(lifter_length), 1.0
    S = sp.signal.lfilter(b, a, cepstrum_X, axis = 0)

    # Compute modified group delay function
    X_r, X_i = X.real, X.imag
    Y_r, Y_i = Y.real, Y.imag
    tau = (X_r * Y_r + X_i * Y_i) / (np.sign(S) * (np.abs(S) ** (gamma * 2)))
    tau_m = (tau / np.abs(tau)) * ((np.abs(tau)) ** alpha)

    # Compute the cepstrum of the modified group delay function
    return sp.fftpack.dct(tau_m, n = n_fft, axis = 0)

# Read in audio
x, sampling_rate = librosa.load("./welcome16k.wav", sr = 16000)
C = modgdf(x, n_fft = 1024)