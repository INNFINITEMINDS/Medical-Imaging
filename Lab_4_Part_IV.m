%% --------------------------------------------------------------------
%
% Lab 4: Segmentation of DICOM Volumes in MATLAB
%        PART IV: Lab_4_Part_IV.m
%       (intensity-based image registration)
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
% Step I: uploading .dcm volumes for processing
%         (brain PET and MRI .dcm volumes / cancer)

%%
% go to '.../dicom_data/' folder
cd([home_path '/dicom_data'])

%%
% load brain MRI and PET volumes (intrapatient)

% read the MRI .dcm volume
MRI_Info = dicom_read_header([pwd '/MRI_head_tumour/']);
MRI_Volume = dicom_read_volume(MRI_Info);

% read the PET .dcm volume
PET_Info = dicom_read_header([pwd '/PET_head_tumour/']);
PET_Volume = dicom_read_volume(PET_Info);

% read the CT .dcm volume
CT_Info = dicom_read_header([pwd '/CT_head_tumour/']);
CT_Volume = dicom_read_volume(CT_Info);

%%
% visualise the volumes and find the tumour in all volumes
figure('Position',[30 370 560 420]); 
imtool3D(MRI_Volume,[]);

figure('Position',[400 130 560 420]); 
imtool3D(CT_Volume,[]); imcontrast;
% for CT - contrast adjustment is required 
% (!!!! select the second peak only / soft tissue window)

figure('Position',[850 350 560 420]); 
imtool3D(PET_Volume,[]); imcontrast;
% (adjust the contrast, if required)

% although all these volumes show the same anatomy - 
% notice the difference in the dimensions and positions

%%
% compare the size and pixel/mm scale of the volumes
size(MRI_Volume)
size(PET_Volume)
size(CT_Volume)

MRI_Info.PixelDimensions
PET_Info.PixelDimensions
CT_Info.PixelDimensions

%%
% go back to the home folder
cd(home_path)

%% --------------------------------------------------------------------
% Step II: 2D registration of multimodal .dcm images
%         (brain PET and MRI .dcm volume slices / cancer)

%%
% select slices #54 and #28 in the MRI and PET volumes
I_fixed = MRI_Volume(:,:,52);
I_moving = PET_Volume(:,:,25);

% (in this registration example, MRI is 'fixed' and PET is 'moving')

figure('Position',[235 190 1140 460]);
subplot(1,2,1); imshow(I_fixed,[]); title('I fixed'); 
subplot(1,2,2); imshow(I_moving,[]); title('I moving'); colormap(gca,'jet');

%%
% visualise the 'fusion' of both images 
% using 'imshowpair' function (real dimensions)
figure('Position', [770 95 575 670]);
imshowpair(I_moving, I_fixed);
title('Before registration / fusion');

%%

% 'imregconfig' function is used to create an 'optimizer 
% and metric configuration for the registration procedure
[optimizer,metric] = imregconfig('multimodal');

% specify the number of iterations (the default value is 100)
optimizer.MaximumIterations = 300;

% 'imregister' function aligns two images to a common 
% coordinate system using intensity-based image 
% registration and the specified settings

I_moving_Reg = imregister(I_moving, I_fixed, 'affine', optimizer, metric);

figure('Position',[235 190 1140 460]);
subplot(1,2,1); imshow(I_fixed,[]); title('I fixed'); 
subplot(1,2,2); imshow(I_moving_Reg,[]); title('I moving - REGISTERED'); colormap(gca,'jet');

%%
% visualise the results
figure('Position',[150 15 1225 645]);
subplot(1,2,1); imshowpair(I_fixed,I_moving);
title('Before registration / fusion');

subplot(1,2,2); imshowpair(I_fixed,I_moving_Reg);
title('After registration / fusion');

%%
% read about 'imregconfig' and 'imregister' functions
doc imregconfig
doc imregister

%%
% in this laboratory, we considered only a 2D registration case

% you can find information about 3D registration in this example:
web('https://uk.mathworks.com/help/images/examples/registering-multimodal-3-d-medical-images.html');

%% --------------------------------------------------------------------
% prepare for the next part of the laboratory

%%
% go back to the home directory 
cd(home_path);

% and proceed to the next part ('Lab_4_Part_V.m' file)

%%
