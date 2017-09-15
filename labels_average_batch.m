function [] = labels_average_batch()
% Average all subjects V1 together, then V2,V3,V4,V3AB
% This will give us four averaged images in MNI space representing the average retinotopic areas of all the participants.
% Creates a batch script ('BatchFile_labels_average.txt') to be processed from the terminal
% 
% fslmaths 1mni_vol_V1.label.nii.gz 
% -add 2mni_vol_V1.label.nii.gz 
% -add 3mni_vol_V1.label.nii.gz ... all subjects ... all_mni_vol_V1.label.nii.gz
% then
% fslmaths all_mni_vol_V1.label.nii.gz -div 22 avg_mni_vol_V1.label.nii.gz

dir_firstlevel_home = pwd; % Run from the RetinotopyLabels/Labels folder 
dir_firstlevel_home = char(dir_firstlevel_home);

% LABELS2VOL
labels{1} ='mask_mni_vol_V1.label.nii.gz';
labels{2} ='mask_mni_vol_V2.label.nii.gz';
labels{3} ='mask_mni_vol_V3.label.nii.gz';
labels{4} ='mask_mni_vol_V4.label.nii.gz';
labels{5} ='mask_mni_vol_V3AB.label.nii.gz';

% print to file
batch_file = strcat(dir_firstlevel_home, {'/'}, 'BatchFile_labels_average.txt'); % name of bash script
batch_file = char(batch_file);
fid = fopen(batch_file,'w');
fprintf(fid, '#!/bin/sh \n'); 

        for ilabels = 1:length(labels);
       		current_label = labels(ilabels);
       		current_label = char(current_label);

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
        	
            if(i == 1)
            fprintf(fid, 'fslmaths '); 
            fprintf(fid, current_dir); 
            fprintf(fid, '/labels2vol/'); % CHANGE HERE IF OVERLAP (NOT)REMOVED
            fprintf(fid, current_label);
            else           
            fprintf(fid, ' -add '); 
            fprintf(fid, current_dir); 
            fprintf(fid, '/labels2vol/');            
            fprintf(fid, current_label); 
            end
            
       
    	cd(dir_firstlevel_home);
        
        end
    
    fprintf(fid, ' ');
    fprintf(fid, dir_firstlevel_home);
    fprintf(fid, '/');
    fprintf(fid, 'all_'); % output name
    fprintf(fid, current_label); 
    fprintf(fid, '\n \n'); 
    
    % divide by the number of subjects
    fprintf(fid, 'fslmaths '); 
    fprintf(fid, dir_firstlevel_home);
    fprintf(fid, '/');
    fprintf(fid, 'all_'); % input name
    fprintf(fid, current_label);  
    fprintf(fid, ' -div ');
    numsubjs = num2str(number_subjects);
    fprintf(fid, numsubjs);
       
    fprintf(fid, ' ');  
    fprintf(fid, dir_firstlevel_home);
    fprintf(fid, '/');
    fprintf(fid, 'avg_'); % output name
    fprintf(fid, current_label);
    fprintf(fid, '\n \n'); 
        
   	
    end   
   
    fclose(fid);

end