 %% Config

path_to_experiment = "experiments.mat";

maximum_duration_in_seconds = 5;

silence_answer_output = true;

%% Load experiment

experiment = load(path_to_experiment).experiment_sources;

%% Greeting and Instructions
clc;
disp('Hi! Thank you for your help with this! We really appreciate your time.');
print_instructions();
disp('Press any key to play an example.');
pause;

%% Loop through sets

number_of_sets = length(experiment);
for set_index = 1:number_of_sets
    set = experiment(set_index);
    audio_files_in_set = set.presentation;
    
    disp(' ');
    disp(['Set ' num2str(set_index)]);
    
    set_done = false;
    while ~set_done
        % Play each audio sample
        for audio_index = 1:length(audio_files_in_set)
            path_to_sample = audio_files_in_set(audio_index);
            sample = read_in_sample(path_to_sample, maximum_duration_in_seconds);

            disp(['Playing sample ' num2str(audio_index)])
            soundsc(sample, 16000);
            pause; 
        end
        
        %Enter user input loop
        input_done = false;
        while ~input_done
            disp(' ');
            disp('Do you want to repeat any samples?');
            disp('Enter "n" to move on.');
            disp('Enter "r" to repeat all of the samples.');
            disp('Enter "rX" to repeat the Xth sample');
            disp('Enter "i" to see the instructions.');
            user_input = input('> ', 's');
            if strcmp(user_input, 'n')
                set_done = true;
                input_done = true;
                continue;
            elseif strcmp(user_input, 'r')
                input_done = true;
            elseif strcmp(user_input, 'r1')
                path_to_sample = audio_files_in_set(1);
                sample = read_in_sample(path_to_sample, maximum_duration_in_seconds);
                
                disp('Playing sample 1');
                soundsc(sample, 16000);
            elseif strcmp(user_input, 'r2')
                path_to_sample = audio_files_in_set(2);
                sample = read_in_sample(path_to_sample, maximum_duration_in_seconds);
                
                disp('Playing sample 2');
                soundsc(sample, 16000);
            elseif strcmp(user_input, 'r3')
                path_to_sample = audio_files_in_set(3);
                sample = read_in_sample(path_to_sample, maximum_duration_in_seconds);
                
                disp('Playing sample 3');
                soundsc(sample, 16000);
            elseif strcmp(user_input, 'r4')
                path_to_sample = audio_files_in_set(4);
                sample = read_in_sample(path_to_sample, maximum_duration_in_seconds);
                
                disp('Playing sample 4');
                soundsc(sample, 16000);
            elseif strcmp(user_input, 'i')
                print_instructions();
            else
                disp('Please enter valid input');
            end
        end
    end
    
    if ~silence_answer_output
        disp('Press any key for the answer.');
        pause;
        disp(['Outlier was sample ' num2str(set.index_of_outlier)]);  
    end
    
    disp('Press any key to move on.');
    pause;
end

    