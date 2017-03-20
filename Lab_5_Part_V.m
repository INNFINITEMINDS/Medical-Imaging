%% --------------------------------------------------------------------
%
% Lab 5: Visualisation and processing of microscopy images in MATLAB
%        PART IV: Lab_5_Part_V.m 
%        "Analysing microscopy images: intensity-based cell segmentation"
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
% Step I: simple threshold-based cell segmentation 
%         (bone marrow smear example: www.pathologyoutlines.com dataset)

%%
% read the following image from the web
I_rgb = imread('http://www.pathologyoutlines.com/images/marrow/207B.jpg');

% visualise
figure('Position',[905 90 745 875]);
imagesc(I_rgb);

% and convert to grey
I = rgb2gray(I_rgb);

%%
% at first, smooth the image using 'medfilt2' function
% with 5x5 window
I_f = medfilt2(I,[5 5]); 

% threshold the image using 'im2bw' function with 0.35 threshold
% ('BW' is a logical mask)
BW_org = ~im2bw(I_f,0.35);

% visualise the results
figure('Position',[340 360 1320 585]); 
subplot(1,3,1); imagesc(I); title('greyscale I');
subplot(1,3,2); imagesc(I_f); colormap(gray); title('smoorthed I');
subplot(1,3,3); imagesc(BW_org); colormap(gray); title('original BW');

%%
% remove all components that are smaller than 200 pixels
BW_final = bwareaopen(BW_org,200); 

% fill all internal holes in the mask using 'imfill' function
BW_final = imfill(BW_final,'holes');

% convert the binary mask to an RGB labeled image
% using 'bwlabel' and 'label2rgb' functions
[BW_L, N] = bwlabel(BW_final);
BW_L_RGB = label2rgb(BW_L);
% the returned 'N' value is the number of detected elements

% combine the original image with the BW label using 'imfuse'
% function (for visualisation purposes)
I_result = imfuse(I_rgb, BW_L_RGB,'blend');

% visualise the results
figure('Position',[340 20 1320 585]); 
subplot(1,3,1); imagesc(BW_final); colormap(gray); title('processed BW');
subplot(1,3,2); imagesc(BW_L_RGB); title('label mask');
subplot(1,3,3); imagesc(I_result); title('fused image + mask');

%%
% compare the original with the segmented mask
figure('Position',[450 90 1185 860]); 
subplot(1,2,1); imagesc(I_rgb); title('original I');
subplot(1,2,2); imagesc(I_result); 
title(['# of objects (white cells): ' num2str(N)])

% however, this method is not perfect
% as you can notice - because some of the cells are located
% too close to each other - they were detected as one object

% normally, more advanced segmentation methods are applied

% they provide the means for automated analysis of shape and 
% intensity variations

%% --------------------------------------------------------------------
% Step II: multithreshold cell segmentation 
%         (white and grey brain matter histology example)

%%
% read the following image from the web
I_rgb = imread('https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Grey_matter_and_white_matter_-_very_high_mag.jpg/1024px-Grey_matter_and_white_matter_-_very_high_mag.jpg');

% and convert to grey and visualise
I = rgb2gray(I_rgb);

figure('Position',[325 110 1300 850]); 
imagesc(I_rgb); title('Original image'); 

% (the task is to detect all cells in the 
% image for further analysis)

%%
% at first, apply 'adapthisteq' for contrast adjustment
% in order to enhance all cell objects
I_f = adapthisteq(I);

% next, smooth the image using 'medfilt2' function
% with 10x10 window
I_f = medfilt2(I_f,[10 10]); 

% visualise the filtered image and compare with the original
figure(); 
imagesc(I_f); colormap(gca,gray);
title('Filtered greyscale image'); 

% as you can see - the contrast is significantly higher now

%%
% 'multithresh' function returns a vector containing 
% N automatically identified intensity threshold values 
% for the analysed image
N = 20; 
I_N_thresh = multithresh(I_f,N)

% next, segment the image into N 
% levels using 'imquantize' function 
I_mask = imquantize(I_f,I_N_thresh);

%%
% create a new variable where we will stored the final mask
I_mask_cl = I_mask;

% clear all values with labels greater than 12 (see)c
I_mask_cl(I_mask > 5) = 0;

% fill all holes in the image using 'imfill' function
I_mask_cl = imfill(I_mask_cl,'holes');

% clear the image border (in order to avoid artifacts)
I_mask_cl(1:5,:) = 0; I_mask_cl(end-5:end,:) = 0; 
I_mask_cl(:,1:5) = 0; I_mask_cl(:,end-5:end) = 0; 

%%
% visualise all results
figure('Position',[210 110 1400 810]);
subplot(2,2,1); imagesc(I_rgb); title('Original image'); 
subplot(2,2,2); imagesc(I_f); title('Filtered greyscale image'); colormap(gca,gray);
subplot(2,2,3); imagesc(I_mask); title('Segmented image (imquantize)'); colormap(gca,jet); colorbar;
subplot(2,2,4); imagesc(I_mask_cl); colormap(gca,gray);
title('Extracted mask: (mask > 5) = 0');


%%
% next, convert the 'I_mask_cl' to an RGB labeled image with 'hsv' colour map 
I_mask_rgb = label2rgb(I_mask_cl,'hsv');

% combine the original image with the RGB mask label using 'imfuse'
% function (for visualisation purposes)
I_result = imfuse(I_rgb, I_mask_rgb,'blend');

%%
% visualise the results
figure('Position',[90 90 1560 875]); 
subplot(1,2,1); imagesc(I_rgb); title('Original image'); 
subplot(1,2,2); imagesc(I_result); title('Segmented cells');
grid on;

% notice that using multithreshold segmentation we can also see  
% the intensity variations, which is helpful in cell type analysis

%%

% Answer the corresponding quiz questions (Moodle)

%%
