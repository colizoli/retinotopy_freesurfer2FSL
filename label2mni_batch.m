function [] = label2mni_batch()
% Transform surface labels to MNI standard space. 
% Creates a batch script ('BatchFile_labels2mni.txt') to be processed from the terminal
%
% flirt 
% -in /home/user/RetinotopicLabels/Labels/subject0032/vol_lh.V1.label.nii.gz 
% -ref /home/user/atlases/MNI/MNI152_T1_2mm_brain.nii.gz 
% -applyxfm 
% -init /home/user/FSL_FirstLevel_Localizer/subject0032-Localizer.feat/reg/example_func2standard.mat 
% -out /home/user/RetinotopicLabels/Labels/subject0032/MNI_vol_lh.V1.label.nii.gz 

dir_firstlevel_home = pwd; % To be run from the functional directory

% Need to make all the labels
labels{1} = 'lh.V1.label';
labels{2} ='lh.V2d.label';
labels{3} ='lh.V2v.label';
labels{4} ='lh.V3AB.label';
labels{5} ='lh.V3d.label';
labels{6} ='lh.V3v.label';
labels{7} ='lh.V4.label';
labels{8} ='rh.V1.label';
labels{9} ='rh.V2d.label';
labels{10} ='rh.V2v.label';
labels{11} ='rh.V3AB.label';
labels{12} ='rh.V3d.label';
labels{13} ='rh.V3v.label';
labels{14} ='rh.V4.label';

% print to file
batch_file = strcat(dir_firstlevel_home, {'/'}, 'BatchFile_labels2mni.txt'); % name of bash script
batch_file = char(batch_file);
fid = fopen(batch_file,'w');

%count how many folders are in the Current directory and get folder names
    number_subjects = length(dir('subject*.feat'));
    all_folders = dir('subject*.feat');
     
%count how many folders are in the Output directory and get folder names
	dir_output_home = '/home/user/RetinotopicAnalysis/RetinotopicLabels/Labels/';
	cd(dir_output_home);
    out_number_subjects = length(dir('subject*'));
    out_all_folders = dir('subject*');
   	cd(dir_firstlevel_home);
   	
    
	% Loop through all subjects, get their example_func files and specify output .DAT file
	for i=1:number_subjects
   
       	name = all_folders(i).name; %current directory
       	out_name = out_all_folders(i).name; %output directory
       	out_name = char(out_name);
            
       	name = char(name);
       	cd(name);
            
       	for ilabels = 1:length(labels)
       		current_label = labels(ilabels);
       		current_label = char(current_label);
    
        	current_dir = pwd;
        	current_dir = char(current_dir);  %/home/user/FSL_FirstLevel_Localizer/subject0032-Localizer.feat/

        	in_regmatrix = strcat(current_dir, '/reg/example_func2standard.mat'); % in registration and subject root folder
        	in_regmatrix = char(in_regmatrix);
                
        	img_label = strcat(dir_output_home, out_name, '/labels2vol/vol_', current_label, '.nii.gz');
        	img_label = char(img_label);
        
        	out_label = strcat(dir_output_home, out_name, '/labels2vol/mni_vol_', current_label, '.nii.gz');
        	out_label = char(out_label);
        
        	fprintf(fid, '#!/bin/sh \n');     
            fprintf(fid, 'flirt -in '); 
            fprintf(fid, img_label); % to be transformed
            fprintf(fid, ' -ref /home/user/atlases/MNI/MNI152_T1_2mm_brain.nii.gz -applyxfm -init '); 
            fprintf(fid, in_regmatrix); % registration matrix from bbregister_T1Surface2EpiVolume_batch.m
            fprintf(fid, ' -out '); 
            fprintf(fid, out_label); %name of new label
            fprintf(fid, '\n echo Done Registration \n \n'); 
       
        end
    
        cd(dir_firstlevel_home);
    end   
    
    fclose(fid);

end