# retinotopy_freesurfer2FSL
Scripts for transforming retinotopic labels from surface space (Freesurfer) to volumetric space (FSL)


Take Freesurfer labels and transform them into MNI152 volume masks (FSL).

What should be complete at this point:
- Freesurfer segmentation recon -all
- Retinotopy functional analysis in Freesurfer
- All labels drawn on surface anatomy in Freesurfer
- First level analysis (or pooling) of EPI data (e.g. an fMRI localizer)

Set $FREESURFER_HOME and $SUBJECTS on Linux

Tell Freesurfer where to find the subjects directory:
tcsh 
setenv SUBJECTS_DIR /home/user/FreesurferSubjects
bash
export SUBJECTS_DIR="/home/user/FreesurferSubjects"


--------------------------------------
(1) bbregister_T1Surface2EpiVolume_batch.m
--------------------------------------
Need: 1 whole brain EPI as example_func (e.g. 1st_Level.feat/subject/reg/example_func.nii.gz).
Run bbregister on this example_func.nii.gz file with the argument --init-fsl.
I don't have to explicitly tell bbregister which T1 it needs, only which subject folder from $SUBJECTS_DIR it needs.
bbregister uses the anatomy-surfaces to co-register to EPI.
http://freesurfer.net/fswiki/bbregister#Synopsis
NOTE: The example_func.nii.gz used here is specific to that localizer, which means that other functional native spaces would need to be FLIRTed into the the current native space.

>> bbregister --s subject0032 --mov /home/user/FSL_FirstLevel_Localizer/subject0032-Localizer.feat/reg/example_func.nii.gz --reg /home/user/RetinotopicLabels/Labels/subject0032/labels2vol/T1_surf2vol_EPI.dat --init-fsl --bold

To check results, run:
>> tkregister2 --mov /home/user/FSL_FirstLevel_Localizer/subject0032-Localizer.feat/reg/example_func.nii.gz --reg /home/user/RetinotopicLabels/Labels/subject0032/labels2vol/T1_surf2vol_EPI.dat --surf


--------------------------------------
(2) label2epi_batch.m 
--------------------------------------
Transform surface labels to volumetric native space. 
We first save labels in volumetric native space and then afterward transform to standard space.

After bbregister, run mri_label2vol, which will give me the labels in volume single subject space first. 
These labels will end up in the subject-specific EPI space (1st_Level.feat/subject/reg/example_func.nii.gz)

>> mri_label2vol --label /home/user/RetinotopicLabels/Labels/subject0032/lh.V1.label --subject subject0032 --temp /home/user/FSL_FirstLevel_Localizer/subject0032-Localizer.feat/reg/example_func.nii.gz --reg /home/user/RetinotopicLabels/Labels/subject0032/labels2vol/T1_surf2vol_EPI.dat --o /home/user/RetinotopicLabels/Labels/subject0032/labels2vol/vol_lh.V1.label.nii.gz

14 original Labels:
'lh.V1.label',
'lh.V2d.label',
'lh.V2v.label',
'lh.V3AB.label',
'lh.V3d.label',
'lh.V3v.label',
'lh.V4.label',
'rh.V1.label',
'rh.V2d.label',
'rh.V2v.label',
'rh.V3AB.label',
'rh.V3d.label',
'rh.V3v.label',
'rh.V4.label'

** Always check thresholding after registration

--------------------------------------
(3) label2mni_batch.m
--------------------------------------
Then apply the transform using FLIRT examplefunc2standard.mat to get those labels into MNI space (this file comes from Feat).
We already ran an EPI to MNI registration in FSL with FEAT, so we have the necessary matrix in subject-specific folder (1st_Level.feat/subject/reg/examplefunc2standard.mat).

>> flirt -in /home/user/RetinotopicLabels/Labels/subject0032/labels2vol/vol_lh.V1.label.nii.gz -ref /home/user/atlases/MNI/MNI152_T1_2mm_brain.nii.gz -applyxfm -init /home/user/FSL_FirstLevel_Localizer/subject0032-Localizer.feat/reg/example_func2standard.mat -out /home/user/RetinotopicLabels/Labels/subject0032/labels2vol/mni_vol_lh.V1.label.nii.gz 

optional arguments for interpolation method: [-paddingsize 0.0 -interp sinc -sincwidth 7 -sincwindow hanning]

The sinc output seems to be binned. 
The default output is weighted, not binned.

** Always check thresholding after registration (e.g. transform_set_threshold.m with t = .5, 50% of original voxels)


--------------------------------------
(4) labels_combine_batch.m, labels_combine_mni_batch.m
--------------------------------------
Merge all parts of retinotopic areas together and hemispheres per subject.
New combinations are created for both native and MNI space…

Combines:
V2d and V2v Left = V2 Left

V2d and V2v Right = V2 Right

V3d and V3v Left = V3 Left

V3d and V3v Right = V3 Right

V3AB Left and V3AB Right = V3AB

V1 Left and Right = V1

V2 Left and Right = V2

V3 Left and Right = V3

V4 Left and Right = V4

NATIVE SPACE:
V1
>> fslmaths /home/user/RetinotopicLabels/Labels/subject0032/labels2vol/vol_lh.V1.label.nii.gz -add /home/user/RetinotopicLabels/Labels/subject0032/labels2vol/vol_rh.V1.label.nii.gz vol_V1.label.nii.gz

V2
>> fslmaths vol_lh.V2v.label.nii.gz -add vol_lh.V2v.label.nii.gz vol_lh.V2.label.nii.gz
>> fslmaths vol_rh.V2v.label.nii.gz -add vol_rh.V2v.label.nii.gz vol_rh.V2.label.nii.gz
>> fslmaths vol_lh.V2.label.nii.gz -add vol_rh.V2.label.nii.gz vol_V2.label.nii.gz

V3
>> fslmaths vol_lh.V3d.label.nii.gz -add vol_lh.V3v.label.nii.gz vol_lh.V3.label.nii.gz
>> fslmaths vol_rh.V3d.label.nii.gz -add vol_rh.V3v.label.nii.gz vol_rh.V3.label.nii.gz
>> fslmaths vol_rh.V3.label.nii.gz vol_V3.label.nii.gz

V4
>> fslmaths vol_lh.V4.label.nii.gz -add vol_rh.V4.label.nii.gz vol_V4.label.nii.gz


MNI SPACE: labels_combine_mni_batch.m
replace with mni_
e.g. mni_vol_V1.label.nii.gz


--------------------------------------
(5) labels_bin_batch.m
--------------------------------------
Make sure the masks are binned
Bin = binary mask

>> fslmaths /home/user/RetinotopicLabels/Labels/subject0032/labels2vol/vol_V1.label.nii.gz -bin /home/user/RetinotopicLabels/Labels/subject0032/labels2vol/mask_vol_V1.label.nii.gz 
>> fslmaths /home/user/RetinotopicLabels/Labels/subject0032/labels2vol/mni_vol_V1.label.nii.gz -bin /home/user/RetinotopicLabels/Labels/subject0032/labels2vol/mask_mni_vol_V1.label.nii.gz 

--------------------------------------
(6) labels_average_batch.m
--------------------------------------
Average all subjects V1 together, then V2,V3,V4,V3AB
This will give us four images representing the average retinotopic areas of all the participants.
all_mni_vol_V1.label.nii.gz = addition of all subjects
avg_mni_vol_V1.label.nii.gz = all_mni_vol_V1.label.nii.gz / number of subjects (is weighted, represents probability in the group)

>> fslmaths 1mni_vol_V1.label.nii.gz -add 2mni_vol_V1.label.nii.gz -add 3mni_vol_V1.label.nii.gz ... all subjects ... all_mni_vol_V1.label.nii.gz
>> fslmaths all_mni_vol_V1.label.nii.gz -div 22 avg_mni_vol_V1.label.nii.gz


--------------------------------------
(7) labels_remove_overlap.m, labels_remove_overlap_mni.m
--------------------------------------

Removes all overlapping voxels between any of the visual areas (both hemispheres combined) in native space
Gives new images per subject in directory overlap_removed:
V1_vol_mask.nii.gz 
V2_vol_mask.nii.gz 
V3_vol_mask.nii.gz 
V4_vol_mask.nii.gz 
V3AB_vol_mask.nii.gz

These images are all binned.

V1 -V2 -V3 -V4 -V3AB

V2 -V1 -V3 -V4 -V3AB

V3 -V1 -V2 -V4 -V3AB

V4 -V1 -V2 -V3 -V3AB

>> fslmaths mask_vol_V1.label.nii.gz -sub mask_vol_V2.label.nii.gz -sub mask_vol_V3.label.nii.gz -sub mask_vol_V4.label.nii.gz -bin V1_vol_mask.nii.gz 

Matlab script also creates a new folder overlap_removed in subject directory


--------------------------------------
OPTION INSTEAD OF STEPS (2)-(3)
--------------------------------------
Surface labels to MNI in one step by concatenating 2 matrices:
Matrix1 = INVERT bbregister, fslregout.mat file.
Matrix2 = We already ran an EPI to MNI registration in FSL with FEAT, so we have the necessary matrix in subject-specific folder (1st_Level.feat/subject/reg/examplefunc2standard.mat). There should be an inverted version already from FSL.

FSL->Misc. Concatenate XFM (make 1 new matrix out of 20.
APPLY XFM (when you already have matrix) to get labels into MNI space


