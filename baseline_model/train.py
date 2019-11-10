# Load Bonafide
import numpy as np
import scipy.io as sio 
from sklearn import mixture

# Config
max_iterations = 10
number_of_mixtures = 512
covariance_type = "tied"

# Load Data
bonafideFeatureCell = sio.loadmat("bonafideFeatureCell.mat")["genuineFeatureCell"]
# This will have a shape of (N, 1), where N is the number of samples.
# To access the zero-th sample, bonafideFeatureCell[0].item()

# Train GMM for bonafide class
clf = mixture.GaussianMixture(n_components=number_of_mixtures, covariance_type=covariance_type, verbose=True, max_iter=max_iterations)
# TODO: expand bonafideFeatureCell so that every row corresponds to a feature