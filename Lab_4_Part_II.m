%% --------------------------------------------------------------------
%
% Lab 4: Segmentation of DICOM Volumes in MATLAB
%        PART II: Lab_4_Part_II.m
%       (multi-threshold image segmentation)
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
% store the path to the current folder in 'home_path' variable
home_path = pwd;

% generate path to '/dicom_processing_functions' folder 
% containing additional functions for .dcm processing
dcm_processing_path = [home_path '/dicom_processing_functions']

% add the 'dcm_processing_path' path to the Matlab search path
addpath(dcm_processing_path);

%% --------------------------------------------------------------------
% Step I: Reading previously generated data from .mat files

%%
% load the volumes generated in Lab_4_Part_I.m
load([home_path '/results/' 'MRI_Volume_brain.mat'])
load([home_path '/results/' 'MRI_T2_Volume.mat'])

% '[ ]' is used for concatenation of numbers or strings into an array 

% check how the path to the variables looks like
[home_path '/results/' 'MRI_T2_Volume.mat']

%%
% Step II: Visualisation of 3D volumes as contours 
%          (head MRI volume)

%%
% at first, generate an array of slice numbers that we 
% we want to display (from 1 to 51 with step 4)
slices = 1:4:size(MRI_Volume_brain,3);   

% every 4th slice will be selected
slices

%%
% select the number of thresholds to be 10 (20 is the maximum)
N = 10;   

% 'contourslice' function visualises a set of slices 
% of a 3D volume in 3D space

figure('Position',[560 90 1060 870]);
MRI_contour = contourslice(MRI_Volume_brain,[],[],slices,N); 

grid on;            % activate the grid
view(30,30);        % set the camera view position
colormap(jet);      % select 'jet' colour map
rotate3d on;        % activate rotation
colorbar;           % add a color bar

% (!!!) try rotating it 

% (higher number of thresholds and slices will increase the processing time)

%%
% read about 'contourslice' function
doc contourslice

%%
% Step II: Multithreshold segmentation 
%          (single head MRI volume slice)

%%
% at first, select slice #31
I = MRI_T2_Volume(:,:,31);

I = uint16(I);

%%
% read about 'multithresh' and 'imquantize' functions
doc multithresh
doc imquantize

%%
% 'multithresh' function automatically identifies a set of 
% intensity threshold values 
% in order to segment a specified image into N intensity levels

N = 20;     % select the number of thresholds to be 20                             
I_N_thresh = multithresh(I,N);   

% check the resulting vector
I_N_thresh

% next, apply 'imquantize' function, which performs image segmentation  
% based on the 'multithresh' vector
I_multi_mask = imquantize(I,I_N_thresh);

%%
% visualise the results (with 'colorbar' activated)
figure('Position', [650, 130, 1000, 500]);

subplot(1,2,1); imshow(I,[]); title('Original I'); colorbar; 

subplot(1,2,2); imshow(I_multi_mask,[]); title('Generated mask'); 
colormap(gca,jet); colorbar; % specify the mask colormap to be 'jet' 

% activate 'impixelinfo' option and inspect the image pixel values 
impixelinfo

%%
% analyse the generated mask
% (it has 21 levels and the MS lesions are within 18-21 range)

% create a new variable 'I_lesion_mask' equal to 'I_multi_mask'
I_lesion_mask = I_multi_mask; 

% assign all pixel with the values smaller than 18 to be 0
I_lesion_mask(I_lesion_mask < 18) = 0; 

% fill the holes
I_lesion_mask = imfill(I_lesion_mask,'holes');

% remove all objects smaller that 10 pixels
I_lesion_mask = bwareaopen(I_lesion_mask,10);

% visualise the result using 'imshopair' function
figure('Position', [650, 130, 1000, 500]); 
subplot(1,2,1); imshow(I_lesion_mask,[]); 
subplot(1,2,2); imshowpair(I,I_lesion_mask); 

%%
% read about 'imshowpair' function 
doc imshowpair

%% --------------------------------------------------------------------
% prepare for the next part of the laboratory

%%
% go back to the home directory 
cd(home_path);

% and proceed to the next part ('Lab_4_Part_III.m' file)

%%
