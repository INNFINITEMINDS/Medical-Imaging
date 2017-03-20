I_rgb = imread('https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/Skin_Tumors-P9071282.jpg/1024px-Skin_Tumors-P9071282.jpg');
imagesc(I_rgb);

figure();
I_grey = rgb2gray(I_rgb);
imshow(I_grey);

figure();
I_1 = medfilt2(I_grey,[10 5]);
imagesc(I_1);colormap(gray);

figure();
GradGrey= imgradient(I_grey);
Grad_I_1= imgradient(I_1);
imagesc(GradGrey);


figure(); 
subplot(2,2,1); imagesc(I_rgb); title('Original'); 
subplot(2,2,2); imshow(I_grey); title('Grey Scale');colormap(gray);
subplot(2,2,3); imshow(I_1); title('Filtered'); colormap(gray);
subplot(2,2,4); imshow(GradGrey); title('imgradient of filtered image'); colormap(hot);


figure();
adj = imadjust(I_grey);
ada = adapthisteq(I_grey);
subplot(2,3,1); imshow(I_grey); 
subplot(2,3,2); imshow(adj); 
subplot(2,3,3); imshow(ada);
subplot(2,3,4); imhist(I_grey);
subplot(2,3,5); imhist(adj);
subplot(2,3,6); imhist(ada);