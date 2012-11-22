addpath('src/sift-class');
addpath('src/sift-class/KeypointDetect');
addpath('src/sift-class/KeypointMatch');
clear;

img = imread('frame/t1l1/1.jpg');

ref_img = imread('frame/ref-task1level1.bmp');

%PLOT IMAGE
%figure(1);
%subplot(1,2,1);
%image(img);
%colormap(gray(256));
%drawnow;

% Detect the SIFT features:
fprintf(1,'Computing the SIFT features...\n');
[features,pyr,imp,keys] = detect_features(img);
[ref_features,~,~,ref_keys] = detect_features(ref_img);

% The features matrix has one keypoint per row. Each column is the
% following:
% Column 1: and 2: x and y position (sub pixel adjusted)
% Column 3: scale value (sub scale adjusted in units of pyramid level)
% Column 4: size of feature on original image        
% Column 5: edge flag
% Column 6: orientation angle
% Column 7: save curvature of response through scale space

% Although useful for plotting the keypoints, you will not be concerned with
% all seven parameters per keypoint. Namely, you just want the x,y, scale
% and theta parameters
% Note that this showfeatures script will draw a red line instead of a box
% for all points that it considers edges.

%PLOT FEATURES
%subplot(1,2,2);
%showfeatures(features,img);
%title('SIFT features');
%drawnow;

% You will implement this in Part B.
% note that you can ignore the last four parameters of the keypoints as
% simply parameters for the showfeatures function.
keypoints = features(:,[1:3 6]);
ref_keypoints = ref_features(:,[1:3 6]);

descriptors  = mySIFTdescriptor(img,keypoints);
ref_descriptors = mySIFTdescriptor(ref_img,ref_keypoints);

%PLOT DESCRIPTORS
%for clarity in the plotting, let's just choose the n "biggest" descriptors
%(judged by the 2-norm of the vector)
%n = 50; % Number of descriptors to plot. Feel free to play with this number.
%figure;
%imagesc(img);
%hold on;
%plotsiftdescriptor(descriptors(1:n,:)', features(1:n,1:3)');
%title('Overlaid descriptors');
%hold off;

threshold = 1;
matches = matchKeypoints(ref_descriptors',descriptors',threshold);

figure;
plotmatches(im2double(ref_img),im2double(img),ref_keypoints',keypoints',...
            matches);

ref_box = [50 40 120 120];
minpts = 2;
%matchObject(ref_img, ref_descriptors', ref_keypoints', ref_box, ...
%          img, descriptors', keypoints',threshold)

[cx cy w h orient count] = getObjectRegion(ref_keypoints',keypoints',... 
                                                 matches, ref_box, minpts);

                                             
if (numel(count) == 0)
   %no points 
end

if (numel(count) > 1)
   %need to sort results 
end
                                             
[~, index] = max(count);

[xclick yclick] = getClickFromBox(cx(index),cy(index),w(index),h(index),...
                        orient(index));

click  = [1 xclick yclick];








    
