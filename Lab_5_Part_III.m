%% --------------------------------------------------------------------
%
% Lab 5: Visualisation and processing of microscopy images in MATLAB
%        PART III: Lab_5_Part_III.m 
%        "Gradient and morphology-based feature enhancement"
%
%% --------------------------------------------------------------------
% PREPARATION: specifying the path to the home folder 

%%
% !!! make sure that you are in the 'Medical_Imaging_Lab_5' folder !!!

%%
% prepare for this part of the laboratory
clear all;      % clear the workspace (remove all variables)
close all;      % close all windows 
clc;            % clear the command line 

%%
% store the string with the current folder path in a new variable 'home_path'
home_path = pwd;

% create a variable with the path to '/microscopy_images' folder
data_path = [home_path '/microscopy_images'];

%% --------------------------------------------------------------------
% Step I: image gradient 
%         (chronic cholecystitis with cholesterolosis and intestinal metaplasia histology example)

%%
% read the following image from the web 
I_rgb = imread('https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/Chronic_cholecystitis_with_cholesterolosis_and_intestinal_metaplasia.JPG/1024px-Chronic_cholecystitis_with_cholesterolosis_and_intestinal_metaplasia.JPG');

% and visualise
figure('Position',[645 105 975 795]); 
imagesc(I_rgb);

% convert to greyscale
I = rgb2gray(I_rgb);

%%
% compute the image gradient using 'imgradient' function
[I_Gmag, I_Gdir] = imgradient(I);

% and visualise the results
figure('Position',[80 120 1540 780]); 
subplot(1,2,1); imagesc(I); title('original: I'); colormap(gray);
subplot(1,2,2); imagesc(I_Gmag); title('imgradient: I Gmag'); colormap(gca,jet);

% as you can see, the outcome is quite similar to 'rangefilt' function
% this type of image processing functions is commonly used in 
% image segmentation and detection of object boundaries

%% --------------------------------------------------------------------
% Step II: morphology-based image filtering and feature enhancement 
%         (pyramidal hippocampal neuron microscopy example)

%%
% read the following image (source: wikimedia.org dataset)
I_rgb = imread([data_path '/Pyramidal_hippocampal_neuron_40x.jpg']);

% convert to greyscale
I = rgb2gray(I_rgb);

% resize (to decrease the processing time)
I = imresize(I,0.7); 

%%
% MATLAB has a series of functions for morphology-based image processing:
% a simple element (e.g., disk or rectangle) is used to dilate or erode
% pixel intensity values within its boundaries

% 'imdilate' and the other similar functions require the
% structuring element, which is defined by 'strel' function

I_dilate = imdilate(I,strel('disk',5));       
I_erode = imerode(I,strel('disk',5));

I_open = imopen(I,strel('disk',5)); 
I_close = imclose(I,strel('disk',5)); 

I_max = imhmax(I,100); 

% visualise the results
figure('Position',[25 100 1625 845]);  
subplot(2,3,1); imagesc(I); title('original'); colormap(gray); impixelinfo;

subplot(2,3,2); imagesc(I_dilate); title('imdilate / disk,5'); colormap(gray);
subplot(2,3,3); imagesc(I_erode); title('imerode / disk 5'); colormap(gray);

subplot(2,3,4); imagesc(I_max); title('imhmax / > 100'); colormap(gray);

subplot(2,3,5); imagesc(I_close); title('imclose / disk,5'); colormap(gray);
subplot(2,3,6); imagesc(I_open); title('imopen / disk,5'); colormap(gray);

% notice the small circles in the processed images
% normally, a sequence of various morphology operations 
% is applied in order produce optimal feature enhancement

%%
% read about 'imopen' and other functions
doc imopen
doc imdilate

%%

% now, investigate how the size and type of the structuring
% element will change the results

% increase the size of the structuring element
I_open_d_5 = imopen(I,strel('disk',5)); 
I_open_d_10 = imopen(I,strel('disk',10));
I_open_d_20 = imopen(I,strel('disk',20));

% use the 'diamond' element shape instead
I_open_m_5 = imopen(I,strel('diamond',5)); 
I_open_m_10 = imopen(I,strel('diamond',10));
I_open_m_20 = imopen(I,strel('diamond',15));

% visualise the results
figure('Position',[25 100 1625 845]); 
subplot(2,3,1); imagesc(I_open_d_5); title('strel(disk,5)'); colormap(gray);
subplot(2,3,2); imagesc(I_open_d_10); title('strel(disk,10)'); colormap(gray);
subplot(2,3,3); imagesc(I_open_d_20); title('strel(disk,20)'); colormap(gray);

subplot(2,3,4); imagesc(I_open_m_5); title('strel(diamond,5)'); colormap(gray);
subplot(2,3,5); imagesc(I_open_m_10); title('strel(diamond,10)'); colormap(gray);
subplot(2,3,6); imagesc(I_open_m_20); title('strel(diamond,20)'); colormap(gray);

%% --------------------------------------------------------------------
% prepare for the next part of the laboratory

%%
% go back to the home directory using 'cd' function
cd(home_path);

% and proceed to the next part ('Lab_5_Part_IV.m' file)

%%
