function [] = labels_remove_overlap_mni()
% Removes all overlapping voxels in these regions of interest
% Creates a batch script ('BatchFile_labels_remove_overlap_MNI.txt') to be processed from the terminal
% 
% Removes all overlapping voxels from visual areas:
% V1 -V2 -V3 -V4 -V3AB
% V2 -V1 -V3 -V4 -V3AB
% V3 -V1 -V2 -V4 -V3AB
% V4 -V1 -V2 -V3 -V3AB
% Then binned
% 
% FSL command:
% fslmaths mask_vol_V1.label.nii.gz -sub mask_vol_V2.label.nii.gz -sub mask_vol_V3.label.nii.gz -sub mask_vol_V4.label.nii.gz -bin /overlap_removed/V1_vol_mask.nii.gz 

dir_firstlevel_home = pwd; % Run from the RetinotopyLabels/Labels folder 

% print to file
batch_file = strcat(dir_firstlevel_home, {'/'}, 'BatchFile_labels_remove_overlap_MNI.txt'); % name of bash script
batch_file = char(batch_file);
fid = fopen(batch_file,'w');
fprintf(fid, '#!/bin/sh \n');     

%count how many folders are in the Current directory and get folder names
    number_subjects = length(dir('subject*'));
    all_folders = dir('subject*');
   	    
	% Loop through all subjects
	for i=1:number_subjects
   
       	name = all_folders(i).name; %current directory
       	name = char(name);
       	
       	cd(name);
    
        	current_dir = pwd;
        	current_dir = char(current_dir);  %/home/user/RetinotopicAnalysis/RetinotopicLabels/Labels/subject0032/
            
            %mkdir('overlap_removed'); % Making the directory for the labels after batch script is run
         
       %V1 -V2 -V3 -V4 -V3AB
        	v1 = strcat(current_dir, '/labels2vol/thr_mni_vol_V1.label.nii.gz'); 
        	v1 = char(v1);
                
        	v2 = strcat(current_dir, '/labels2vol/thr_mni_vol_V2.label.nii.gz'); 
        	v2 = char(v2);
            
            v3 = strcat(current_dir, '/labels2vol/thr_mni_vol_V3.label.nii.gz'); 
        	v3 = char(v3);
            
            v4 = strcat(current_dir, '/labels2vol/thr_mni_vol_V4.label.nii.gz'); 
        	v4 = char(v4);
            
            v3ab = strcat(current_dir, '/labels2vol/thr_mni_vol_V3AB.label.nii.gz'); 
        	v3ab = char(v3ab);
            
            new = strcat(current_dir, '/overlap_removed/mni_V1_vol_mask.nii.gz'); 
            new = char(new);
        	
            fprintf(fid, 'fslmaths '); 
            fprintf(fid, v1); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v2); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v3); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v4); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v3ab); 
            fprintf(fid, ' -bin '); 
            fprintf(fid, new); %name of new label
            
            fprintf(fid, '\n echo Done V1 \n \n'); 
      
       %V2 -V1 -V3 -V4 -V3AB
            
            new = strcat(current_dir, '/overlap_removed/mni_V2_vol_mask.nii.gz'); 
            new = char(new);
        	
            fprintf(fid, 'fslmaths '); 
            fprintf(fid, v2); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v1); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v3); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v4); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v3ab); 
            fprintf(fid, ' -bin '); 
            fprintf(fid, new); %name of new label
            
            fprintf(fid, '\n echo Done V2 \n \n'); 
            
       %V3 -V1 -V2 -V4 -V3AB
            
            new = strcat(current_dir, '/overlap_removed/mni_V3_vol_mask.nii.gz'); 
            new = char(new);
        	
            fprintf(fid, 'fslmaths '); 
            fprintf(fid, v3); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v1); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v2); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v4); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v3ab); 
            fprintf(fid, ' -bin '); 
            fprintf(fid, new); %name of new label
            
            fprintf(fid, '\n echo Done V3 \n \n');     
            
        %V4 -V1 -V2 -V3 -V3AB
            
            new = strcat(current_dir, '/overlap_removed/mni_V4_vol_mask.nii.gz'); 
            new = char(new);
        	
            fprintf(fid, 'fslmaths '); 
            fprintf(fid, v4); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v1); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v2); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v3); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v3ab); 
            fprintf(fid, ' -bin '); 
            fprintf(fid, new); %name of new label
            
            fprintf(fid, '\n echo Done V4 \n \n');         
       
        %V3AB -V1 -V2 -V3 -V4
            
            new = strcat(current_dir, '/overlap_removed/mni_V3AB_vol_mask.nii.gz'); 
            new = char(new);
        	
            fprintf(fid, 'fslmaths '); 
            fprintf(fid, v3ab); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v1); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v2); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v3); 
            fprintf(fid, ' -sub '); 
            fprintf(fid, v4); 
            fprintf(fid, ' -bin '); 
            fprintf(fid, new); %name of new label
            
            fprintf(fid, '\n echo Done V3AB \n \n');             

    
        cd(dir_firstlevel_home);
    end   
    
    fclose(fid);

end