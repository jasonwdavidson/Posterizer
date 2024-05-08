% This MATLAB script creates a pixelated,indexed, reduced color image
% which can be used as a cross-stitch pattern. It also gives a color key.
% (see matlab documentation for imresize and rgb2ind).
%
% Author: Jason Davidson
% Contact: jasonwdavidson@gmail.com
% GitHub: https://github.com/jasonwdavidson
% 
% License: GNU General Public License v3.0
% Published May 5 2022
%
% INPUT VARIABLES:
%     imgFileName (string): image path from current dir
%     useDither (string): either "dither" or "nodither"
%     smplAlg (string): algortihm to use for image sampling
%       "nearest" "bicubic" or "bilinear"
%     quantColors (integer or float): Positive integer to specify number of colors 
%       for minimum variance quantization, or decimal between 0 and 1 for 
%       uniform quantization. (see rgb2ind documentation)
%     numCol (integer): number of columns in final pattern
%     outFile (string): output file name (format determined by extension)


%Edit Input Variables Here:
imgFileName = "girlpearl.jpg";
useDither = "nodither";
smplAlg = "bicubic";
quantColors = 12;
numCol = 120;
outFile = "girl_pearl_earring.png";



%load image 
imgOG = imread(imgFileName);

%displays original image
fprintf("Original Image:\n")
imageViewer(imgOG)

%get image size, calculate aspect ratio
sizeOG = size(imgOG);
[n,d]=rat(sizeOG(2)/sizeOG(1),.05);
fprintf("Aspect Ratio For Original Image is %d:%d.(x,y)\n", n,d)

%resample image at a smaller size, posterize using rgb2ind
numRow = numCol*(n/d);
imgSmall = imresize(imgOG, [numCol, numRow], smplAlg);
[X, map] = rgb2ind(imgSmall,quantColors,useDither);

%Scale up image, creates pattern
[imgFinal, mapf] = imresize(X, map,(1/0.02), "nearest");
fprintf("Pattern:")

imageViewer(imgFinal,Colormap=mapf)

%display color key
imgColorKey  = 1:length(map);
[ICK, mapck] = imresize(imgColorKey, map,80,"nearest");
imshow(ICK, map)

imwrite(imgFinal, mapf,outFile)
imwrite(ICK,mapck,"colorkey" + outFile)

