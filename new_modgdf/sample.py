import matplotlib.pyplot as plt
from audlib.sig.cepstral import zp2ccep
from audlib.plot import magresp
import numpy as np
from numpy.fft import rfft, irfft

from audlib.quickstart import welcome
STARTPOS = 8000
WINDOW_LENGTH = .025  # in seconds

sig, sr = welcome()
wsize = int(WINDOW_LENGTH*sr)
eesig = sig[STARTPOS:STARTPOS+wsize]  # a segment of 'ee' sound in 'dee'

fig, ax = plt.subplots(figsize=(16, 4))
ax.plot(eesig)
ax.set_xlim(0, wsize)
ax.set_xlabel('Samples'); ax.set_ylabel('Amplitude')
plt.show()

from audlib.sig.window import hamming
from audlib.sig.util import nextpow2, firfreqz
from audlib.sig.cepstral import ccep_zt, rcep_dft
from audlib.sig.spectral import logmag
from numpy.fft import rfft


def gdf_naive(sig, n):
    x = rfft(sig, n)
    y = rfft(sig*np.arange(len(sig)), n)
    return (x.real*y.real + x.imag*y.imag) / (x.real**2 + x.imag**2)


def gdf(sig, n):
    """Group delay function.
    
    Parameters
    ----------
    sig: numpy.ndarray
        Time-domain signal to be processed.
    nfft: int, None
        DFT size. Default to len(sig).

    """
    ccep = ccep_zt(sig, n)
    dd = .5*(ccep-ccep[::-1])[n-1:]  # only right-sided is needed
    #dd[30:] = 0  # low-pass lifter
    return rfft(2*dd*np.arange(n), n).real


def modgdf(sig, n, ncep=8, alpha=.4, gamma=.9):
    """Modified group delay function.
    
    Parameters
    ----------
    sig: numpy.ndarray
        Time-domain signal to be processed

    """
    def cepsmooth(spec):
        cep = irfft(logmag(spec), n)
        cep[ncep:len(cep)-(ncep-1)] = 0
        return np.exp(rfft(cep, n).real)
        
    x = rfft(sig, n)
    y = rfft(sig*np.arange(len(sig)), n)
    tau = (x.real*y.real + x.imag*y.imag) / cepsmooth(np.abs(x))**(2*gamma)
    gdf = np.abs(tau)**alpha
    gdf[tau < 0] *= -1

    return gdf


nfft = max(1024, nextpow2(len(eesig)))
wind = hamming(wsize)
ww, eespec = firfreqz(wind*eesig, nfft)

fig, ax = plt.subplots(figsize=(16, 4))
ax.plot(ww[:(nfft//2+1)]*sr/2, modgdf(wind*eesig, nfft, 6), label='MODGDF')
ax.plot(ww[:(nfft//2+1)]*sr/2, 20*np.log10(np.abs(eespec[:(nfft//2+1)])), label=r'Log spectra')
ax.set_xlim(0, sr/2)
ax.set_xlabel(r'Normalized frequency (Hz)'); ax.set_ylabel('Amplitude')
plt.legend()
plt.show()

# Do the group delay function on the LPC spectra
from audlib.sig.temporal import lpc_parcor, ref_is_stable, lpcerr
from audlib.sig.temporal import ref2pred, pred2poly
from audlib.sig.util import freqz
from audlib.sig.cepstral import roots, p2ccep, zp2ccep

LPC_ORDER = 16  # or anything reasonable


def lpcgdf(sig, order=14, n=None, lifter=False):
    """Group delay function on the LPC spectra.
    
    Parameters
    ----------
    sig: numpy.ndarray
        Time-domain signal to be processed.
    order: int, 14
        LPC order.
    nfft: int, None
        DFT size. Default to len(sig).

    """
    xks, xgain = lpc_parcor(sig, order)
    assert ref_is_stable(xks), "Unstable system!"
    xpolys = pred2poly(ref2pred(xks))
    cpoles, rpoles, gain = roots(xpolys)
    ccep = p2ccep(cpoles, rpoles, xgain/gain, n)
    if lifter:
        ccep *= np.exp(-np.arange(n)**2/(2*30**2))

    return rfft(ccep*np.arange(n), n).real
    

def modgdfpz(sig, order, n, fac=1.2):
    pks, pgain = lpc_parcor(sig, order)
    assert ref_is_stable(pks), "Unstable system!"
    alphas = ref2pred(pks)
    cpoles, rpoles, _ = roots(pred2poly(alphas))
    wsig = lpcerr(sig, alphas, pgain)
    (cmags, cphases), rzeros, zgain = roots(wsig)

    # manually push zeros away from the UC
    cmags[np.logical_and(cmags < 1, cmags > 1/fac)] /= fac
    cmags[np.logical_and(cmags > 1, cmags < fac)] *= fac
    rzeros[np.logical_and(np.abs(rzeros) < 1, np.abs(rzeros) > 1/fac)] /= fac
    rzeros[np.logical_and(np.abs(rzeros) > 1, np.abs(rzeros) < fac)] *= fac

    ccep = zp2ccep((cmags, cphases), rzeros, cpoles, rpoles, pgain*zgain, n)[n-1:]

    return rfft(ccep*np.arange(n), n).real


eelpcgdf = lpcgdf(wind*eesig, LPC_ORDER, nfft, lifter=False)
ks, gain = lpc_parcor(wind*eesig, LPC_ORDER)
polys = pred2poly(ref2pred(ks))
_, eelpcspec = freqz([gain], polys, nfft)

fig, ax = plt.subplots(figsize=(16, 4))
ax.plot(ww[:(nfft//2+1)]*sr/2, 20*np.log10(np.abs(eelpcspec[:(nfft//2+1)])), label='LPC log-spectra')
ax.plot(ww[:(nfft//2+1)]*sr/2, eelpcgdf, label='LPC-GDF')
ax.plot(ww[:(nfft//2+1)]*sr/2, modgdfpz(wind*eesig, LPC_ORDER, nfft, 1.4), label='MODGDFpz')
ax.plot(ww[:(nfft//2+1)]*sr/2, 20*np.log10(np.abs(eespec[:(nfft//2+1)])), label='Log-spectra')
ax.set_xlim(0, sr/2)
ax.set_xlabel(r'Normalized frequency (Hz)'); ax.set_ylabel('Amplitude')
plt.legend()
plt.show()