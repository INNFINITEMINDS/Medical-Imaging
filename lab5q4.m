I_rgb = imread('http://www.pathologyoutlines.com/images/marrow/191R.jpg');
I_grey = rgb2gray(I_rgb);
imagesc(I_grey);colormap(gray);

figure();
I_1 = medfilt2(I_grey,[10 10]);
imagesc(I_1);colormap(gray);

figure(); 
subplot(1,3,1); imagesc(I_rgb); title('Original'); 
subplot(1,3,2); imagesc(I_grey); title('Grey Scale');colormap(gray);
subplot(1,3,3); imagesc(I_1); title('Filtered'); colormap(gray);

N = 17; 
I_N_thresh = multithresh(I_1,N);
I_mask = imquantize(I_1,I_N_thresh);
I_mask_cl = I_mask;
I_mask_cl(I_mask > 8) = 0;
I_mask_cl = imfill(I_mask_cl,'holes');
I_mask_cl(1:5,:) = 0; I_mask_cl(end-5:end,:) = 0; 
I_mask_cl(:,1:5) = 0; I_mask_cl(:,end-5:end) = 0; 
I_mask_rgb = label2rgb(I_mask_cl,'hsv');
I_result = imfuse(I_rgb, I_mask_rgb,'blend');

figure('Position',[210 110 1400 810]);
subplot(2,2,1); imagesc(I_rgb); title('Original image'); 
subplot(2,2,2); imagesc(I_1); title('Filtered greyscale image'); colormap(gca,gray);
subplot(2,2,3); imagesc(I_mask); title('Segmented image (imquantize)'); colormap(gca,jet); colorbar;
subplot(2,2,4); imagesc(I_mask_cl); colormap(gca,gray);
title('Extracted mask: (mask > 8) = 0');

figure('Position',[90 90 1560 875]); 
subplot(1,2,1); imagesc(I_rgb); title('Original image'); 
subplot(1,2,2); imagesc(I_result); title('Segmented cells');
grid on;