close all;
clear all;
clc;

EyeDetect = vision.CascadeObjectDetector('RightEyeCART','MaxSize',[50,50],'MergeThreshold',8);

froot = 'E:\IP Project\New IP Project\dataset_images';
list = dir(sprintf('%s\\*.jpg', froot));

for index = 1:length(list)
    close all;
    % load image
    fn = sprintf('%s\\%s', froot, list(index).name);
    
    img = imread(fn);

    BB=step(EyeDetect,img);
    
    subplot(3,3,1);
    imshow(img);
    title('Eyes Detection');
    
    Eyes=imcrop(img,BB(1,:));
    subplot(3,3,2);
    imshow(Eyes);
    
    Eyes=rgb2gray(Eyes);
    Eyes_edge=edge(Eyes,'canny');
    subplot(3,3,3);
    imshow(Eyes_edge);

    SE=strel('Line',4,0);
    Eyes_edge= imdilate(Eyes_edge,SE);
    subplot(3,3,4);
    imshow(Eyes_edge);
    
    Eyes_edge=bwareaopen(Eyes_edge,100);
    subplot(3,3,5);
    imshow(Eyes_edge);
    pause;
end;