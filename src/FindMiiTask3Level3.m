

function click = FindMiiTask3Level3(datadir)

MAX_FRAME = 150;

click = zeros(1,3);

mov_input = mmreader([datadir 't3l3.avi']);
bg = imread('t3l3-bg.jpg');

lastframe = 2;
frame_interval = 2; 
CONFIDENCE_THRESHOLD = 1.5;
confidence = 0;
while ((confidence < CONFIDENCE_THRESHOLD) && (lastframe < MAX_FRAME))
    lastframe = lastframe + 1;
    fprintf('Examining frame %d/%d...\n',lastframe,MAX_FRAME);
    img1 = read(mov_input,lastframe-frame_interval);
    img2 = read(mov_input,lastframe);
    
    %CALCULATE OPTICAL FLOW
    uv = estimate_flow_interface(img1, img2, 'classic+nl-fast');

    %SUBTRACT BACKGROUND MASK
    bgthresh = 20;
    mask = imageDifferenceMask(img2,bg,bgthresh);

    uvy = uv(:,:,2);
    threshold = 0.3;
    uvy_thresh = uvy.*(abs(uvy)>threshold);
    %figure; imagesc(uvy_thresh+mask);

    %PERFORM CLUSTERING
    [clusters, cluster_count, cluster_centers,~,~,cluster_dim] = ...
        clusterAssign(uvy_thresh+mask,500);

    %discard everything but 4 biggest clusters
    [~,cluster_order] = sort(cluster_count,'descend');
    valid_clusters = cluster_order(1:4);
    cluster_centers = cluster_centers(valid_clusters,:);
    cluster_dim = cluster_dim(valid_clusters,:);

    %DETERMINE LEG COMPONENETS
    ratio = 1/4;
    cluster_dim_sub = zeros(4,2,4);
    for c=1:4
       ytop  = cluster_dim(c,1) + ...
               (cluster_dim(c,2) - cluster_dim(c,1))*(1-ratio);
       ybottom = cluster_dim(c,2);
       xleft = cluster_dim(c,3);
       width = (cluster_dim(c,4) - cluster_dim(c,3))/2;
       for j=1:2
           cluster_dim_sub(c,j,:) = round([ytop,ybottom,xleft,xleft+width]);
           xleft = xleft + width;
       end
    end

    %DRAW BOXES
    img4 = img2;
    for c=1:size(cluster_centers,1)
        img4 = highlightBox(img4,cluster_dim(c,1),cluster_dim(c,2),cluster_dim(c,3),...
            cluster_dim(c,4),5,0,[255,0,0]);
        for j=1:2
              img4 = highlightBox(img4,cluster_dim_sub(c,j,1),cluster_dim_sub(c,j,2),...
                  cluster_dim_sub(c,j,3),cluster_dim_sub(c,j,4),1,0,[0,0,255]);
        end
    
    end
    %figure; imshow(img4);

    %CALCULATE LEG MOTION CONFIGURATION
    sumflow = zeros(4,2);
    config = zeros(4,1);
    mag = zeros(4,1);
    for c=1:4
        for j=1:2
            sumflow(c,j) = ...
                sum(sum(uvy_thresh(cluster_dim_sub(c,j,1):cluster_dim_sub(c,j,2),...
                           cluster_dim_sub(c,j,3):cluster_dim_sub(c,j,4))));
        end
        mag(c) = sumflow(c,1)./sumflow(c,2);
        if (sumflow(c,1) > sumflow(c,2))
           config(c) = 1;
        else
           config(c) = 2;
        end
    end
    
    %DETECT MINORITY CONFIGURATION
    minority_cluster = 0;
    if (sum(config==1) > sum(config==2))
       minority_cluster = find(config==2);
       mag = 1./mag;
    elseif (sum(config==1) < sum(config==2)) 
       minority_cluster = find(config==1);
    else
        %no match
        continue
    end
    
    if (numel(minority_cluster) == 1)
        confidence = mag(minority_cluster);
    else
        confidence = 0;
    end
end

if (confidence >= CONFIDENCE_THRESHOLD)
    yclick = cluster_centers(minority_cluster,1);
    xclick = cluster_centers(minority_cluster,2);

    click = [lastframe xclick yclick];
end

fprintf(1,'Suggested Click: frame:[%d], x:[%d], y:[%d]\n',lastframe,xclick,yclick);
%PLOT RESULTS
%figure; imshow(plotPoints(img2,click(1,2:3)));


end

