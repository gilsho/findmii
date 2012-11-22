function [diff scales] = dogfilter(img,levels,sigbase,sigstep)
%dogfilter computes the difference of guassian filter on the image.
% returns for every point the biggest difference, along with the scale
% that achieved it
%       img is the image to be filtered
%       levels is the number of guassians to implement
%       sigbase is the initial sigma to inspect
%       sigfactor is the amount to multiply by

[rows,cols,dummy] = size(img);
diff = zeros(rows,cols);
scales = zeros(rows,cols);

epsilon = 0.001;
order=100;
imgbw = rgb2gray(img); 
sigma=sigbase;
for i = 1:levels
    fimg = filter_laplacian(double(imgbw),order,sigma); 
    updated_diff = bsxfun(@max,abs(fimg),diff);
    scales(abs(updated_diff-diff)>epsilon) = sigma;
    diff = updated_diff;
    sigma = sigma + sigstep;
end