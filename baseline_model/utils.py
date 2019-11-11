import numpy as np 
import scipy.io as sio
import math

def load_and_expand_training_data(path, number_of_samples = None):
    feature_cell = sio.loadmat(path)["genuineFeatureCell"]

    # Since this data is very large, we will sample it randomly
    number_of_samples = number_of_samples or int(math.floor(0.1 * len(feature_cell)))
    indices_of_samples = np.random.randint(0, len(feature_cell) + 1, size = number_of_samples)
    sampled_features = feature_cell[indices_of_samples, :]

    features = np.zeros((np.size(sampled_features[0].item(), axis = 0), 1))
    for cell in sampled_features:
        features = np.concatenate((features, cell.item()), axis = 1)

    return features.T

def load_and_expand_evaluation_data(path, number_of_samples = None):
    feature_cell = sio.loadmat(path)["genuineFeatureCell"]

    # Since this data is very large, we will sample it randomly
    number_of_samples = number_of_samples or int(math.floor(0.1 * len(feature_cell)))
    indices_of_samples = np.random.randint(0, len(feature_cell) + 1, size = number_of_samples)
    sampled_features = feature_cell[indices_of_samples, :]

    features = np.zeros((np.size(sampled_features[0].item(), axis = 0), 1))
    for cell in sampled_features:
        features = np.concatenate((features, cell.item()), axis = 1)

    return features.T
