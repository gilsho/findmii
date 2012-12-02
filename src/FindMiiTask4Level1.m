
function clicks = FindMiiTask4Level1(datadir)

% change the number accordingly for other tasks and levels
mov_input = mmreader([datadir 't4l2.avi']);

lastframe = 22;
img1 = read(mov_input,lastframe-1);
img2 = read(mov_input,lastframe);

[m,n,~] = size(img1);
height_scale_factor = [100.4514 0.2655];
width_scale_factor = [23.2733 0.1131];

uv = estimate_flow_interface(img1, img2, 'classic+nl-fast');
%load ofdata_4-1
save ofdata_4-1_2

%apply scale gradient to flow
rowscale = ones(m,n)*height_scale_factor(1) + ...
           repmat((1:m)'*height_scale_factor(2),1,n);

colscale = ones(m,n)*width_scale_factor(1) + ...
           repmat((1:m)'*width_scale_factor(2),1,n);

uvx_scale = uv(:,:,1)./colscale;
uvy_scale = uv(:,:,2)./rowscale;

uvmag = (uvx_scale.^2 + uvy_scale.^2);
uvmag = uvmag./max(max(uvmag));
thresh_grad = 0.02;
uvmag_thresh = uvmag.*(abs(uvmag) > thresh_grad);
%imagesc(uvmag_thresh);

[clusters, cluster_count, cluster_centers,sum_values,...
          avg_values,cluster_dim] = clusterAssign(uvmag_thresh,1000);

img4 = img2;
for c=1:clusters
    img4 = highlightBox(img4,cluster_dim(c,1),cluster_dim(c,2),cluster_dim(c,3),...
        cluster_dim(c,4),5,0,[255,0,0]);
end
%figure; imshow(img4);
      
[sorted_avg_values, sorted_indices] = sort(avg_values,'descend');
confidence = sorted_avg_values(1)/sorted_avg_values(2);

max_cluster = sorted_indices(1);

yclick = cluster_centers(max_cluster,1); 
xclick = cluster_centers(max_cluster,2);

clicks = [lastframe xclick yclick];

img4 = highlightCircle(img4,[yclick xclick],5,2,1,[0,255,0]);
figure; imshow(img4);

fprintf(1,'Suggested Click: frame:[%d], x:[%d], y:[%d]\n',...
    lastframe,xclick,yclick);


end

