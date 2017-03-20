I_rgb = imread('https://upload.wikimedia.org/wikipedia/commons/5/58/AML-M6%2C_multinucleated_erythroblast.jpg');
I_grey = rgb2gray(I_rgb);
imagesc(I_grey);colormap(gray);
h_free = imfreehand();
bw_I_mask = h_free.createMask;
figure(); imshow(bw_I_mask,[]); 
I_c = immultiply(uint8(I_grey),uint8(bw_I_mask)); 
figure('Position',[880 140 750 750]);
imagesc(I_c); colormap(gray);

bw_I_area = bwarea(bw_I_mask);
bw_I_d = 2*sqrt(bw_I_area/pi);
h = imdistline(gca);
api = iptgetapi(h);
text = ['area: ' num2str(round(bw_I_area)) ' / diameter: ' num2str(round(bw_I_d)) ];
I_c_t = insertText(I_c,[1 1],text);

%% 100pixels = 10um

scale = 0.1
BW_d_sc = bw_I_d*scale; 
BW_a_sc = bw_I_area*(scale^2);

