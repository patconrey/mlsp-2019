%% Config

path_to_experiment = "experiments.mat";

maximum_duration_in_seconds = 5;

silence_answer_output = false;

%% Load experiment

experiment = load(path_to_experiment).experiment_sources;

%% Loop through sets

number_of_sets = length(experiment);
for set_index = 1:number_of_sets
    set = experiment(set_index);
    audio_files_in_set = set.presentation;
    
    disp(' ');
    disp(['Set ' num2str(set_index)]);
    
    % Play each audio sample
    for audio_index = 1:length(audio_files_in_set)
        path_to_sample = audio_files_in_set(audio_index);
        sample = read_in_sample(path_to_sample, maximum_duration_in_seconds);
        
        disp(['Playing sample ' num2str(audio_index)])
        soundsc(sample, 16000);
        pause; 
    end
    
    if ~silence_answer_output
        disp('Press any key for answer');
        pause;
        disp(['Outlier was sample ' num2str(set.index_of_outlier)]);  
    end
    
    disp('Press any key to move on.');
    pause;
end

    