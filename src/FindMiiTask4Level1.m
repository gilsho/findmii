
function clicks = FindMiiTask4Level1(datadir)

mov_input = mmreader([datadir 't4l1.avi']);

height_scale_factor = [100.4514 0.2655];
width_scale_factor = [23.2733 0.1131];

lastframe = 1;
frame_interval = 1;
CONFIDENCE_THRESHOLD = 1.5;
confidence = 0;
while ((confidence < CONFIDENCE_THRESHOLD) && (lastframe < MAX_FRAME))
    lastframe = lastframe + 1;
    fprintf('Examining frame %d/%d...\n',lastframe,MAX_FRAME);
    img1 = read(mov_input,lastframe-frame_interval);
    img2 = read(mov_input,lastframe);
    [m,n,~] = size(img1);
    
    %CALCULATE OPTICAL FLOW
    fprintf('Calculating Flow...\n');
    uv = estimate_flow_interface(img1, img2, 'classic+nl-fast');

    %APPLY SCALE GRADIENT
    rowscale = ones(m,n)*height_scale_factor(1) + ...
               repmat((1:m)'*height_scale_factor(2),1,n);

    colscale = ones(m,n)*width_scale_factor(1) + ...
               repmat((1:m)'*width_scale_factor(2),1,n);

    uvx_scale = uv(:,:,1)./colscale;
    uvy_scale = uv(:,:,2)./rowscale;

    %EXTRACT MAGNITUDE
    uvmag = (uvx_scale.^2 + uvy_scale.^2);
    uvmag = uvmag./max(max(uvmag));
    thresh_grad = 0.02;
    uvmag_thresh = uvmag.*(abs(uvmag) > thresh_grad);
    %imagesc(uvmag_thresh);

    %PERFORM CLUSTERING
    fprintf('Clustering...\n');
    [clusters, cluster_count, cluster_centers,sum_values,...
              avg_values,cluster_dim] = clusterAssign(uvmag_thresh,1000);
    img4 = img2;
    for c=1:clusters
        img4 = highlightBox(img4,cluster_dim(c,1),cluster_dim(c,2),cluster_dim(c,3),...
            cluster_dim(c,4),5,0,[255,0,0]);
    end
    %figure; imshow(img4);

    %FIND FASTEST CLUSTER
    [sorted_avg_values, sorted_indices] = sort(avg_values,'descend');
    max_cluster = sorted_indices(1);
    
    confidence = sorted_avg_values(1)/sorted_avg_values(2);
end

if (confidence >= CONFIDENCE_THRESHOLD)
    
    yclick = cluster_centers(max_cluster,1); 
    xclick = cluster_centers(max_cluster,2);
    clicks = [lastframe xclick yclick];
end

fprintf(1,'Suggested Click: frame:[%d], x:[%d], y:[%d]\n',lastframe,xclick,yclick);

%PLOT RESULTS
%img4 = highlightCircle(img4,[yclick xclick],5,2,1,[0,255,0]);
%figure; imshow(img4);

end

