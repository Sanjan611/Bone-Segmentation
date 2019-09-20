clear;
close all;

%% MARKER CONTROLLED WATERSHED ALGORITHM

% STEP 1: Read in the color image and convert it to grayscale
I = imread('bone_lowerleg.jpg');
figure
imshow(I)
title('Original')

% STEP 2: Use the gradient magnitude as the segmentation function
gmag = imgradient(I);
figure
imshow(gmag, [])
title('Gradient Magnitude')

L = watershed(gmag);
Lrgb = label2rgb(L);
figure
imshow(Lrgb);
title('Watershed transform of gradient magnitude');

% STEP 3: Mark the foreground objects
se = strel('disk', 20);
Io = imopen(I, se);
figure
imshow(Io)
title('Opening');

Ie = imerode(I,se);
Iobr = imreconstruct(Ie,I);
figure
imshow(Iobr)
title('Opening-by-Reconstruction')

Ioc = imclose(Io,se);
figure
imshow(Ioc)
title('Opening-Closing')

Iobrd = imdilate(Iobr,se);
Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
figure
imshow(Iobrcbr)
title('Opening-Closing by Reconstruction')

fgm = imregionalmax(Iobrcbr, 4);
figure
imshow(fgm)
title('Regional Maxima of Opening-Closing by Reconstruction')

I2 = labeloverlay(I,fgm);
figure
imshow(I2)
title('Regional Maxima Superimposed on Original Image')

se2 = strel(ones(5,5));
fgm2 = imclose(fgm,se2);
fgm3 = imerode(fgm2,se2);

fgm4 = bwareaopen(fgm3,20);
I3 = labeloverlay(I,fgm4);
figure
imshow(I3)
title('Modified Regional Maxima Superimposed on Original Image')

% STEP 4: Compute Background markers
bw = imbinarize(Iobrcbr);
figure
imshow(bw)
title('Thresholded Opening-Closing by Reconstruction')

D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;
figure
imshow(bgm)
title('Watershed Ridge Lines)')
