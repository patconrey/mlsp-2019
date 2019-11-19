 %% Config

path_to_experiment = "experiments.mat";

%% Load experiment

experiment = load(path_to_experiment).experiment_sources;

%% Loop through sets

answers = zeros(1, length(experiment));
number_of_sets = length(experiment);
for set_index = 1:number_of_sets
    set = experiment(set_index);
    answers(set_index) = set.index_of_outlier;
end