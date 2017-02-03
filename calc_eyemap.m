function [img_eye_dil] = calc_eyemap(img)

%Converting Original Image to YCbCr Base
img_ycbcr = rgb2ycbcr(img);
img_ycbcr = im2double(img_ycbcr);

img_y = img_ycbcr(:,:,1);
img_cb = img_ycbcr(:,:,2);
img_cr = img_ycbcr(:,:,3);

%Plotting cb^2
img_cb2 = img_cb.^2;

%Plotting ccr^2
img_ccr2 = (1-img_cr).^2;

%Plotting Cb/Cr
img_cbcr = img_cb./img_cr;

%Plotting Image in Gray-Space
img_gray = rgb2gray(img);
img_gray = im2double(img_gray);

%Chrom Eyemap
img_chromeye = 1/3*(img_cb2+img_ccr2+img_cbcr);

%Equalised Chrom Eyemap
img_eq_chromeye = histeq(img_chromeye);

%Luminance Eyemap
img_SE = strel('disk',4,0);
img_lum_dil = imdilate(img_gray,img_SE);
img_lum_erode = 1 + imerode(img_gray,img_SE);
img_lummap = img_lum_dil./img_lum_erode;

%Equalised Luminance Eyemap
img_eq_lummap= histeq(img_lummap);

% Anding, Dilation and Normalisation
img_and =img_lummap .* img_chromeye;

img_eye_dil = imdilate(img_and,img_SE);
end