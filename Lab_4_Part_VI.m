%% --------------------------------------------------------------------
%
% Lab 4: Segmentation of DICOM Volumes in MATLAB
%        PART VI: Lab_4_Part_VI.m
%       (gradient-based image segmentation method)
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
% Step I: uploading .dcm volume for processing
%           (breast MRI scan)

%%
% specify the path to the breast MRI .dcm volume folder
MRI_data_folder = [home_path '/dicom_data' '/MRI_breast_cancer'];

% read the .dcm volume
MRI_Info = dicom_read_header(MRI_data_folder);
MRI_Volume = dicom_read_volume(MRI_Info);

% visualise the volume and find the tumour
figure; imtool3D(MRI_Volume);

%% --------------------------------------------------------------------
% Step II: Fast Marching Method for segmentation 
%           (2D single breast MRI slice)

%%
% store the selected slice #20 in a new 'I' variable and convert to 'double'
I = double( MRI_Volume(:,:,20));

% display the selected slice
figure(); 
imshow(I,[]); 
impixelinfo; 

% find coordinates of the centre of the tumour

%%
% use 'gradientweight' to compute the weighted  
% gradient magnitude of the image (with sigma = 0.7)
W = gradientweight(I,0.7);

% specify the coordinates of the centre of the tumour
X = 543; Y = 255;

% display the result
figure(); 
imshow(W,[]); 

hold on;             
% visuliase the tumour centre as a '.' point in the same axes
plot(X,Y,'.','MarkerSize',35,'Color','r');
hold off;

%%
% use 'imsegfmm' function with 0.03 threshold and defined X and Y
% coordinates to segment the tumour
thresh = 0.03;
BW = imsegfmm(W, X, Y, thresh);

% display the result
figure(); 
imshow(BW,[]); 

%%
% find the area of the segmented tumour (in pixels)
A_p = bwarea(BW); 

% get information about the space between the 
% pixels in mm (for x, y and z dimensions)
d_x = MRI_Info.PixelDimensions(1)
d_y = MRI_Info.PixelDimensions(2)
d_z = MRI_Info.PixelDimensions(3)

% this means that each pixel in a slice 
% corresponds to 0.4464 mm
% while the distance between slices is 5 mm

% convert the BW area to mm^2
A_mm = A_p*d_x*d_y;

%%
% compare the segmented tumour mask with the original image
figure('Position',[320 180 1400 660]); 
subplot(1,2,1); imshow(I,[]); title('Original image');
subplot(1,2,2); imshowpair(I,BW); 
title(['Segmented tumour: ' num2str(A_mm) ' mm^2']);

%%
% read about 'gradientweight' and 'imsegfmm' functions
doc gradientweight
doc imsegfmm

%% --------------------------------------------------------------------
% Answer the corresponding quiz questions (Moodle)

%% --------------------------------------------------------------------

