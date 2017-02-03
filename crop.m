function [img_eye_dil] = calc_eyemap(img)
%Returns Bounding Box values based on number of objects
BB = step(FDetect,img);

%Crop image
img = imcrop(img,BB);
img = imresize(img,[144, 96]);
img = imcrop(img, [0 0 96 100]);
img = imcrop(img, [12 48 30 22]);

%Plotting Original Image
% figure;
% subplot(4,4,1)
% %imshow(img)
title('Original Image')

%% Step 2: Feature Extraction

% 1.1 Eye Detection

%Converting Original Image to YCbCr Base
img_ycbcr = rgb2ycbcr(img);
img_ycbcr = im2double(img_ycbcr);


%Plotting Image in YCbCr Base
% subplot(4,4,2)
% imshow(img_ycbcr)
% title('YCBCR Space');

img_ycbcr_lowface = img_ycbcr;
img_ycbcr_upperface = img_ycbcr;

img_y = img_ycbcr_upperface(:,:,1);
img_cb = img_ycbcr_upperface(:,:,2);
img_cr = img_ycbcr_upperface(:,:,3);


%Plotting cb^2
img_cb2 = img_cb.^2;
% subplot(4,4,3)
% imshow(img_cb2)
% title('CB^2');


%Plotting ccr^2
img_ccr2 = (1-img_cr).^2;
% subplot(4,4,4)
% imshow(img_ccr2)
% title('(1-CR)^2')


%Plotting Cb/Cr
img_cbcr = img_cb./img_cr;
% subplot(4,4,5)
% imshow(img_cbcr)
% title('CB/CR')


%Plotting Image in Gray-Space
img_gray = rgb2gray(img);
img_gray = im2double(img_gray);

img_gray_lowface = img_gray;
img_gray_upperface = img_gray;

% subplot(4,4,6)
% imshow(img_gray)
% title('Gray space');


%Chrom Eyemap
img_chromeye = 1/3*(img_cb2+img_ccr2+img_cbcr);
% subplot(4,4,7)
% imshow(img_chromeye)
% title('Chrom Eyemap')


%Equalised Chrom Eyemap
img_eq_chromeye = histeq(img_chromeye);
% subplot(4,4,8)
% imshow(img_eq_chromeye)
% title('Equalized Chrom Image');


%Luminance Eyemap
img_SE = strel('disk',4,0);
img_lum_dil = imdilate(img_gray_upperface,img_SE);
img_lum_erode = 1 + imerode(img_gray_upperface,img_SE);
img_lummap = img_lum_dil./img_lum_erode;

% subplot(4,4,9)
% imshow(img_lummap)
% title('Lum Eyemap')


%Equalised Luminance Eyemap
img_eq_lummap= histeq(img_lummap);
% subplot(4,4,10)
% imshow(img_eq_lummap)
% title('Equalised Lum Eyemap');


% Anding, Dilation and Normalisation
img_and =img_lummap .* img_chromeye;

img_eye_dil = imdilate(img_and,img_SE);
%img_eye_dil = img_and;

% subplot(4,4,11)
% imshow(img_eye_dil)
% title('Final Map Using Both Unequalised and then dilating');

img_template = histeq(img_eye_dil);
% subplot(4,4,12)
imshow(img_template)
title('Equalised Final Map');
end