function [] = labels_bin_batch()
% Bins the labels
% Creates a batch script ('BatchFile_labels_bin.txt') to be processed from the terminal
% Run from the RetinotopyLabels/Labels folder 
% 
% fslmaths /home/user/RetinotopicLabels/Labels/subject0032/labels2vol/vol_V1.label.nii.gz 
% -bin /home/user/RetinotopicLabels/Labels/subject0032/labels2vol/mask_vol_V1.label.nii.gz 

dir_firstlevel_home = pwd; %/home/user/RetinotopyLabels/Labels

% Need to make all the labels
labels{1} ='mni_vol_V1.label.nii.gz';
labels{2} ='mni_vol_V2.label.nii.gz';
labels{3} ='mni_vol_V3.label.nii.gz';
labels{4} ='mni_vol_V3AB.label.nii.gz';
labels{5} ='mni_vol_V4.label.nii.gz';

labels{6} ='vol_V1.label.nii.gz';
labels{7} ='vol_V2.label.nii.gz';
labels{8} ='vol_V3.label.nii.gz';
labels{9} ='vol_V3AB.label.nii.gz';
labels{10} ='vol_V4.label.nii.gz';

% print to file
batch_file = strcat(dir_firstlevel_home, {'/'}, 'BatchFile_labels_bin.txt'); % name of bash script
batch_file = char(batch_file);
fid = fopen(batch_file,'w');
fprintf(fid, '#!/bin/sh \n');     

%count how many folders are in the Current directory and get folder names
    number_subjects = length(dir('subject*'));
    all_folders = dir('subject*');
   	    
	% Loop through all subjects, get their example_func files and specify output .DAT file
	for i=1:number_subjects
   
       	name = all_folders(i).name; %current directory
       	name = char(name);
       	
       	cd(name);
    
        	current_dir = pwd;
        	current_dir = char(current_dir);  %/home/user/RetinotopyLabels/Labels/subject0032/
        	
        for ilabels = 1:length(labels);
       		current_label = labels(ilabels);
       		current_label = char(current_label);
       		
       		fprintf(fid, 'fslmaths '); 
            fprintf(fid, current_dir); 
            fprintf(fid, '/labels2vol/');
            fprintf(fid, current_label); 
            fprintf(fid, ' -bin '); 
            fprintf(fid, current_dir); 
            fprintf(fid, '/labels2vol/mask_'); 
            fprintf(fid, current_label); 
            fprintf(fid, ' \n \n');           
       		
       	end
         
    	cd(dir_firstlevel_home);
    	
    end   
    
    fclose(fid);

end