
click = zeros(2,3);

MAX_FRAME = 150;

mov_input = mmreader([datadir 't2l2.avi']);

%LOAD MASKS
space_mask = double(rgb2gray(imread('space-mask.jpg'))) > 128;

lastframe = 2;
confidence = -Inf;
CONFIDENCE_THRESHOLD = 0.5;

    lastframe = lastframe + 1;
    fprintf('Examining frame %d/%d...\n',lastframe,MAX_FRAME);
    
    img1 = read(mov_input,lastframe-2);
    img2 = read(mov_input,lastframe-1);
    img3 = read(mov_input,lastframe);

    datadir = 'data/';
    ref_img = imread([datadir 'ref-task1level1.bmp']);

    %COMPUTE OPTICAL FLOW
    fprintf(1,'Computing optical flow..\n');
    load('optflow_2_2_1 1');
    flow1 = flow;
    load('optflow_2_2_2 1');
    flow2 = flow;
    %flow1 = estimate_flow_interface(img1, img2, 'classic+nl-fast');
    %flow2 = estimate_flow_interface(img2, img3, 'classic+nl-fast');

    uvmag = sqrt(flow(:,:,2).^2+flow(:,:,1).^2);
    uvorient = atan2(flow(:,:,2),flow(:,:,1));

    %PERFORM CLUSTERING
    fprintf(1,'Clustering characters...\n');
    %cluster on earth.
    flow_threshold = 0.5;
    flowdiff = ((flow2(:,:,1).^2+flow1(:,:,2).^2)-...
                (flow1(:,:,1).^2 + flow1(:,:,2))>flow_threshold);

    %world_orient = sum(sum(uvorient.*earth_mask))./(sum(sum(earth_mask)));
    mag_threshold = 0.7;
    orient_threshold = 1;
    layout_earth = ((uvmag>mag_threshold) + (flowdiff) ).*earth_mask;
    %figure; subplot(2,1,1); imshow(img2); subplot(2,1,2); imagesc(layout_earth);
    [earth_clusters, ~, earth_cluster_centers,~,~,earth_cluster_dim] = ...
          clusterAssign(layout_earth,500);

    %cluster on space
    imgbw = double(rgb2gray(img3));
    bg_threshold = 45;
    layout_space = imgbw.*(imgbw > bg_threshold).*(space_mask);
    [space_clusters, ~, space_cluster_centers,~,~,space_cluster_dim] = ...
          clusterAssign(layout_space,500);

    clusters = earth_clusters+space_clusters;
    cluster_centers = [earth_cluster_centers; space_cluster_centers];
    cluster_dim = [earth_cluster_dim; space_cluster_dim];

    %PRINT BOUNDING BOXES
    img4 = img2;
    for c=1:size(cluster_centers,1)
        img4 = highlightBox(img4,cluster_dim(c,1),cluster_dim(c,2),cluster_dim(c,3),...
            cluster_dim(c,4),5,0,[255,0,0]);

    end
    %figure; imshow(img4);

    %EXTRACT FACES
    numfaces = clusters;
    faces = cell(numfaces,1);
    for i=1:numfaces
        faces{i} = img2(cluster_dim(i,1):cluster_dim(i,2),...
                        cluster_dim(i,3):cluster_dim(i,4),:);
    end

    %DETECT SIFT FEATURES
    fprintf(1,'Computing the SIFT features for faces in frame');
    frames = cell(numfaces,1);
    keypoints = cell(numfaces,1);
    descriptors = cell(numfaces,1);
    for i=1:numfaces
        fprintf(1,'.');
        imgbw = im2single(rgb2gray(faces{i}));
        [frames{i}, descriptors{i}] = vl_covdet(imgbw,'method', 'DoG',...
                                            'EstimateOrientation', true);
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

    xclick1 = bbox(index1,3) + (bbox(index1,4)-bbox(index1,3))/2;
    yclick1 = bbox(index1,1) + (bbox(index1,2)-bbox(index1,1))/3;

    xclick2 = bbox(index2,3) + (bbox(index2,4)-bbox(index2,3))/2;
    yclick2 = bbox(index2,1) + (bbox(index2,2)-bbox(index2,1))/3;

    clicks = zeros(2,3);
    clicks(1,:) = [lastframe xclick1, yclick1];
    clicks(2,:) = [lastframe xclick2, yclick2];

%RESULTS
fprintf(1,'Suggested Click: frame:[%d], x:[%d], y:[%d]\n',1,xclick1,yclick1);
fprintf(1,'Suggested Click: frame:[%d], x:[%d], y:[%d]\n',1,xclick2,yclick2);
%figure; imshow(plotPoints(img2,clicks(:,2:3)));