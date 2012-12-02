

%function clicks = FindMiiTask2Level2(datadir)
datadir = 'data/';
clicks = zeros(2,3);

% change the number accordingly for other tasks and levels
mov_input = mmreader([datadir 't2l2.avi']);
lastframe = 28;
img1 = read(mov_input,lastframe-3);
img2 = read(mov_input,lastframe);

uv = estimate_flow_interface(img1, img2, 'classic+nl-fast');
%save ofdata2-2

uvmag = sqrt(uv(:,:,1).^2+uv(:,:,2).^2);

thresh = 2.5;
uvmag_thresh = uvmag.*(uvmag > thresh);
%subplot(2,1,1); imagesc(uvmag_thresh); subplot(2,1,2); imshow(img2);

[clusters, cluster_count, cluster_centers,~,~,cluster_dim] = ...
    clusterAssign(uvmag_thresh,500);


numfaces = clusters;
faces = cell(numfaces,1);
img4 = img2;
for i=1:numfaces
    faces{i} = single(img2(cluster_dim(i,1):cluster_dim(i,2),...
                    cluster_dim(:,3):cluster_dim(i,4),:));
    %draw boxes
    img4 = highlightBox(img4,cluster_dim(i,1),cluster_dim(i,2),...
        cluster_dim(i,3),cluster_dim(i,4),5,0,[255,0,0]);
end
%imshow(img4);

fprintf(1,'Computing the SIFT features for faces in video');
frames = cell(numfaces,1);
%keypoints = cell(numfaces,1);
descriptors = cell(numfaces,1);
for i=1:numfaces
    fprintf(1,'.');
    imgbw = im2single(rgb2gray(faces{i}));
    [frames{i}, descriptors{i}] = vl_covdet(imgbw,'method', 'DoG');
end
fprintf('\n');

fprintf(1,'Matching keypoints...\n');
threshold = 0.8;
score = zeros(numfaces);
minpts = 2;
%ignore bounding box for now
for i=1:numfaces
    for j=1:numfaces
        if (i == j)
            score(i,j) = 0;
        else
            matches = matchKeypoints(descriptors{i},descriptors{j},threshold);
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

clicks(1,:) = [lastframe xclick1, yclick1];
clicks(2,:) = [lastframe xclick2, yclick2];

figure; imshow(plotPoints(img2,clicks(:,2:3)));
    
%end

