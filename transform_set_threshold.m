function [] = transform_set_threshold(t)
% Thresholding transformed images and then binning them. 
% % Creates a batch script ('BatchFile_Threshold.txt') to be processed from the terminal

labels{1} ='mni_vol_V1.label.nii.gz';
labels{2} ='mni_vol_V2.label.nii.gz';
labels{3} ='mni_vol_V3.label.nii.gz';
labels{4} ='mni_vol_V4.label.nii.gz';
labels{5} ='mni_vol_V3AB.label.nii.gz';

dir_home = pwd; 

%count how many folders are in the Current directory and get folder names
    number_subjects = length(dir('subject*'));
    all_folders = dir('subject*');
         
% print to file
    batch_file = 'BatchFile_Threshold.txt'; % name of bash script
    fid = fopen(batch_file,'w');  
    fprintf(fid, '#!/bin/sh \n');   
    
	% Loop through all subjects, write threshold and bin command
	for i=1:number_subjects
   
       	name = all_folders(i).name; %current directory           
       	name = char(name);
       	cd(name);
        
        cd('labels2vol');
        
        current_dir = pwd;
        current_dir = char(current_dir);
            
       	for ilabels = 1:length(labels);
       		current_label = labels(ilabels);
       		current_label = char(current_label);
                   
        	img_label = strcat(current_dir, {'/'}, current_label);
        	img_label = char(img_label);
        
        	out_label = strcat(current_dir, '/thr_', current_label);
        	out_label = char(out_label);
        
  
            fprintf(fid, 'fslmaths '); 
            fprintf(fid, img_label); % to be transformed
            fprintf(fid, ' -thr ' ); 
            fprintf(fid, num2str(t) ); 
            
            fprintf(fid, ' -bin '); 
            fprintf(fid, out_label); %name of new label
            fprintf(fid, '\n echo Done Threshold \n \n'); 
        

        end
        
        cd(dir_home);
    end   
    
    fclose(fid);

end