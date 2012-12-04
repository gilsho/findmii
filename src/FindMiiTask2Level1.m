

function clicks = FindMiiTask2Level1(datadir)

MAX_FRAME = 150;

% change the number accordingly for other tasks and levels
mov_input = mmreader([datadir 't2l1.avi']);

%hardcoded faces coordinates
%       ylow yhigh  xlow xhigh
bbox = [80    180   231   311
        80    180   405   495
        198   297   197   293
        198   297   417   518];

numfaces = size(bbox,1);

lastframe=0;
CONFIDENCE_THRESHOLD = 1.4;    
confidence = 0;
while ((confidence < CONFIDENCE_THRESHOLD) && (lastframe < MAX_FRAME))
    lastframe = lastframe + 1;
    fprintf('Examining frame %d/%d...\n',lastframe,MAX_FRAME);
    img = read(mov_input,lastframe);
    
    faces = cell(numfaces,1);
    for i=1:numfaces
        faces{i} = img(bbox(i,1):bbox(i,2),bbox(i,3):bbox(i,4),:);
    end

    %DETECT SIFT FEATURES
    fprintf(1,'Computing the SIFT features for faces in video');
    frames = cell(numfaces,1);
    descriptors = cell(numfaces,1);
    for i=1:numfaces
        fprintf(1,'.');
        imgbw = im2single(rgb2gray(faces{i}));
        [frames{i}, descriptors{i}] = vl_covdet(imgbw,'method', 'DoG');
    end
    fprintf('\n');
    
    %MATCH KEYPOINTS
    fprintf(1,'Matching keypoints...\n');
    threshold = 0.8;
    score = zeros(numfaces);
    for i=1:numfaces
        for j=1:numfaces
            if (i == j)
                score(i,j) = 0;
            else
                matches = matchKeypoints(descriptors{i},descriptors{j},threshold);
                score(i,j) = numel(matches);
            end
        end
    end

    %DETERMINE MATCH
    [maxvalscol maxindexcol] = max(score);
    [maxval, maxindexrow] = max(maxvalscol);

    index1 = maxindexrow;
    index2 = maxindexcol(maxindexrow);
    
    score_remaining = score;
    score_remaining(index1,index2) = 0;
    score_remaining(index2,index1) = 0;
    
    max_remaining = max(max(score_remaining));
    
    confidence = maxval./max_remaining;

end

xclick1 = bbox(index1,3) + (bbox(index1,4)-bbox(index1,3))/2;
yclick1 = bbox(index1,1) + (bbox(index1,2)-bbox(index1,1))/3;

xclick2 = bbox(index2,3) + (bbox(index2,4)-bbox(index2,3))/2;
yclick2 = bbox(index2,1) + (bbox(index2,2)-bbox(index2,1))/3;

clicks = zeros(2,3);
clicks(1,:) = [lastframe xclick1, yclick1];
clicks(2,:) = [lastframe xclick2, yclick2];

%PLOT RESULTS
fprintf(1,'Suggested Click: frame:[%d], x:[%d], y:[%d]\n',1,xclick1,yclick1);
fprintf(1,'Suggested Click: frame:[%d], x:[%d], y:[%d]\n',1,xclick2,yclick2);
%figure; imshow(plotPoints(img,clicks(:,2:3)));

end

