%load image 
imgOG = imread("girlpearl.jpg");

%displays original image
fprintf("Original Image:\n")
imageViewer(imgOG)

%get image size, calculate aspect ratio
sizeOG = size(imgOG);
[n,d]=rat(sizeOG(2)/sizeOG(1),.05);
fprintf("Aspect Ratio For Original Image is %d:%d.(x,y)\n", n,d)

%resample image at a smaller size, posterize using rgb2ind
imgSmall = imresize(imgOG, [sizeOG(1), sizeOG(2)], "nearest");

[X, map] = rgb2ind(imgSmall, 0.8,"nodither");

%[imgFinal, mapf] = imresize(X, map,(1/0.02), "nearest");
%fprintf("Pattern:")

imageViewer(X,Colormap=map)

%display color key
imgColorKey  = 1:length(map);
[ICK, mapck] = imresize(imgColorKey, map,80,"nearest");
imshow(ICK, map)

