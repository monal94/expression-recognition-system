FDetect = vision.CascadeObjectDetector;

prompt = 'Please enter the path of the image   ';
img = imread('E:\IP Project\New IP Project\dataset_images\download.jpg');

BB = step(FDetect,img);

img = imcrop(img,BB);
img = imresize(img,[144, 96]);
img = imcrop(img, [0 0 96 100]);
img = imcrop(img, [12 48 30 22]);

img_ycbcr = rgb2ycbcr(img);
img_ycbcr = im2double(img_ycbcr);

img_ycbcr_lowface = img_ycbcr;
img_ycbcr_upperface = img_ycbcr;

img_y = img_ycbcr_upperface(:,:,1);
img_cb = img_ycbcr_upperface(:,:,2);
img_cr = img_ycbcr_upperface(:,:,3);


img_cb2 = img_cb.^2;

img_ccr2 = (1-img_cr).^2;

img_cbcr = img_cb./img_cr;

img_gray = rgb2gray(img);
img_gray = im2double(img_gray);

img_gray_lowface = img_gray;
img_gray_upperface = img_gray;

img_chromeye = 1/3*(img_cb2+img_ccr2+img_cbcr);

img_eq_chromeye = histeq(img_chromeye);

img_SE = strel('disk',4,0);
img_lum_dil = imdilate(img_gray_upperface,img_SE);
img_lum_erode = 1 + imerode(img_gray_upperface,img_SE);
img_lummap = img_lum_dil./img_lum_erode;

img_eq_lummap= histeq(img_lummap);
img_and =img_lummap .* img_chromeye;

img_eye_dil = imdilate(img_and,img_SE);



img_template = histeq(img_eye_dil);
imshow(img_template)
title('Equalised Final Map');
