import numpy as np
import scipy.io as sio 
from sklearn import mixture
from utils import load_and_expand_training_data
from joblib import load, dump

# Config
max_iterations = 10
number_of_mixtures = 512
covariance_type = "tied"

# Load Data
bonafide_features = load_and_expand_training_data("bonafideFeatureCell.mat")

# Train GMM for bonafide class
clf = mixture.GaussianMixture(n_components=number_of_mixtures, covariance_type=covariance_type, verbose=True, max_iter=max_iterations)
clf.fit(bonafide_features)
dump(clf, "artifacts/bonafide_gmm.joblib")