function optflow = computeOpticalFlow(img,neighbors)
%COMPUTEOPTICALFLOW computes the optical flow for a every pixel in an image 
%img is the input image
%neighbors is the number of neighbors to use for least squares
%returns a matrix that is [rows x cols x 2], representing the magnitude
%and direction of the image.
%value represents the velocity in the x

if (nargin < 2)
   neighbors = 5;  %default number of neighbors to use
end
if (mod(neighbors,2) == 0)
   neighbors = neighbors-1; %ensure neighbors is even
end

[rows,cols,channels] = size(img);
%calculate gradient

kernel = [-1 0 1
          -2 0 2
          -1 0 1];
Ix = zeros(rows,cols);
Iy = zeros(rows,cols);
for i=1:channels
    Ix = Ix + filter2(kernel,img(:,:,i));
    Iy = Iy + filter2(kernel',img(:,:,i));
end
Ix = Ix./3;
Iy = Iy./3;


optflow = zeros(rows,cols,2);
for i=1:rows
    for j=1:cols
        xlow = i-neighbors/2;
        ylow = i-neighbors/2;
        xhigh = i+neighbors/2;
        yhigh = i+neighbors/2;
        if ((xlow < 1) || (ylow < 1) || (xhigh > cols) || (yhigh > rows))
            continue;
        end
        [u; v] = 
    end
end

