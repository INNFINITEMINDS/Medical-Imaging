%% --------------------------------------------------------------------
%
% Lab 5: Visualisation and processing of microscopy images in MATLAB
%        PART IV: Lab_5_Part_IV.m 
%        "Reading and analysing time series 2D microscopy image volumes (video)"
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
% TASK: Reading and analysing time series 2D microscopy image volumes (video)
%         (embryoscope video recorded for 113 h / source: PAN Klinik www.pan-klinik.de)

%%
% get access to the following video by creating a new video reader object 
VR_embr = VideoReader([data_path '/PAN_Klinik_embryoscope_video.mov']);  

%%
% get parameters of the video
I_h = VR_embr.Height;     % width of video frame 
I_w = VR_embr.Width;      % width of video frame           

VR_embr.Duration          % duration: 47 s
VR_embr.FrameRate         % frame rate: 5 frames per second

% frame number N = duration * frame rate
N = VR_embr.Duration * VR_embr.FrameRate

% (the video has 235 frames)

%% --------------------------------------------------------------------
% create a empty 3D I_h x I_w x N size array 
% using 'zeros' function
V_embr = zeros(I_h,I_w,N);  

%%
% read all 235 frames from the 'VR_embr' video reader 
% stream one by one
for i = 1:N
   I = VR_embr.readFrame;  % read a frame
   I = rgb2gray(I);        % convert to the grey scale 
   V_embr(:,:,i) = I;      % add to the 3D data set (frame # i)
end

%%
% use 'implay' to visualise the volume
implay(uint8(V_embr));

% in the movie player window start the movie
% next, use 'Tools -> Pixel Region' option for zoomed visualisation 

% expand the 'zoomed' region
% play the video and 
% analyse this dataset and development of the embryo

%%
% visualise every 20th frame using 'montage' function

% generate an array of frames with 20 step (1, 21, 41, ...) 
v_frames = 1:20:N

[x y z] = size(V_embr);

figure(); 
montage(reshape(V_embr,[x y 1 z]),[0 255],'Indices',v_frames);

% ('montage' function works with 4D RGB image volumes only and
% we need to use 'reshape' function to add an additional dimension)

%%
% select one frame for processing (2 days old embryo at 48.3 h)
I = V_embr(:,:,72);

% visualise the frame
figure('Position',[880 140 800 800]);
imagesc(I); colormap(gray); h_s = gca;

%%
% create an ellipse object in the figure and
% fit its shape over the embryo boundary
h_el = imellipse(h_s);

% (check the lab instructions to see how the 
% result shold look like)

%%
% create a binary mask from the ellipse shape
bw_I_mask = h_el.createMask;

% and visualise it
figure(); imshow(bw_I_mask,[]); 

%%
% combine the original image with the mask 
% using 'immultiply' function 
I_c = immultiply(uint8(I),uint8(bw_I_mask)); 

% (we had to convert it to 'uint8' type first)

% and visualise it
figure('Position',[880 140 750 750]);
imagesc(I_c); colormap(gray);

%%
% compute the area of the mask (in pixels) 
% using 'bwarea' function
bw_I_area = bwarea(bw_I_mask);

% estimate the mean diameter (A = pi*r^2)c
bw_I_d = 2*sqrt(bw_I_area/pi);

%%
% add text to the image (for visualisation purposes)
% with 'insertText' function
text = ['area: ' num2str(round(bw_I_area)) ' / diameter: ' num2str(round(bw_I_d)) ];
I_c_t = insertText(I_c,[1 1],text);

% visualise the resulting image
figure('Position',[880 140 750 750]);
imagesc(I_c_t); 

%%
% using 'imdistline' - verity that  
% the mean diameter was estimated correctly
h_dl = imdistline;

% (it will be created in the currently active figure / gca)

%%
% 'imellipse' and other similar functions can be used
% for manual segmentation of objects in images

% read about 'imrect' and 'imfreehand' functions
doc imrect
doc imfreehand

%% --------------------------------------------------------------------
% prepare for the next part of the laboratory

%%
% go back to the home directory using 'cd' function
cd(home_path);

% and proceed to the next part ('Lab_5_Part_V.m' file)

%%
