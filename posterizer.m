% This MATLAB script creates a posterized version of an input image using
% an image segmentation algortihm to generate an appropriate colormap.
%
% This is preferrable to standard posterization tools which are "blind"
% and do not take the image composition into account when choosing colors.
% Color choice matches the color palette of the original image and gives a 
% more balanced and artistic look.
% (see matlab documentation for imsegkmeans and rgb2ind).
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
%     quantColors (integer): specify number of colors 
%     outFile (string): output file name (format determined by extension)

% Edit Input Variables Here:
imgFileName = "girlpearl.jpg";
useDither = "nodither";
quantColors = 6;
outFile = "girl_pearl_posterized.png";

% Read Image file and display info
imgOG = imread(imgFileName);
imshow(imgOG)
title("Original Image")
sizeOG = size(imgOG);
[n,d]=rat(sizeOG(2)/sizeOG(1),.05);
fprintf("Aspect Ratio For Original Image is %d:%d.\n", n,d)

% Use k-means segmentation to divide image into clusters based on value
[L, C] = imsegkmeans(imgOG,quantColors);
%B = labeloverlay(imgOG,L);

% create matrices for each rgb channel and for lookup matrices
pixels = [];
channelr = imgOG(:,:,1);
channelg = imgOG(:,:,2);
channelb = imgOG(:,:,3);
clust_map = zeros(quantColors,3);

% for each cluster, get positions and values of each pixel in cluster, compute mean color for cluster
for i = 1:quantColors
    logindex = (L == i);
    pixels = cat(3,pixels,logindex);
    filtered = [channelr(logindex) channelg(logindex) channelb(logindex)];
    avg = [mean(filtered(:,1)) mean(filtered(:,2)) mean(filtered(:,3))];
    clust_map(i,:) = avg/255;
end

% create color key image and display posterized result
imgColorKey  = 1:length(clust_map);
[ICK, mapck] = imresize(imgColorKey, clust_map, 80,"nearest"); 
imshow(ICK,clust_map)
title("Color Key")
[imind,mapind] = rgb2ind(imgOG,clust_map,useDither);
imshow(imind, mapind)
title("Posterized Image")

% write posterized image and colorkey to files
imwrite(imind,mapind,outFile);
imwrite(ICK,clust_map,"colorkey_"+outFile);
