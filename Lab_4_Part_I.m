%% --------------------------------------------------------------------
%
% Lab 4: Segmentation of DICOM Volumes in MATLAB
%        PART I: Lab_4_Part_I.m
%       (simple threshold-based segmentation)
%
%% --------------------------------------------------------------------
% PREPARATION: specifying the path to the home folder 

%%
% !!! make sure that you are in the '/Medical_Imaging_Lab_4/' folder !!!

%%
% prepare for this part of the laboratory
clear all;      % clear the workspace (remove all variables)
close all;      % close all windows 
clc;            % clear the command line 

%%
% store the path to the current folder in 'home_path' variable
home_path = pwd;

% generate path to '/dicom_processing_functions' folder 
% containing additional functions for .dcm processing
dcm_processing_path = [home_path '/dicom_processing_functions']

% add the 'dcm_processing_path' path to the Matlab search path
addpath(dcm_processing_path);

%% --------------------------------------------------------------------
% Step I: Reading and visualising different mode MRI .dcm volumes
%         ( T1, T2 and PD head MRI scans / multiple sclerosis case)

%%
% generate the path to the folder containing three brain 
% MRI .dcm volumes (intrapatient)
dcm_volumes_path = [home_path '/dicom_data/MRI_head_MS']; 

% move to the specified folder
cd(dcm_volumes_path);

% it contains three folders with head MRI .dcm volumes
% acquired in T1, T2 and PD modes
dir

%%
% upload all three volumes using 'dicom_read_header'
% and 'dicom_read_volume' functions (from Viewer3D(c) toolbox)

% reading MRI T1 volume
MRI_T1_Info = dicom_read_header([dcm_volumes_path '/T1']);
MRI_T1_Volume = dicom_read_volume(MRI_T1_Info);

% reading MRI T2 volume
MRI_T2_Info = dicom_read_header([dcm_volumes_path '/T2']);
MRI_T2_Volume = dicom_read_volume(MRI_T2_Info);

% reading MRI PD volume
MRI_PD_Info = dicom_read_header([dcm_volumes_path '/PD']);
MRI_PD_Volume = dicom_read_volume(MRI_PD_Info);

%%
% convert all volumes to 'double' format 
% ('double' is better for processing than the original 'int32')

MRI_T1_Volume = double(MRI_T1_Volume);
MRI_T2_Volume = double(MRI_T2_Volume);
MRI_PD_Volume = double(MRI_PD_Volume);

%% 
% check the size of these volumes
size(MRI_T1_Volume)         % the 'T1' volume has less slices
size(MRI_T2_Volume)
size(MRI_PD_Volume)        

%%
% visualise the volumes 

figure('Name','T1','Position',[30 295 560 420]); 
imtool3D(MRI_T1_Volume,[]);

figure('Name','T2','Position',[520 295 560 420]); 
imtool3D(MRI_T2_Volume,[]); 

figure('Name','PD','Position',[1050 295 560 420]); 
imtool3D(MRI_PD_Volume,[]);

% locate the MS lesions and analyse 
% the difference between the T1, T2 and PD modes
% (adjust the contrast - if required)

% as you can see - the T2 mode provides the highest 
% contrast for the lesions

% because of this, we will use only the 'T2' volume for segmentation 

%%
% 'whos' command will print all variables in the command window
whos

%%
% go back to the home directory 
cd(home_path);

%% --------------------------------------------------------------------
% Step II: Intensity threshold-based brain segmentation 
%          (single 2D head MRI slice)

%%
% at first, select slice #31
I = MRI_T2_Volume(:,:,31);

% visualise it
figure(); imshow(I,[]);

%%
% activate the 'impixelinfo' option in order to 
% discover the minimum intensity of the brain matter
impixelinfo

% using the pointer - find that it is approximately 190
% this will be our intensity threshold

%%
% specify the threshold to be 190
T = 190;

% create a new variable 'I_t' equal to 'I'
I_t = I;

% assign all values of 'I_t' < 190 to be 0
I_t(I_t < T) = 0;

% visualise the result
figure(); imshow(I_t,[]);

%%
% convert 'I_t' to the black & white mask image (0 and 1 values only)
% by making all positive pixel values to be 1
BW_mask = I_t;

BW_mask(BW_mask > 0) = 1; 

% visualise the result
figure(); imshow(BW_mask,[]);

%%
% now, let's remove the skull from the BW mask
% and fill all holes 

% 'bwareopen' function will remove all objects with the 
% area < that 1000 pixels
BW_mask_cleaned = bwareaopen(BW_mask, 1000);

% 'imfill' function will fill all holes in the mask
BW_mask_final = imfill(BW_mask_cleaned,'holes');

% visualise the result
figure(); imshow(BW_mask_final,[]);

%%
% combine the mask with the MRI slice 
% by using 'immultiply' function (image multiplication)
I_brain = immultiply(BW_mask_final,I);

% visualisation of the results
figure('Position', [10, 50, 1600, 500]);
subplot(1,4,1),imshow(I,[]),title('Original I')
subplot(1,4,2),imshow(BW_mask,[]),title('BW mask')
subplot(1,4,3),imshow(BW_mask_final),title('BW mask cleaned')
subplot(1,4,4),imshow(I_brain,[]),title('Thresholded brain')

%% --------------------------------------------------------------------
% read about 'bwareopen' and 'imfill' functions
doc bwareaopen
doc imfill

%% --------------------------------------------------------------------
% Step III: Intensity threshold-based brain segmentation 
%          (3D head MRI .dcm volume)

%%
% create two new empty volumes with the same size as 'MRI_T2_Volume'
% using 'zeros' function 
MRI_Volume_mask = zeros(size(MRI_T2_Volume));
MRI_Volume_brain = zeros(size(MRI_T2_Volume));

% specify the threshold to be 190 (similar to the previous case
T = 190; 

%apply the same steps for the entire volume slice by slice 
% (51 slices) in 'for' cycle 
for i=1:size(MRI_T2_Volume,3)
    
    I = MRI_T2_Volume(:,:,i);      % select the i-th slice
    I(I < T) = 0;                  % threshold it
    BW = I; 
    BW(BW > 0) = 1;                % convert to the BW mask
    
    BW = bwareaopen(BW, 1000);     % remove all small objects
    BW = imfill(BW,'holes');       % fill all holes
     
    % combine the i-th slice with the BW mask ('immultiply')  
    MRI_Volume_brain(:,:,i) = immultiply(BW,MRI_T2_Volume(:,:,i));
    
    % store the 'BW' mask as the i-th slice of 'MRI_Volume_mask'
    MRI_Volume_mask(:,:,i) = BW;    
end

%visualise the segmented brain volume
figure(); imtool3D(MRI_Volume_brain);

%% --------------------------------------------------------------------
% Step IV: saving the results in .mat files

%%
% go to the home folder
cd(home_path);

% create a new folder 'results'
mkdir('results')

%%
% go to the new folder
cd([home_path '/results'])

%%
% save the generated volumes using 'save' function
save MRI_Volume_brain.mat MRI_Volume_brain
save MRI_Volume_mask.mat MRI_Volume_mask
save MRI_T2_Volume.mat MRI_T2_Volume

%% --------------------------------------------------------------------
% prepare for the next part of the laboratory

%%
% go back to the home directory 
cd(home_path);

% and proceed to the next part ('Lab_4_Part_II.m' file)

%%

