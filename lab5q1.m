I_rgb = imread('https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/HeLa-I.jpg/922px-HeLa-I.jpg');
size(I_rgb)
figure(); imagesc(I_rgb);

subplot(2,2,1); imshow(I_rgb); title('I rgb(:,:,:) / original'); 
subplot(2,2,2); imshow(I_rgb(:,:,1)); title('I rgb(:,:,1) / red channel'); 
subplot(2,2,3); imshow(I_rgb(:,:,2)); title('I rgb(:,:,2) / green channel'); 
subplot(2,2,4); imshow(I_rgb(:,:,3)); title('I rgb(:,:,3) / blue channel'); 


figure(); imagesc(I_rgb);
rectangle('Position',[220,190,128,144],'EdgeColor','r','LineWidth',3)


figure(); 
I_blue = I_rgb(:,:,3);
mesh(I_blue);colormap('jet'); colorbar


I_1 = I_rgb(:,:,1);
I_2 = I_rgb(:,:,2);
I_3 = I_rgb(:,:,3);

subplot(2,3,1); imshow(I_1); title('red channel')
subplot(2,3,4); imhist(I_1); 

subplot(2,3,2); imshow(I_2); title('green channel')
subplot(2,3,5); imhist(I_2);

subplot(2,3,3); imshow(I_3); title('blue channel')
subplot(2,3,6); imhist(I_3); 