function [] = print_instructions()
disp(' ');
disp('INSTRUCTIONS');
disp('You will be listening to several sets of audio.');
disp('There are four audio samples in each set, and the samples come from two sources.');
disp('A sample is either "bonafide" or it is "spoofed".');
disp('A bonafide sample came from a person talking. A spoofed sample was synthesized by a computer.');
disp('In each set there is one sample that is not like the others.');
disp('There are two possible cases for each set:');
disp('- 3 samples are spoofed and 1 sample is bonafide.');
disp('- 3 samples are bonafide and 1 sample is spoofed.');
disp('Your job is to tell us which sample you think is different.');
disp('After each set plays, you will be able to repeat samples from the set or move on to the next set.');
disp(' ');
disp('Do you have any questions for us?');
disp(' ');
end