% List all JPGs in current folder
close all;
clear all;
clc;


%To detect Eyes
EyeDetect = vision.CascadeObjectDetector('RightEyeCART','MaxSize',[50,50],'MergeThreshold',16);

%Find current directory contents
froot = 'G:\Projects\IP Project\Emotion Recognition Using Fuzzy Based Systems\Dataset'
list = dir(sprintf('%s\\*.jpg', froot));


% Process each image
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
    
    SE=strel('line',1,90);
    Eyes_edge= imopen(Eyes_edge,SE);
    subplot(3,3,4);
    imshow(Eyes_edge);
    
    Eyes_edge=bwareaopen(Eyes_edge,24);
    subplot(3,3,5);
    imshow(Eyes_edge);
    
    SE=strel('line',1,90);
    Eyes_edge= imdilate(Eyes_edge,SE);
    subplot(3,3,6);
    imshow(Eyes_edge);
    
    
    pause;
end;