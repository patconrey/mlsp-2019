import numpy as np
import pandas as pd
from utils import log, buffer

#
# CONFIG
#
path_to_dataset = "../dataset"
dataset_segment = "train"
iteration_hash = "new_modgdf"

WINDOW_LENGTH = 400 # 0.025 s -> 400 samples at 16kHz
OVERLAP = 200 # 50% overlap based on window_length

#
# GET PROTOCOLS
#
log("Reading protocols.")
protocol_file_path = ""
if dataset_segment == "train":
    protocol_file_path = path_to_dataset + "/LA/ASVspoof2019_LA_cm_protocols/ASVspoof2019.LA.cm.train.trn.txt"

protocol = pd.read_csv(protocol_file_path, sep=" ")
protocol = np.asarray(protocol)

spoof_protocol = protocol[protocol[1, 5] == "spoof"][:, 1] # Shape (N,) array of file names
bonafide_protocol = protocol[protocol[1, 5] == "bonafide"][:, 1] # Shape (M,) array of file names
log("Done!")

#
# COMPUTE SPOOF FEATURES
#
log("Computing spoof features.")
file_name_prefix = path_to_dataset + "/LA/ASVspoof2019_LA_" + dataset_segment + "/flac"
spoof_feature_cell = np.zeros(spoof_protocol.shape, dtype=np.object)
for index, spoofed_filename in enumerate(spoof_protocol):
    signal, sr = audioread(file_name_prefix + spoofed_filename + ".flac")
    segments = buffer(signal, WINDOW_LENGTH, OVERLAP)
    # Chunk signal according to window length with overlap
    # Compute MODGDF of the frame
    features = []
    spoof_feature_cell[index] = features

savemat("spoof_features_" + iteration_hash + ".mat", { "spoof_features": spoof_feature_cell })  
log("Done!")

#
# COMPUTE BONA FIDE FEATURES
#
log("Computing bona fide features.")
bonafide_feature_cell = np.zeros(bonafide_protocol.shape, dtype=np.object)
for index, bonafide_filename in enumerate(bonafide_protocol):
    signal, sr = audioread(file_name_prefix + bonafide_feature_cell + ".flac")
    # Chunk signal according to window length with overlap
    # Compute MODGDF of the frame
    features = []
    bonafide_feature_cell[index] = features

savemat("bonafide_features_" + iteration_hash + ".mat", { "bonafide_features": bonafide_feature_cell })  
log("Done!")