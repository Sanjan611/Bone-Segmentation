close all;
clear;

% Read the image
I_orig = imread('bone_lowerleg.jpg');
if(length(size(I_orig))==3)
    I_orig = rgb2gray(I);
end
figure, imshow(I_orig), title('Original')

%figure
%imhist(I)

%figure
%imhist(adapthisteq(I))
I = I_orig;
%I = imsharpen(I,'Radius',2,'Amount',1);
%I = adapthisteq(I);
%I = imgaussfilt(I,2);




% Calculate the global threshold
%T = graythresh(I);
T = 0.43;

BW = imbinarize(I,T);
figure, imshow(BW), title('Binarized with threshold')

% to cover up the patches within the bone
BW = bwmorph(BW, 'dilate', 8);
BW = bwmorph(BW, 'erode',8);
figure, imshow(BW), title('dilate erode')

BW = bwareaopen(BW, 1000);
figure, imshow(BW), title('bwareaopen-1')
BW = imcomplement(BW);
BW = bwareaopen(BW, 1000);
figure, imshow(BW), title('bwareaopen-2')
BW = imcomplement(BW);

%BW = imfill(BW, 'holes'); % Doesn't work cause it fills in the gap between
%tibia and fibia

Icopy = I_orig; % Make a copy so you don't destroy the original.
Icopy(~BW) = 0;
figure, imshow(Icopy), title('Masked')

BWedge = edge(BW, 'canny');
BWedge = bwmorph(BWedge, 'dilate', 2);
figure, imshow(imcomplement(BWedge)), title('Canny edge + dilate');


