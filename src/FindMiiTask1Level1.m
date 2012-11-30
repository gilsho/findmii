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

% You should create functions in a simiar format as this one to do the job
% for other tasks and levels. They should all be invoked in FindMiiMain().

% For the tasks or levels you are not doing, just comment the corresponding
% line in FindMiiMain(), and then do nothing. They will not be scored.

% You may call any other programs INSIDE this function, including Matlab
% functions or MEX files or executables compiled from your C++ OpenCV code
% (if you are using OpenCV). Call executables by 'system()'.

% The only requirement is that, you should return 'click' to FindMiiMain().

% NUMBER OF CLICKS REQUIRED !!!
% For task 1 (any level), you should only make 1 click.
% For task 2 (any level), you should make 2 clicks.
% For task 3, level 1, you should make 2 clicks.
% For task 3, level 2, you should make 3 clicks.
% For task 3, level 3, you should only make 1 click.
% For task 4 (any level), you should only make 1 click.

function click = FindMiiTask1Level1(datadir)

% Read the reference image, only do this for task 1 (all levels)
% Change filename for level 2 and 3
ref_img = imread([datadir 'ref-task1level1.bmp']);

% We have 150 frames for task 1 level 1,
% change the number accordingly for other tasks and levels
mov_input = mmreader([datadir 't1l1.avi']);
img = read(mov_input,1);

%hardcoded faces coordinates

bbox = zeros(16,4);
%      ylow yhigh xlow xhigh
bbox = [50    130   194   257
        50    130   270   350
        50    130   362   445
        50    130   463   539
        115   191   159   241
        115   191   269   350
        115   191   372   454
        115   191   479   561
        192   290   132   220
        192   290   257   347
        192   290   374   463
        192   290   496   596
        296   400    97   197
        296   400   235   337
        296   400   389   491
        296   400   530   633];
   
   
numfaces = size(bbox,1);
faces = cell(numfaces,1);
for i=1:numfaces
    faces{i} = img(bbox(i,1):bbox(i,2),bbox(i,3):bbox(i,4),:);
end


% Detect the SIFT features:
fprintf(1,'Computing the SIFT features for face in reference image...\n');
imgbw = im2single(rgb2gray(ref_img));
[ref_frames, ref_descriptors] = vl_covdet(imgbw,'method', 'DoG');



fprintf(1,'Computing the SIFT features for faces in video');
frames = cell(numfaces,1);
keypoints = cell(numfaces,1);
descriptors = cell(numfaces,1);
for i=1:numfaces
    fprintf(1,'.');
    imgbw = im2single(rgb2gray(faces{i}));
    [frames{i}, descriptors{i}] = vl_covdet(imgbw,'method', 'DoG');
end
fprintf('\n');


fprintf(1,'Matching keypoints...\n');
ref_box = [40 40 120 120];
minpts = 2;
threshold = 0.8;
score = zeros(numfaces,1);

for i=1:numfaces
    matches = matchKeypoints(ref_descriptors,descriptors{i},threshold);
    score(i) = numel(matches);
    %ignore bounding box matching for now
    %if (numel(matches) > 0)
    %    [cx,cy,w,h,orient,votes] = getObjectRegion(ref_frames(1:4,:),...
    %                        frames{i}(1:4,:),matches, ref_box, minpts);
    %    if (numel(votes) > 0)
    %        score(i) = max(votes);
    %    end
    %end
end

%PLOT MATCHES
%figure;
%plotmatches(im2double(ref_img),im2double(img),ref_keypoints,keypoints,matches);
%matchObject(ref_img, ref_descriptors, ref_keypoints, ref_box,img, descriptors, keypoints,threshold)


%look at bounding box. might not be necessary
%ref_box = [40 40 120 120];
%minpts = 2;
%fprintf(1,'Extracting potential object regions...\n');
%[cx cy w h orient count] = getObjectRegion(ref_keypoints,keypoints,... 
%                                                 matches, ref_box, minpts);
%if (numel(count) == 0)
%   %no points 
%end
%if (numel(count) > 1)
%   %need to sort results 
%end
                                            
%[~, index] = max(count);
%[xclick yclick] = getClickFromBox(cx(index),cy(index),w(index),...
%                                  h(index),orient(index));

[~,index] = max(score);
xclick = xlow(index) + (xhigh(index)-xlow(index))/2;
yclick = ylow(index) + (yhigh(index)-ylow(index))/3;


fprintf(1,'Suggested Click: frame:[%d], x:[%d], y:[%d]\n',1,xclick,yclick);

click = [frame xclick, yclick];

%figure; imshow(plotPoints(img,[xclick yclick]));


    
% Scoring: correct click on frame 1 is worth 1 point, each frame
% thereafter is discounted by 0.99. Score is averaged over multiple
% clicks if applicable. For example, if a task requires two clicks, you
% return 1st click at frame 5, and 2nd click at frame 20 (both of them 
% are correct), your score is (0.99^4 + 0.99^19)/2 = 0.8934. In this
% case, you can NOT access any frame after frame 20. YOU CAN NOT EVEN
% READ THEM INTO MEMORY, WE WILL BE ABLE TO CHECK THIS.

% In other words, you can make use of the information from all
% frames prior to your final click, but NOT thereafter.
    
end

