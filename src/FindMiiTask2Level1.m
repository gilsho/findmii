

function clicks = FindMiiTask2Level1(datadir)

clicks = zeros(2,3);

% change the number accordingly for other tasks and levels
mov_input = mmreader([datadir 't2l1.avi']);
frame = 1;
img = read(mov_input,frame);


%hardcoded faces coordinates

ylow    = [80   80  198 198];
yhigh   = [180  180 297 297];
xlow    = [231  405 197 417];
xhigh   = [311  495 293 518];

numfaces = numel(ylow);
faces = cell(numfaces,1);
for i=1:numel(ylow)
    faces{i} = img(ylow(i):yhigh(i),xlow(i):xhigh(i),:);
end

fprintf(1,'Computing the SIFT features for faces in video');
frames = cell(numfaces,1);
keypoints = cell(numfaces,1);
descriptors = cell(numfaces,1);
for i=1:numfaces
    fprintf(1,'.');
    [features{i},~,~,~] = detect_features(faces{i});
    keypoints{i} = features{i}(:,[1:3 6]);
    descriptors{i} = mySIFTdescriptor(faces{i},keypoints{i});
end
fprintf('\n');

fprintf(1,'Matching keypoints...\n');
threshold = 0.9;
score = zeros(numfaces);
minpts = 2;
%ignore bounding box for now
for i=1:numfaces
    for j=1:numfaces
        if (i == j)
            score(i,j) = 0;
        else
            matches = matchKeypoints(descriptors{i}',descriptors{j}',threshold);
            score(i,j) = numel(matches);
            if (0)
            %if (numel(matches) > 0)
                cxbox = mean([xlow(i) xhigh(i)]);
                cybox = mean([ylow(i) yhigh(i)]);
                wbox = xhigh(i) - xlow(i);
                hbox = yhigh(i) -  ylow(i);
                box = [cxbox cybox wbox hbox]; 
                [cx,cy,w,h,orient,votes] = getObjectRegion(keypoints{i}',...
                            keypoints{j}',matches, box, minpts);
                if (numel(votes) > 0)
                    score(i,j) = max(votes);
                end
            end
        end
    end
end

[maxvalscol maxindexcol] = max(score);
[~, maxindexrow] = max(maxvalscol);

index1 = maxindexrow;
index2 = maxindexcol(maxindexrow);

xclick1 = xlow(index1) + (xhigh(index1)-xlow(index1))/2;
yclick1 = ylow(index1) + (yhigh(index1)-ylow(index1))/3;

xclick2 = xlow(index2) + (xhigh(index2)-xlow(index2))/2;
yclick2 = ylow(index2) + (yhigh(index2)-ylow(index2))/3;

%c = randomColor();
%newimg = highlightBox(img, [ylow(index1), xlow(index1)], ...
%              xhigh(index1)-xlow(index1), yhigh(index1)-ylow(index1),... 
%              BOX_WIDTH,ALPHA, c);
%newimg = highlightBox(newimg, [ylow(index2), xlow(index2)], ...
%              xhigh(index2)-xlow(index2), yhigh(index2)-ylow(index2),... 
%              BOX_WIDTH,ALPHA, c);
%imshow(newimg);

clicks(1,:) = [1 xclick1, yclick1];
clicks(2,:) = [1 xclick2, yclick2];

    
end

