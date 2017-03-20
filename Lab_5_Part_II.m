%% --------------------------------------------------------------------
%
% Lab 5: Visualisation and processing of microscopy images in MATLAB
%        PART II: Lab_5_Part_II.m 
%        "Contrast adjustment and image filtering"
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
data_path = [home_path '/microscopy_images']

%% --------------------------------------------------------------------
% Step I: basic contrast enhancement methods
%         (bone marrow microscopy example: www.pathologyoutlines.com dataset)

%%
% read the following image from the '/microscopy_images/' folder
I_rgb = imread([data_path '/bone_marrow_microscopy_example_3.jpg']);

% and visualise it
figure(); imagesc(I_rgb);
%%
% convert it to the grey scale
I = rgb2gray(I_rgb);

% decrease the size of the image 
I = imresize(I,0.7);

% and visualise it together with the histogram ('imhist' function)
figure(); 
subplot(2,1,1); imshow(I); imcontrast;
subplot(2,1,2); imhist(I);

% 'imcontrast' function is based on the principle of
% manual cropping of the histrogram range

% notice the three peaks corresponding to the 
% background and cell intensity values

% !!!!!!!!!! try selecting each of the peaks only and 
% see what happens with the image

%%
% read about 'imhist' function
doc imhist

%%
% now, we will apply commonly used contrast adjustment functions
% and compare them

I_1 = imadjust(I);      % crops the histogram range (see 'doc imadjust')
I_2 = histeq(I,64);     % equalises the historgam intensity distribution
I_3 = adapthisteq(I);   % is based on adaptive histogram equalization

figure('Position',[120 100 1520 590]); 
subplot(2,4,1); imshow(I); colormap(gray);  title('original')
subplot(2,4,5); imhist(I); 

subplot(2,4,2); imshow(I_1); title('imadjust')
subplot(2,4,6); imhist(I_1); 

subplot(2,4,3); imshow(I_2); title('histeq')
subplot(2,4,7); imhist(I_2);

subplot(2,4,4); imshow(I_3); title('adapthisteq')
subplot(2,4,8); imhist(I_3); 

% !!! compare the resulting histograms 

% the choice of the method will depend on the application area
% in our case, obviously, 'imadjust' produces the highest contrast, 
% which is essential in blood cell count analysis

%% --------------------------------------------------------------------
% Step II: basic filtering methods for greyscale and RGB images
%         (glioblastoma histology example)

%%
% read the following image from the web 
I_rgb_org = imread('https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Glioblastoma_with_extreme_nuclear_enlargement_-_very_high_mag.jpg/1024px-Glioblastoma_with_extreme_nuclear_enlargement_-_very_high_mag.jpg');

% crop it 
I_rgb = imcrop(I_rgb_org,[150 150 600 500]);

% convert to greyscale
I = rgb2gray(I_rgb);

% and visualise the results
figure('Position',[940 125 685 800]); 
subplot(2,2,[1,2]); 
    imagesc(I_rgb_org); hold on;
    rectangle('Position',[150 150 600 500],'EdgeColor','k','LineWidth',3)
    hold off; % this rectangle correspons to the boundaries of the cropped image
    title('original');

subplot(2,2,3); 
    imagesc(I_rgb); title('cropped');
    
subplot(2,2,4); 
    imagesc(I); colormap(gray); title('grey');


%% 
% image filtering is commonly applied in order to 
% remove the noise and smooth or enhance the features

% now - we will apply some of the commonly used filters and 
% analyse what effect do they produce

I_1 = medfilt2(I,[5 5]);     % median filter with 5x5 window 
I_2 = medfilt2(I,[10 10]);   % median filter with 10x10 window

I_3 = rangefilt(I);          % local range of image
I_4 = entropyfilt(I);        % local entropy of image

% next, apply 'rangefilt' to the image already filtered with median filter
I_5 = rangefilt(medfilt2(I,[10 10]));

%%
% visualise the results
figure('Position',[80 120 1540 780]); 
subplot(2,3,1); imagesc(I); title('original: I'); colormap(gray);

subplot(2,3,2); imagesc(I_1); title('medfilt2(I,[5 5])'); colormap(gray);
subplot(2,3,3); imagesc(I_2); title('medfilt2(I,[10 10])'); colormap(gray);

subplot(2,3,4); imagesc(I_3); title('rangefilt(I)'); colormap(gray);
subplot(2,3,5); imagesc(I_4); title('entropyfilt(I)'); colormap(gray);

subplot(2,3,6); imagesc(I_5); title('rangefilt(medfilt2(I,[10 10]))'); colormap(gray);

% again, the choice of the image processing strategy
% depends on the problem that you need to solve 
% (e.g., segmentation of cells nucleus or boundaries)

% other that you might want to explore include: wiener2, imsharpen, stdfilt, etc. 

%%
% however, most of the MATLAB filtering functions can be 
% applied only to greyscale images

% here, we will demonstrate how to apply filters to RBG images

% 'imfilter' is a universal filtering function used in combination 
% with 'fspecial' that generates various filter types

h_1 = fspecial('average', [5 5]);   % generate 'average' filter with 5x5 window
I_rgb_1 = imfilter(I_rgb,h_1);      % apply the filter to the image

h_2 = fspecial('laplacian', 0.1);   % generate 'laplacian' filter
I_rgb_2 = imfilter(I_rgb,h_2);      % apply the filter to the image


% visualise the results
figure('Position',[80 120 1540 780]); 
subplot(1,3,1); imagesc(I_rgb); title('original: I rgb'); 
subplot(1,3,2); imagesc(I_rgb_1); title('imfilter: average,[5 5]'); 
subplot(1,3,3); imagesc(I_rgb_2); title('imfilter: laplacian'); 

%% --------------------------------------------------------------------
% prepare for the next part of the laboratory

%%
% go back to the home directory using 'cd' function
cd(home_path);

% and proceed to the next part ('Lab_5_Part_III.m' file)

%%
