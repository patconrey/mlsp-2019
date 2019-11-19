import numpy as np
import scipy.io as sio 
from sklearn import mixture
from utils import load_and_expand_training_data
from joblib import load, dump

# Config
path_to_bonafide_classifier_artifact = "artifacts/bonafide_gmm.joblib"
path_to_spoofed_classifier_artifact = "something/spoofed_gmm.joblib"

# Load Data
evaluation_features = load_and_expand_training_data("evaluationFeatureCell.mat")

# Create classifiers
bonafide_clf = load(path_to_bonafide_classifier_artifact)
spoofed_clf = load(path_to_spoofed_classifier_artifact)

scores = zeros(len(evaluation_features))
