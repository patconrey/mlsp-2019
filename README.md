# Human Perception Experiments
In order to run a listening experiment given some processing on the speech signals, follow the directions in the README section of the script `./human_perception_experiments/listening_experiments/listening_experiment.m`.

To generate an experiment, follow the guides in the README section of `/human_perception_experiments/generate_experiment.m`. Similarly, to play an experiment, follow the README in `/human_perception_experiments/play_experiment.m`

# Feature Extractors
Currently we have functions to extract: 
- modified group delay function [1]

# Baseline Model
We ran into memory constraints when trying to train the baseline model in MATLAB. Since the model is a simple GMM, we're implementing it in Python so we can run it on a bigger machine. The features are currently being computed via the baseline script in MATLAB.

# Bibliography
[1] Hedge, R. M., Murthy, H. A. "Significance of the Modified Group Delay Feature"
