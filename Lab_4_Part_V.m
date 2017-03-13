%% --------------------------------------------------------------------
%
% Lab 4: Segmentation of DICOM Volumes in MATLAB
%        PART V: Lab_4_Part_V.m
%       (manual segmentation and image mathematics)
%
%% --------------------------------------------------------------------
% PREPARATION: specifying the path to the home folder 

%%
% !!! make sure that you are in the '/Medical_Imaging_Lab_4/' folder !!!

%%
% prepare for this part of the laboratory
clear all;      % clear the workspace 
close all;      % close all windows 
clc;            % clear the command line 

%%
% store the path to the current folder in 'home_path' variablechome_path = pwd;
home_path = pwd;

% generate path to '/dicom_processing_functions' folder 
% containing additional functions for .dcm processing
dcm_processing_path = [home_path '/dicom_processing_functions']

% add the 'dcm_processing_path' path to the Matlab search path
addpath(dcm_processing_path);

%% --------------------------------------------------------------------
% Step I: uploading .dcm volume for processing
%         (fetal ultrasound - time domain)

%%
% specify the file path
file_path = [home_path '/dicom_data/' 'wwwphilipscomhealthcare_24W_US.dcm'];

% read the volume
US_Volume = dicomread(file_path);

% check the size (it is a 4D array) 
size(US_Volume)

%%
% use 'squeeze' function to remove the extra 'empty' dimension
US_Volume = squeeze(US_Volume);

% check the size
size(US_Volume)

%%
% visualise the volume using 'implay' 
implay(US_Volume);

% (make the figure larger - in order to see the entire frame)

%% --------------------------------------------------------------------
% Step II: manual segmentation of 2D images
%         (fetal ultrasound - single slice)

%%
% select slice #1
I = US_Volume(:,:,1);

% visualise the image
figure('Position',[785 290 590 485]); 
imshow(I); h_a = gca;

%% 
% create an new 'imfreehand' object in the 'h_c' axes
h_fc = imfreehand(h_a);

% go back to the image 
% circle the head of the fetus (see Lab_4_instructions.doc)

%%
% create the mask of the head using '.createMask' 
% property of the 'h_fc' object
I_mask = h_fc.createMask;

% show the mask
figure(); imshow(I_mask);

%%
% combine the original image with the mask ('immultiply')
I_seg = immultiply(I_mask,I);

% show the segmented image
figure(); imshow(I_seg);

%%
% read about 'imfreehand' function
doc imfreehand

%% --------------------------------------------------------------------
% Step III: manual segmentation of 2D images
%           (fetal ultrasound - the entire volume)

%%
% create a new empty volume using 'zeros' function 
US_Volume_seg = zeros(size(US_Volume));

% apply the mask to all slices one by one
for i = 1:size(US_Volume,3)
    US_Volume_seg(:,:,i) = immultiply(US_Volume(:,:,i),I_mask);
end

%%
% visualise the segmented volume
figure(); 
imtool3D(US_Volume_seg,[]); colormap bone;

%%
% or you can use 'implay' - but you will need to convert the 
% volume to 'uint8' format
implay(uint8(US_Volume_seg));

%% --------------------------------------------------------------------
% prepare for the next part of the laboratory

%%
% go back to the home directory 
cd(home_path);

% and proceed to the next part ('Lab_4_Part_VI.m' file)

%%
