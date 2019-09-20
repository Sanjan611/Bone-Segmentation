% STEP 1: Read in the color image and convert it to grayscale
I = imread('pears.png');
I = rgb2gray(I);
imshow(I)

% STEP 2: Use the gradient magnitude as the segmentation function
gmag = imgradient(I);
imshow(gmag, [])
title('Gradient Magnitude')

L = watershed(gmag);
Lrgb = label2rgb(L);
imshow(Lrgb);
title('Watershed transform of gradient magnitude');

% STEP 3: Mark the foreground objects
se = strel('disk', 20);
Io = imopen(I, se);
imshow(Io)
title('Opening');

Ie = imerode(I,se);
Iobr = imreconstruct(Ie,I);
imshow(Iobr)
title('Opening-by-Reconstruction')