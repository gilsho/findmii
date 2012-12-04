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

MAX_FRAME = 150;

xclick = -1;
yclick = -1;

% Read the reference image, only do this for task 1 (all levels)
% Change filename for level 2 and 3
ref_img = imread([datadir 'ref-task1level1.bmp']);

% We have 150 frames for task 1 level 1,
% change the number accordingly for other tasks and levels
mov_input = mmreader([datadir 't1l1.avi']);


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

lastframe = 0;
confidence = -Inf;
CONFIDENCE_THRESHOLD = 1.5;

while ((confidence < CONFIDENCE_THRESHOLD) && (lastframe < MAX_FRAME))
    lastframe = lastframe + 1;
    fprintf('Examining frame %d/%d...\n',lastframe,MAX_FRAME);
    img = read(mov_input,lastframe);
    
    %EXTRACT FACES
    faces = cell(numfaces,1);
    for i=1:numfaces
        faces{i} = img(bbox(i,1):bbox(i,2),bbox(i,3):bbox(i,4),:);
    end

    %DETECT SIFT FEATURES
    fprintf(1,'Computing the SIFT features for face in reference image...\n');
    imgbw = im2single(rgb2gray(ref_img));
    [ref_frames, ref_descriptors] = vl_covdet(imgbw,'method', 'DoG');
    %ref_descriptors = enhancedSIFT(ref_img,ref_frames);

    fprintf(1,'Computing the SIFT features for faces in video');
    frames = cell(numfaces,1);
    keypoints = cell(numfaces,1);
    descriptors = cell(numfaces,1);
    for i=1:numfaces
        fprintf(1,'.');
        imgbw = im2single(rgb2gray(faces{i}));
        [frames{i}, descriptors{i}] = vl_covdet(imgbw,'method', 'DoG');
        %descriptors{i} = enhancedSIFT(faces{i},frames{i});
    end
    fprintf('\n');

    
    %MATCH KEYPOINTS
    fprintf(1,'Matching keypoints...\n');
    threshold = 0.8;
    score = zeros(numfaces,1);
    for i=1:numfaces
        matches = matchKeypoints(ref_descriptors,descriptors{i},threshold);
        score(i) = numel(matches);
    end

    %PLOT MATCHES
    %figure;
    %plotmatches(im2double(ref_img),im2double(img),ref_frames,frames{2},matches);
    
    
    %CALCULATE CONFIDENCE LEVEL
    [score_sorted,sorted_index] = sort(score,'Descend');    
    confidence = score_sorted(1)/score_sorted(2);
end

index = sorted_index(1);
xclick = bbox(index,3) + (bbox(index,4)-bbox(index,3))/2;
yclick = bbox(index,1) + (bbox(index,2)-bbox(index,1))/3;

click = [lastframe xclick, yclick];

%PLOT RESULTS
fprintf(1,'Suggested Click: frame:[%d], x:[%d], y:[%d]\n',lastframe,xclick,yclick);
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

