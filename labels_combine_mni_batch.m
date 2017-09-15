function [] = labels_combine_mni_batch()
% Merge all parts of retinotopic areas together and hemispheres per subject (in MNI space).
% Creates a batch script ('BatchFile_labels_combine_MNI.txt') to be processed from the terminal
% Run from the RetinotopyLabels/Labels folder 
% 
% Combines:
% V2d and V2v Left = V2 Left
% V2d and V2v Right = V2 Right
% V3AB and V3d and V3v Left = V3 Left
% V3AB and V3d and V3v Right = V3 Right
% V1 Left and Right = V1
% V2 Left and Right = V2
% V3 Left and Right = V3
% V4 Left and Right = V4

dir_firstlevel_home = pwd; %/home/user/RetinotopyLabels/Labels

% Need to make all the label
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

% fslmaths /home/user/RetinotopicLabels/Labels/subject0032/labels2vol/mni_vol_lh.V1.label.nii.gz 
% -add /home/user/RetinotopicLabels/Labels/subject0032/labels2vol/mni_vol_rh.V1.label.nii.gz 
% mni_vol_V1.label.nii.gz

% print to file
batch_file = strcat(dir_firstlevel_home, {'/'}, 'BatchFile_labels_combine_MNI.txt'); % name of bash script
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
        	current_dir = char(current_dir);  %/home/user/RetinotopyLabels/Labels/subject0032/
         
       %V2d and V2v Left = V2 Left
        	lh_v2d = strcat(current_dir, '/labels2vol/mni_vol_lh.V2d.label.nii.gz'); 
        	lh_v2d = char(lh_v2d);
                
        	lh_v2v = strcat(current_dir, '/labels2vol/mni_vol_lh.V2v.label.nii.gz'); 
        	lh_v2v = char(lh_v2v);
        
        	lh_v2 = strcat(current_dir, '/labels2vol/mni_vol_lh.V2.label.nii.gz');  
        	lh_v2 = char(lh_v2);
        	
            fprintf(fid, 'fslmaths '); 
            fprintf(fid, lh_v2d); 
            fprintf(fid, ' -add '); 
            fprintf(fid, lh_v2v); 
            fprintf(fid, ' '); 
            fprintf(fid, lh_v2); %name of new label
            fprintf(fid, '\n echo Done Left V2 \n \n'); 
      
      % V2d and V2v Right = V2 Right    
            rh_v2d = strcat(current_dir, '/labels2vol/mni_vol_rh.V2d.label.nii.gz'); 
        	rh_v2d = char(rh_v2d);
                
        	rh_v2v = strcat(current_dir, '/labels2vol/mni_vol_rh.V2v.label.nii.gz'); 
        	rh_v2v = char(rh_v2v);
        
        	rh_v2 = strcat(current_dir, '/labels2vol/mni_vol_rh.V2.label.nii.gz');
        	rh_v2 = char(rh_v2);
        	
        	fprintf(fid, 'fslmaths '); 
            fprintf(fid, rh_v2d); 
            fprintf(fid, ' -add '); 
            fprintf(fid, rh_v2v); 
            fprintf(fid, ' '); 
            fprintf(fid, rh_v2); %name of new label
            fprintf(fid, '\n echo Done Right V2 \n \n'); 
            
        % V2         
        	v2 = strcat(current_dir, '/labels2vol/mni_vol_V2.label.nii.gz'); 
        	v2 = char(v2);
        	
        	fprintf(fid, 'fslmaths '); 
            fprintf(fid, lh_v2); 
            fprintf(fid, ' -add ');
            fprintf(fid, rh_v2); 
            fprintf(fid, ' '); 
            fprintf(fid, v2); %name of new label
            fprintf(fid, '\n echo Done V2 \n \n'); 
            
       	%V3d and V3v Left = V3 Left
        
        	lh_v3v = strcat(current_dir, '/labels2vol/mni_vol_lh.V3v.label.nii.gz'); 
        	lh_v3v = char(lh_v3v);
        
        	lh_v3d = strcat(current_dir, '/labels2vol/mni_vol_lh.V3d.label.nii.gz');  
        	lh_v3d = char(lh_v3d);
        	
        	lh_v3 = strcat(current_dir, '/labels2vol/mni_vol_lh.V3.label.nii.gz');  
        	lh_v3 = char(lh_v3);
        	
            fprintf(fid, 'fslmaths '); 
            fprintf(fid, lh_v3v); 
            fprintf(fid, ' -add '); 
            fprintf(fid, lh_v3d); 
            fprintf(fid, ' '); 
            fprintf(fid, lh_v3); %name of new label
            fprintf(fid, '\n echo Done Left V3 \n \n'); 
            
       %V3d and V3v Right = V3 Right      
                
        	rh_v3v = strcat(current_dir, '/labels2vol/mni_vol_rh.V3v.label.nii.gz'); 
        	rh_v3v = char(rh_v3v);
        
        	rh_v3d = strcat(current_dir, '/labels2vol/mni_vol_rh.V3d.label.nii.gz');  
        	rh_v3d = char(rh_v3d);
        	
        	rh_v3 = strcat(current_dir, '/labels2vol/mni_vol_rh.V3.label.nii.gz');  
        	rh_v3 = char(rh_v3);
        	
            fprintf(fid, 'fslmaths '); 
            fprintf(fid, rh_v3v); 
            fprintf(fid, ' -add '); 
            fprintf(fid, rh_v3d); 
            fprintf(fid, ' '); 
            fprintf(fid, rh_v3); %name of new label
            fprintf(fid, '\n echo Done Right V3 \n \n'); 
            
         % V3
         
        	v3 = strcat(current_dir, '/labels2vol/mni_vol_V3.label.nii.gz'); 
        	v3 = char(v3);
        	
        	fprintf(fid, 'fslmaths '); 
            fprintf(fid, lh_v3); 
            fprintf(fid, ' -add ');
            fprintf(fid, rh_v3); 
            fprintf(fid, ' '); 
            fprintf(fid, v3); %name of new label
            fprintf(fid, '\n echo Done V3 \n \n'); 
            
         % V3AB

        	lh_v3a = strcat(current_dir, '/labels2vol/mni_vol_lh.V3AB.label.nii.gz'); 
        	lh_v3a = char(lh_v3a);              
        	
        	rh_v3a = strcat(current_dir, '/labels2vol/mni_vol_rh.V3AB.label.nii.gz');  
        	rh_v3a = char(rh_v3a);
            
            v3ab = strcat(current_dir, '/labels2vol/mni_vol_V3AB.label.nii.gz');  
        	v3ab = char(v3ab);
        	
            fprintf(fid, 'fslmaths '); 
            fprintf(fid, lh_v3a); 
            fprintf(fid, ' -add '); 
            fprintf(fid, rh_v3a);
            fprintf(fid, ' '); 
            fprintf(fid, v3ab); %name of new label
            fprintf(fid, '\n echo Done V3AB \n \n');     
            
          % V1  
            lh_v1 = strcat(current_dir, '/labels2vol/mni_vol_lh.V1.label.nii.gz'); 
        	lh_v1 = char(lh_v1);
                
        	rh_v1 = strcat(current_dir, '/labels2vol/mni_vol_rh.V1.label.nii.gz'); 
        	rh_v1 = char(rh_v1);
        	
            v1 = strcat(current_dir, '/labels2vol/mni_vol_V1.label.nii.gz'); 
        	v1 = char(v1);
        	
        	fprintf(fid, 'fslmaths '); 
            fprintf(fid, lh_v1); 
            fprintf(fid, ' -add ');
            fprintf(fid, rh_v1); 
            fprintf(fid, ' '); 
            fprintf(fid, v1); %name of new label
            fprintf(fid, '\n echo Done V1 \n \n'); 
            
          % V4  
            lh_v4 = strcat(current_dir, '/labels2vol/mni_vol_lh.V4.label.nii.gz'); 
        	lh_v4 = char(lh_v4);
                
        	rh_v4 = strcat(current_dir, '/labels2vol/mni_vol_rh.V4.label.nii.gz'); 
        	rh_v4 = char(rh_v4);
        	
            v4 = strcat(current_dir, '/labels2vol/mni_vol_V4.label.nii.gz'); 
        	v4 = char(v4);
        	
        	fprintf(fid, 'fslmaths '); 
            fprintf(fid, lh_v4); 
            fprintf(fid, ' -add ');
            fprintf(fid, rh_v4); 
            fprintf(fid, ' '); 
            fprintf(fid, v4); %name of new label
            fprintf(fid, '\n echo Done V4 \n \n'); 
            
            
        i = i + 1;
    
        cd(dir_firstlevel_home);
    end   
    
    fclose(fid);

end