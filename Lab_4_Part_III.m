%% --------------------------------------------------------------------
%
% Lab 4: Segmentation of DICOM Volumes in MATLAB
%        PART III: Lab_4_Part_III.m
%       (MIP, 3D segmentation and 3D rendering methods)
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
% Step I: loading processed .dcm volume from a .mat file
%         (head MRA scan)

%%
% go to '.../dicom_data' folder
cd([home_path '/dicom_data'])

%%
% load the following MRA volume for processing:
load MRA_cerebral_aneurysm.mat

% Head MR Angiography volume 
MRA_Volume = MRA_cerebral_aneurysm;

% visualise the volume and locate the aneurism
figure('Position', [800, 400, 500, 500]),
imtool3D(MRA_Volume,[]);

%%
% go back to the home directory 
cd(home_path);

%% --------------------------------------------------------------------
% Step IV: Maximum Intensity Projection 
%          (head MRA volume)

%%
% create a new empty 2D image using 'zeros' functionc
MRA_MIP = zeros(size(MRA_Volume,1),size(MRA_Volume,2));

% check the size of 'MRA_MIP' variable
size(MRA_MIP)

%%
% for each pixel with i,j coordinates
for i = 1:size(MRA_MIP,1)
    for j = 1:size(MRA_MIP,2)
        % find the maximum value along the 'z' dimension ('max')
        MRA_MIP(i,j) = max((MRA_Volume(i,j,:)));
    end
end

% visualise the result
figure(); imshow(MRA_MIP,[]);

%% --------------------------------------------------------------------
% Step III: Multithreshold segmentation 
%          (single head MRA volume slice)

%%
% select the slice #52 (with clearly visible arteries)
I = MRA_Volume(:,:,52);

% specify the number of thresholds to be 20
N = 20;

% generate the intensity threshold values using 'multithresh' function
I_thresholds = multithresh(I,N)

% next, based on these thresholds 
% perform segmentation using 'imquantize' function
I_mask_org = imquantize(I,I_thresholds);

%%
% create a new 'I_mask' variable
I_mask = I_mask_org;

% clear all pixels with the values < 7
I_mask(I_mask < 7) = 0; 

% visualise the results
figure('Position', [10, 50, 1500, 500]);
subplot(1,3,1); imshow(I,[]); title('Original greyscale image'); colorbar; 
subplot(1,3,2); imshow(I_mask_org,[]); colormap(gca,jet); title('Multiple threshold mask'); colorbar; 
subplot(1,3,3); imshow(I_mask,[]); colormap(gca,jet); title('Vessel-only threshold mask'); colorbar; 

%% --------------------------------------------------------------------
% Step IV: Multithreshold segmentation 
%          (head MRA scan)

%%
%declare the variables for the segmentation mask using 'zeros' functions
MRA_Volume_mask = zeros(size(MRA_Volume));
MRA_arteries = zeros(size(MRA_Volume));

% extract 20 thresholds from the slice with visible arteries 
% (#52) using 'multithresh' function 
N = 20;
MRA_thresholds = multithresh(MRA_Volume(:,:,52),N);

% similarly to the single slice case, apply multithreshold 
% segmentation to all slices of the volume ('for' cycle)

for i=1:size(MRA_Volume,3)      % from slice #1 to #120
    
    I = MRA_Volume(:,:,i);      % select the slice

    I_mask = imquantize(I,MRA_thresholds);  % segment the image
    
    MRA_Volume_mask(:,:,i) = I_mask;        % store the original mask
     
    I_mask(I_mask < 7) = 0;     % remove everything < 7
    
    MRA_arteries(:,:,i) = I_mask;    % store the final mask
end

% visualise the .dcm volume with the segmented arteries 
figure('Name','Head MRA volume: threshold-based vessel segmentation')
imtool3D(MRA_arteries);

%%
% make all values > 0 to be '1' (will be easier to process)
MRA_arteries(MRA_arteries > 0) = 1;

% use 'isosurface' to generate faces and 
% vertices of the 3D surface
[faces, vertices] = isosurface(MRA_arteries);

%%
figure('Position',[ 835 75 560 670]);

% use 'patch' function to visualise the generated surface in 3Dcp = patch('Vertices', vertices, 'Faces', faces,'FaceColor','red','edgecolor', 'none');

alpha 0.6;           %'alpha' value controls opacity

camlight;            % activate lighting           
lighting gouraud;     

rotate3d on;          % activate 3D rotation option 
grid on;              % activate the grid
title('After thresholding');    % specify the title

%%
% as you can see the segmentation is not perfect

% remove all objects smaller that 6000 pixels
MRA_arteries_cl = bwareaopen(MRA_arteries,6000);

%%
% use 'shiftdim' and 'flipdim' functions to rotate the volume
% (better for 3D visualisation)
MRA_arteries_cl_R = shiftdim(MRA_arteries_cl,1);
MRA_arteries_cl_R = flipdim(MRA_arteries_cl_R,3);

% (basically, by shifting the volume dimension by 1 
% we converted it to axial plane and then flipped along z)

% see how the size has changed vs. the original 435x331x120
size(MRA_arteries_cl_R)

%%
% use 'isosurface' and 'patch' to generate and visualise the 3D surface
[faces, vertices] = isosurface(MRA_arteries_cl_R);

figure('Position',[865 20 560 755]);

p = patch('Vertices', vertices, 'Faces', faces,'FaceColor','red','edgecolor', 'none');

alpha 0.6;            %'alpha' value controls opacity

camlight;             % activate lighting           
lighting gouraud;     

rotate3d on;          % activate 3D rotation option 
grid on;              % activate the grid

view(-95,8);          % specify the view position

%%
% read about 'isosurface' and 'patch' functions
doc isosurface
doc patch

%% --------------------------------------------------------------------
% prepare for the next part of the laboratory

%%
% go back to the home directory 
cd(home_path);

% and proceed to the next part ('Lab_4_Part_IV.m' file)

%%
