

%function clicks = FindMiiTask3Level1(datadir)

datadir = 'data/';
% change the number accordingly for other tasks and levels
mov_input = mmreader([datadir 't3l3.avi']);
lastframe = 10;
img1 = read(mov_input,lastframe-3);
img2 = read(mov_input,lastframe);
bg = imread('t3l3-bg.jpg');

uv = estimate_flow_interface(img1, img2, 'classic+nl-fast');
save ofdata3-3-6 uv
%load ofdata3-3-4

bgthresh = 20;
mask = imageDifferenceMask(img2,bg,bgthresh);

uvy = uv(:,:,2);
threshold = 0.3;
uvy_thresh = uvy.*(abs(uvy)>threshold);
%figure; imagesc(uvy_thresh+mask);

[clusters, cluster_count, cluster_centers,~,~,cluster_dim] = ...
    clusterAssign(uvy_thresh+mask,500);

%discard everything but 4 biggest clusters
[~,cluster_order] = sort(cluster_count,'descend');
valid_clusters = cluster_order(1:4);
cluster_centers = cluster_centers(valid_clusters,:);
cluster_dim = cluster_dim(valid_clusters,:);

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

%draw boxes
img4 = img2;
for c=1:size(cluster_centers,1)
    img4 = highlightBox(img4,cluster_dim(c,1),cluster_dim(c,2),cluster_dim(c,3),...
        cluster_dim(c,4),5,0,[255,0,0]);
    for j=1:2
          img4 = highlightBox(img4,cluster_dim_sub(c,j,1),cluster_dim_sub(c,j,2),...
              cluster_dim_sub(c,j,3),cluster_dim_sub(c,j,4),1,0,[0,0,255]);
    end
    
end
figure; imshow(img4);

%calculate leg boxes
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

%find minority configuration
minority_cluster = 0;
if (sum(config==1) > sum(config==2))
   minority_cluster = (config==2);
elseif (sum(config==1) < sum(config==2)) 
   minority_cluster = (config==1);
   mag = 1./mag;
else
    %undecided
    %return;
end

magthresh = 1.5;
if (mag(minority_cluster) < magthresh)
   %undecided 
   %return;
end


%return also mintority_cluster sorted by x
%callee should wait until 3 consecutive clicks on same cluster
%unless confidence high

yclick = cluster_centers(minority_cluster,1);
xclick = cluster_centers(minority_cluster,2);

click = [lastframe xclick yclick];

img4 = highlightCircle(img4,[yclick xclick],5,2,1,[0,255,0]);
figure; imshow(img4);


%end

