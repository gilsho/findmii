%%-----------------------------------------------------------------------%%
%                                                                         
% CS231A Project: Find Mii
%                              
% This function do the job for task 1, level 1
% PLEASE READ ALL COMMENTS CAREFULLY
%
% Huayan Wang huayanw@cs.stanford.edu
%
%%-----------------------------------------------------------------------%%

%function click = FindMiiTask1Level3(datadir)
datadir = 'data/';

% Read the reference image, only do this for task 1 (all levels)
% Change filename for level 2 and 3
ratio = 0.6;
ref_img = imread([datadir 'ref-task1level3.bmp']);
ref_img = imresize(ref_img,ratio);

% We have 150 frames for task 1 level 1,
% change the number accordingly for other tasks and levels
mov_input = mmreader([datadir 't1l3.avi']);
lastframe = 120;
img = read(mov_input,lastframe);

imgbw = im2single(rgb2gray(img));
ref_imgbw = im2single(rgb2gray(ref_img));

[ref_m,ref_n,~] = size(ref_img);

%hardcoded faces coordinates

% Detect the SIFT features:
fprintf(1,'Computing the SIFT features for face in reference image...\n');

[ref_frames, ref_descriptors] = vl_covdet(ref_imgbw,'method', 'DoG',...
    'EstimateOrientation',true,'PeakThreshold',0.002);
subplot(2,1,1); imshow(ref_img); hold on; vl_plotframe(ref_frames); hold off;
%ref_descriptors = enhancedSIFT(ref_img,ref_frames);


fprintf(1,'Computing the SIFT features for entire frame...\n');
[frames, descriptors] = vl_covdet(imgbw,'method', 'DoG',...
    'EstimateOrientation',true,'PeakThreshold',0.002);
%descriptors = enhancedSIFT(img,frames);

subplot(2,1,2); imshow(img); hold on; vl_plotframe(frames); hold off;


fprintf(1,'Matching keypoints...');
threshold = 0.9;
matches = matchKeypoints(ref_descriptors, descriptors, threshold);

%PLOT MATCHES
if (numel(matches) > 1)
    figure;
    plotmatches(im2double(ref_img),im2double(img),ref_frames,frames,matches);
else
    fprintf('No matches found!');
end
fprintf('\n');

fprintf(1,'Extracting click regions...\n');
threshold = 0.2;
[yclick xclick] = getClickFromMatches(img,ref_frames,frames,matches,threshold);

%sort results                                            
fprintf(1,'Suggested Click: frame:[%d], x:[%d], y:[%d]\n',1,xclick,yclick);

click = [lastframe xclick, yclick];

%figure; imshow(plotPoints(img,[xclick yclick]));
    
%end

