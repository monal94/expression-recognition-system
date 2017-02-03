clear all
clc
close all

MouthDetect = vision.CascadeObjectDetector('Mouth');
prompt = 'Please enter the path of the image';
str = input(prompt,'s');
I = imread(str);
BB=step(MouthDetect,I);
BB=[BB(2,1) BB(2,2), BB(1,1)+BB(1,3)-BB(2,1), BB(1,2)+BB(1,4)-BB(2,2)];
%BB=[124 213 139 113]
Imouthrgb=imcrop(I,BB);
figure,
imshow(Imouthrgb)
title ('Imouthrgb')
Imouthrgb=im2double(Imouthrgb);
Imouthycbcr=rgb2ycbcr(Imouthrgb);
Y=(Imouthycbcr(:,:,1));
Cb=(Imouthycbcr(:,:,2));
Cr=(Imouthycbcr(:,:,3));
Crsq=Cr.*Cr;
Crcb=Cr./Cb;
sumCrsq=sum(sum(Crsq));
sumCrcb=sum(sum(Crcb));
n=0.95*(sumCrsq/sumCrcb);
inmouthmap=Crsq-n*Crcb;
mouthmap=Crsq.*inmouthmap.*inmouthmap;
figure,
imagesc(mouthmap)
colormap(gray)
title('mouthmap')
[mouthedge,t]=edge(mouthmap,'sobel');
figure,
imagesc(mouthedge)
colormap(gray)
title('mouthedge')
horse=strel('line',8,0);
dmouthedge=imdilate(mouthedge, horse);
imagesc(dmouthedge)
colormap(gray)
title('dmouthedge')
[row1,x1]=find(dmouthedge,1,'first');
[row2,x2]=find(dmouthedge,1,'last');
[col1,y1]=find((dmouthedge)',1,'first');
[col2,y2]=find((dmouthedge)',1,'last');
mouthwindow=imcrop(mouthmap,[x1 y1 x2-x1 y2-y1]);
figure,
imagesc(mouthwindow)
colormap(gray)
title('mouthwindow')
threshold= mean2(mouthwindow)+(1.6)*sqrt((mean2(mouthwindow.*mouthwindow))-(mean2(mouthwindow))*(mean2(mouthwindow)));
threshlips=im2bw(mouthwindow,threshold);
figure,
imagesc(threshlips)
colormap(gray)
title('threshlips')
rowsumarray=sum(threshlips,2);
[row_threshlips, col_threshlips]=size(threshlips);
x_peak=linspace(1,row_threshlips,row_threshlips);
figure,
plot(x_peak,(rowsumarray)')
title('peak graph')
[peakLoc,peakMag] = peakfinder(rowsumarray);
peakLoc_size = size(peakLoc);
if (peakLoc_size(1)==1)
    mouthopening1 = 0;
    row_centreline=peakLoc(1);
end
if(peakLoc_size(1)==2)
    row_ulip1=peakLoc(1);
    row_dlip1=peakLoc(2);
    mouthopening1 = abs(row_ulip1-row_dlip1);
end   
if(peakLoc_size(1)==3)
     row_ulip1=peakLoc(1);
    row_dlip1=peakLoc(3);
    mouthopening1 = abs(row_ulip1-row_dlip1);
end
mouthopening2=0;
[start_row, start_col]=find(threshlips,1,'first');
[end_row, end_col]=find(threshlips,1,'last');
for i=start_col:1:end_col
    for j=1:1:size(threshlips,1)
    if (threshlips(j,i) == 1)&&(threshlips(j+1,i)== 0)
        row_ulip2=j+1;
        col_ulip2= i;
        break
    else
        row_ulip2=0;
        col_ulip2= 0;
    end
    end
    for j=size(threshlips,1)-1:-1:1
        if (row_ulip2~=0)&&(col_ulip2~=0)
            if (threshlips(j+1,i) == 1)&&(threshlips(j,i)== 0)
                row_dlip2 = j; 
                col_dlip2= i;
                break
            else
                row_dlip2 = 0;
                col_dlip2 = 0;
            end
        else
            row_dlip2 = 0;
            col_dlip2 = 0;
        end
    end
        value= abs(row_dlip2 - row_ulip2);
        if (value>mouthopening2)
            mouthopening2=value;
        end
end 
if(mouthopening1>mouthopening2)
    mouthopening=mouthopening1;
else
    mouthopening=mouthopening2;
end
mouthopening
%mouth corner displacement calculation
sperclse=strel('disk',12 , 6);
dmouthcorner=imdilate(dmouthedge,sperclse);
figure,
imagesc(dmouthcorner)
colormap(gray)
title('dmouthcorner')
Imouthhsv=rgb2hsv(Imouthrgb);
mouthlum = Imouthhsv(:,:,3);
mouthcornermap=(255-mouthlum).^6;
figure,
imagesc(mouthcornermap)
colormap(gray)
title('mouthcornermap')
gmax_mouthcornermap=max(max(mouthcornermap));
for i=1:1:size(mouthcornermap,2)
    if max(mouthcornermap(:,i))>((1/3)*(gmax_mouthcornermap))
            row_leftmouthcorner=j;
            col_leftmouthcorner=i;
            break
    end
end
for i=size(mouthcornermap,2):-1:1
    
        if(max(mouthcornermap(:,i)))>((1/3)*(gmax_mouthcornermap))
        row_rightmouthcorner=j;
        col_rightmouthcorner=i;
        break
        end
end
if (mouthopening1~=0)
    row_centreline=row_ulip1+(row_dlip1-row_ulip1)/2;
end
if (mouthopening1==0)&&(mouthopening2~=0)
    row_centreline=row_ulip2+(row_dlip2-row_ulip2)/2;
end  
%hold on
%plot([1 size(mouthcornermap,2)],[row_centreline row_centreline])
%plot(col_leftmouthcorner,row_leftmouthcorner,'r.','MarkerSize',20)
%plot(col_rightmouthcorner,row_rightmouthcorner,'r.','MarkerSize',20)
mouthcornerdisplacement=row_centreline-row_leftmouthcorner
