import matplotlib.pyplot as plt
import numpy as np

def plot_spectrogram(spect, title):
    midpoint = int(np.floor(np.size(spect, 0) / 2))
    spect_to_show = 10 * np.log(np.abs(spect[midpoint:-1]))
    plt.imshow(spect_to_show, origin='lower', aspect='auto')
    plt.colorbar(orientation='horizontal')
    plt.title(title)
    plt.show()

def plot_fft(fft, fs, title):
    midpoint = int(np.floor(len(fft) / 2))
    fft_to_plot = fft[midpoint:-1]
    x_axis = np.arange(0, len(fft_to_plot)) / len(fft_to_plot)
    plt.plot(x_axis, np.abs(fft_to_plot), linewidth = 0.75, c = 'black')
    plt.ylabel('Magnitude')
    plt.xlabel('Normalized Frequency')
    plt.xlim(0, 1)
    plt.title(title)
    plt.grid(linewidth = 0.2)
    plt.show()

# https://stackoverflow.com/questions/38453249/is-there-a-matlabs-buffer-equivalent-in-numpy
def buffer(X, n, p=0, opt=None):
    '''Mimic MATLAB routine to generate buffer array

    MATLAB docs here: https://se.mathworks.com/help/signal/ref/buffer.html

    Parameters
    ----------
    x: ndarray
        Signal array
    n: int
        Number of data segments
    p: int
        Number of values to overlap
    opt: str
        Initial condition options. default sets the first `p` values to zero,
        while 'nodelay' begins filling the buffer immediately.

    Returns
    -------
    result : (n,n) ndarray
        Buffer array created from X
    '''

    if opt not in [None, 'nodelay']:
        raise ValueError('{} not implemented'.format(opt))

    i = 0
    first_iter = True
    while i < len(X):
        if first_iter:
            if opt == 'nodelay':
                # No zeros at array start
                result = X[:n]
                i = n
            else:
                # Start with `p` zeros
                result = np.hstack([np.zeros(p), X[:n-p]])
                i = n-p
            # Make 2D array and pivot
            result = np.expand_dims(result, axis=0).T
            first_iter = False
            continue

        # Create next column, add `p` results from last col if given
        col = X[i:i+(n-p)]
        if p != 0:
            col = np.hstack([result[:,-1][-p:], col])
        i += n-p

        # Append zeros if last row and not length `n`
        if len(col) < n:
            col = np.hstack([col, np.zeros(n-len(col))])

        # Combine result with next row
        result = np.hstack([result, np.expand_dims(col, axis=0).T])

    return result

