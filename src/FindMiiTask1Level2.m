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

%function click = FindMiiTask1Level2(datadir)
datadir = 'data/';


% Read the reference image, only do this for task 1 (all levels)
% Change filename for level 2 and 3
ref_img = imread([datadir 'ref-task1level2.bmp']);

% We have 150 frames for task 1 level 1,
% change the number accordingly for other tasks and levels
mov_input = mmreader([datadir 't1l2.avi']);
lastframe = 120;
img = read(mov_input,lastframe);

imgbw = im2single(rgb2gray(img));
ref_imgbw = im2single(rgb2gray(ref_img));

[ref_m,ref_n,~] = size(ref_img);

%hardcoded faces coordinates

% Detect the SIFT features:
fprintf(1,'Computing the SIFT features for face in reference image...\n');

[ref_frames, ref_descriptors] = vl_covdet(ref_imgbw,'method', 'DoG');
ref_descriptors = enhancedSIFT(ref_img,ref_frames);
%subplot(2,2,1); imshow(ref_img); subplot(2,2,2); vl_plotframe(ref_frame);

fprintf(1,'Computing the SIFT features for entire frame...\n');
[frames, descriptors] = vl_covdet(imgbw,'method', 'DoG');
descriptors = enhancedSIFT(img,frames);
%subplot(2,2,3); imshow(img); subplot(2,2,4); vl_plotframe(frame);


fprintf(1,'Matching keypoints...');
ref_box = [40 40 120 120];
minpts = 2;
threshold = 0.8;
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

