clear all
clc
close all
%Detect objects using Viola-Jones Algorithm

%To detect Face
FDetect = vision.CascadeObjectDetector;

%Read the input image
prompt = 'Please enter the path of the image   ';
str = input(prompt,'s');
I = imread(str);

%Returns Bounding Box values based on number of objects
BB = step(FDetect,I);

figure,
imshow(I); hold on
for i = 1:size(BB,1)
    rect(i) = rectangle('Position',BB(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
end
imcrop(I,BB);
title('Face Detection');
hold off;
