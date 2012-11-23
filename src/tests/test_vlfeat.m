%% Try corner detection

%imgbw = im2single(rgb2gray(ref_img));
%frames = vl_covdet(imgbw, 'verbose','method', 'DoG');
%figure; imshow(ref_img); hold on; vl_plotframe(ref_frames); hold off;
%figure; imshow(faces{14}); hold on; v1_plotframe(frames{14}); hold off;

%newimg = ref_img;
%for i=1:size(frames,2);
%    newimg = plotPoints(newimg,frames(1:3,i)');
%end
%imshow(newimg);


% Read the reference image, only do this for task 1 (all levels)
% Change filename for level 2 and 3
ref_img = imread([datadir 'ref-task1level1.bmp']);

% We have 150 frames for task 1 level 1,
% change the number accordingly for other tasks and levels
mov_input = mmreader([datadir 't1l1.avi']);
img = read(mov_input,1);

%hardcoded faces coordinates
ylow    = [50  50  50  50  ...
           115 115 115 115 ...
           192 192 192 192 ...
           296 296 296 296];

yhigh   = [130 130 130 130 ...
           191 191 191 191 ...
           290 290 290 290 ...
           400 400 400 400];

xlow    = [194 270 362 463 ...
           159 269 372 479 ...
           132 257 374 496 ...
           97  235 389 530];

xhigh   = [257 350 445 539 ...
           241 350 454 561 ...
           220 347 463 596 ...
           197 337 491 633];

numfaces = numel(ylow);
faces = cell(numfaces,1);
for i=1:numfaces
    faces{i} = img(ylow(i):yhigh(i),xlow(i):xhigh(i),:);
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


figure; imshow(plotPoints(img,[xclick yclick]));

    
% Scoring: correct click on frame 1 is worth 1 point, each frame
% thereafter is discounted by 0.99. Score is averaged over multiple
% clicks if applicable. For example, if a task requires two clicks, you
% return 1st click at frame 5, and 2nd click at frame 20 (both of them 
% are correct), your score is (0.99^4 + 0.99^19)/2 = 0.8934. In this
% case, you can NOT access any frame after frame 20. YOU CAN NOT EVEN
% READ THEM INTO MEMORY, WE WILL BE ABLE TO CHECK THIS.

% In other words, you can make use of the information from all
% frames prior to your final click, but NOT thereafter.
    