
%function [face_centers,face_dim] = slidingWindowDetector(img)
img = imread('frame/t1l2/31.jpg');
imgref = imread('frame/ref-task1level2.bmp');
imgstep = imread('t1l2-step.jpg');

imgref = imgref(20:90,20:90,:);
[m,n,channels] = size(img);
[mref,nref,~] = size(imgref);

%subract out mean
%for ch=1:channels
%   img(:,:,ch) = double(img(:,:,ch) - mean(mean(img(:,:,ch))));
%   imgref(:,:,ch) = double(imgref(:,:,ch) - mean(mean(imgref(:,:,ch))));
%end

%imgbw = double(rgb2gray(img));
%imgrefbw = double(rgb2gray(imgref));

%for ch=1:channels
%   val = xcorr2(double(imgref(:,:,ch)),double(img(:,:,ch)));
%   if (~exist('cr'))
%       cr = val;
%   else
%       cr = cr + val;
%   end
%end
%cr = cr./3;

%subplot(2,1,1); imagesc(cr); subplot(2,1,2); imshow(img);

%cr = xcorr2(imgrefbw,imgbw);
%cr = cr./(mref*nref);
%thresh = 10000;
%cr_thresh = cr.*(cr>thresh);
%imagesc(cr_thresh);

%integral = cumsum(single(imgbw),1);
%integral = cumsum(integral,2);
%imagesc(integral);

margin = ones(1,3);
eye = -1*ones(1,13);
gap = ones(1,6);
kernel = repmat([margin eye gap eye margin],7,1);
cr = xcorr2(imgbw,kernel);
cr = cr - mean2(mean2(cr));

threshold = 0.4;
cr_thresh = cr.*(cr > threshold);
subplot(2,1,1); imagesc(cr_thresh); subplot(2,1,2); imshow(img);


%end

