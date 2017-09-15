function [] = bbregister_T1Surface2EpiVolume_batch()
% Registration from surface space (based on T1) to the functional volumetric space
% Creates a batch file ('BatchFile_bbregister_T1Surface2EpiVolume.txt') to be processed from the terminal

dir_firstlevel_home = pwd; % To be run from the functional directory

% print to file
batch_file = strcat(dir_firstlevel_home, {'/'}, 'BatchFile_bbregister_T1Surface2EpiVolume.txt'); % name of bash script
batch_file = char(batch_file);
fid = fopen(batch_file,'w');

% Set subjects directory for Freesurfer
cmd_setenv = 'export SUBJECTS_DIR="/home/user/Subjects" '; 

fprintf(fid, cmd_setenv); 
fprintf(fid, '\n \n'); 
fprintf(fid, '#!/bin/sh \n \n');     

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
    
        cd(name);
    
        current_dir = pwd;
        current_dir = char(current_dir);  %/home/user/FSL_FirstLevel_Localizer/subject0032-Localizer.feat/

        img_examplefunc = strcat(current_dir, '/reg/example_func.nii.gz'); % in registration and subject root folder
        img_examplefunc = char(img_examplefunc);
    
        out_regmatrix = strcat(dir_output_home, out_name, '/labels2vol/T1_surf2vol_EPI.dat');
        out_regmatrix = char(out_regmatrix);
        
            fprintf(fid, 'bbregister --s '); 
            fprintf(fid, out_name); % to be transformed
            fprintf(fid, ' --mov '); 
            fprintf(fid, img_examplefunc); 
            fprintf(fid, ' --init-fsl --reg '); 
            fprintf(fid, out_regmatrix); 
            fprintf(fid, ' --bold'); 
            fprintf(fid, '\n echo Done Registration '); 
            fprintf(fid, '\n \n'); 
            
    
        cd(dir_firstlevel_home);
    end   
    
    fclose(fid);

end