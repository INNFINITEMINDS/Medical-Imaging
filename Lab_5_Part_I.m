%% --------------------------------------------------------------------
%
% Lab 5: Visualisation and processing of microscopy images in MATLAB
%        PART I: Lab_5_Part_I.m
%        "Visualisation of RGB microscopy images"
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

% create a variable with the path to '\microscopy_images' folder
data_path = [home_path '/microscopy_images']

%% --------------------------------------------------------------------
% Step I: opening and visualising RGB fluorescence microscopy images
%         (fluorescence microscopy example)

%% 
% go to '\microscopy_images\' folder
cd(data_path);

%%
% read the .jpg image  using 'imread' function 
% (source: the cell image library http://www.cellimagelibrary.org/)
I_rgb = imread('cellimagelibrary_fluorescence_example_2.jpg');

% this is a multi-color immuno fluorescence microscopy image
% of human fibroblast cells in culture stained with various antibodies:
% phase contrast (green) image was overlayed over the 
% microtubule (red) and speckled nucleus (blue) image

%%
% check the size of the image (1763 x 2000 x 3) / 
% it has three channels: red, green and blue
size(I_rgb)

%%
% decrease the size by 4 in order to speed up visualisation
I_rgb = imresize(I_rgb,1/2);

%%
% check the updated image size
size(I_rgb)

%%
% visualise each of the channels separately by selecting 1,2 or 3 in the last dimension 
figure('Name','Lab 5: example #1','Position', [611 123 865 806]);
subplot(2,2,1); imshow(I_rgb); title('I rgb(:,:,:) / original'); 
subplot(2,2,2); imshow(I_rgb(:,:,1)); title('I rgb(:,:,1) / red channel'); 
subplot(2,2,3); imshow(I_rgb(:,:,2)); title('I rgb(:,:,2) / green channel'); 
subplot(2,2,4); imshow(I_rgb(:,:,3)); title('I rgb(:,:,3) / blue channel'); 

%%
% you can also convert RGB images to intensity images (which have only 
% one channel) by using 'rgb2gray' function
I_grey = rgb2gray(I_rgb);

%%
% check the size of 'I_grey' (it has only 2 dimensions now)
size(I_grey)

%%
% visualise the intensity image cfigure();
imshow(I_grey);

% specify the colour map to be 'jet' and add a 'colorbar'
colormap('jet'); colorbar

% (pseudocolouring is applicable only to intensity images)

%%
% try adjusting the contrast manually using 'imcontrast' function
imcontrast;

% colormap and imcontrast options are available only for 
% intensity images

%%
% you can also visualise intensities in 3D view using 'mesh' function
% (the grey intensity representing the 'z' coordinate)
figure(); 
mesh(I_grey);
% (the default colormap is 'parula')


% try rotating it
rotate3d on;

%%
% you can also plot the image profile along a specified line

% at first, get the size of the image
[rows columns channels] = size(I_rgb);
% strore the size of 'I_rgb' in [x, y, z, ...] format

% generate the coordinates representing the column in the middle
column_number = round(columns/2)      

% an array of values: 1,2, ..., rows
y = 1:1:rows;           

% array of 'ones' of size 'y' multiplied by the number of the column         
x = column_number*ones(size(y));

%%
% print the coordinates in the command line and analyse them
[y; x]

%%
% at first, lets visualise the line itself
figure(); 
imshow(I_rgb);      % display the image
hold on;            % hold on (the axes won't be refreshed)

plot(x,y,'k','LineWidth',2);      % plot the line in the same axes
hold off;           % release the axes

%%
% next, plot the image pixel values along the line for each channel
figure();
plot(I_rgb(y,x,1),'r'); hold on; 
plot(I_rgb(y,x,2),'g'); 
plot(I_rgb(y,x,3),'b'); hold off;
title('color profiles'); grid on; 

%%
% investigate parameters of 'plot' function 
doc plot


%% --------------------------------------------------------------------
% Step II: creating publication-quality figures for microscopy 
%          image analysis (spinal cord histology example / histologyguide.org)

%%
% load the following image from the '\microscopy_images' folder 
% using 'imread' function
I_rgb = imread([data_path '/histologyguide_org_spinal_cord_example_6.jpg']);

%%
% check the size of this image
size(I_rgb)

% it has three RGB colour channels and 1280x1832 pixel dimensions
% (by default - all commonly used image formats are rgb)

%%
% create a new figure object and store the reference in 'h_f' variable
h_f = figure();

% set the 'h_f' figure background color to be white
set(h_f,'Color','w');    

% remove the menu from the 'h_f' figure using 
% 'set' function and 'menubar' property
set(h_f, 'menubar', 'none'); 

%%
% visualise the image using 'imagesc' function
imagesc(I_rgb);  

% (spinal cord histology example)

% unlike 'imshow', 'imagesc' allows resizing of visualised images
% irrespective of the original dimensions

% (try resizing it)

%%
% get the handle to the current axes using 'gca' function 
% (so that we can change its properties)
h_gca = gca;

%%
% add a title to the current axes
title(h_gca, 'Spinal cord histology example');

%%
% modify the 'Position' property of the 'h_f' figure 
% 'Position' format: [x y height width]
set(h_f,'Position',[690 90 955 930]); 

%%
% activate grid 
grid on;        

%%
% now, let's change the X and Y axis tick labels - so that
% they will correspond to the real dimensions (instead of pixels)

scale_factor = 50/250;    % scale: 250 pixels = 50 mu m

x_org_ticks = get(h_gca,'Xtick');   % get 'xtick' and 'ytick' values 
y_org_ticks = get(h_gca,'Ytick');   % from 'h_s' subplot

x_scl_tick_labels = round(scale_factor*x_org_ticks);   % scale 'xtick' and  
y_scl_tick_labels = round(scale_factor*y_org_ticks);   % 'ytick' values

set(h_gca,'Xticklabel',x_scl_tick_labels);        % set new 'xtick' and 
set(h_gca,'Yticklabel',y_scl_tick_labels);        % 'ytick' labels

%%
 % set X and Y labels to '[mu m]'
xlabel(h_gca,'\mum');    
ylabel(h_gca,'\mum'); 

%%
% activate 'impixelinfo' option in the 'h_f' figure
impixelinfo(h_f);   

% notice that the pixel value is now displayed in the left corner
% as a combination of 3 values (RGB)

%%
% draw a rectangle object in order to highlight a 
% certain area using 'rectangle' function

rectangle('Position',[1300,620,380,440],'EdgeColor','r','LineWidth',3)

% such properties as 'Position', 'EdgeColor',
% 'LineWidth', etc. should be used to define how this
% shape will look like
 
%%
% read about 'rectangle' function
doc rectangle

%% --------------------------------------------------------------------
% prepare for the next part of the laboratory

%%
% go back to the home directory using 'cd' function
cd(home_path);

% and proceed to the next part ('Lab_5_Part_II.m' file)

%%

