

img1 = imread('frame/t3l3/20.jpg');
img2 = imread('frame/t3l3/21.jpg');
lastframe = 21;


uv = estimate_flow_interface(img1, img2, 'classic+nl-fast');
save ofdata3-3-2 uv
%load ofdata3-3

%figure; imagesc(uv(:,:,1));
%figure; imagesc(uv(:,:,2));

uvx = uv(:,:,1);
uvy = uv(:,:,2);
threshold = 0.3;
uvy_thresh = uvy.*(abs(uvy)>threshold);
%figure; imagesc(uvx_thresh);

%assign to clusters
[m,n] = size(uvy_thresh);
cluster_assign = zeros(m,n);
clusters = 0;
q = [];
cluster_count = [];
for i=1:m
    %fprintf('%d,',i);
    for j=1:n
        if ((abs(uvy_thresh(i,j)) > 0) && (cluster_assign(i,j) == 0))
           %fprintf('.cluster detected\n');
           clusters = clusters+1;
           cluster_assign(i,j) = clusters;
           count = 1;
           q = neighbors(i,j);
           while ( ~isempty(q))
               px = q(1,:);
               q = q(2:end,:);
               if ((px(1) > 0) && (px(2) > 0) && ...
                   (px(1) < m) && (px(2) < n))
                   
                  if ((cluster_assign(px(1),px(2)) == 0) && ...
                      (abs(uvy_thresh(px(1),px(2))) > 0))
                    cluster_assign(px(1),px(2)) = clusters;
                    %fprintf('(%d,%d)\n',px(1),px(2));
                    q = [q; neighbors(px(1),px(2))];
                    count = count+1;
                  end
                  
               end
           end
           cluster_count = [cluster_count, count];
        end
    end
end


minpx = 1000;
cluster_centers = zeros(clusters,2);
cluster_dim = repmat([Inf -Inf Inf -Inf],clusters,1);
sumflow = zeros(clusters,1);
for i=1:m
    for j=1:n
        c = cluster_assign(i,j);
        if (c ~= 0);
           sumflow(c) = sumflow(c) + uvy_thresh(i,j);
           cluster_centers(c,1) = cluster_centers(c,1) + i;
           cluster_centers(c,2) = cluster_centers(c,2) + j;
           cluster_dim(c,1) = min(cluster_dim(c,1),i);
           cluster_dim(c,2) = max(cluster_dim(c,2),i);
           cluster_dim(c,3) = min(cluster_dim(c,3),j);
           cluster_dim(c,4) = max(cluster_dim(c,4),j);
        end
    end
end

%calculate centers
for c=1:clusters
    cluster_centers(c,:) = cluster_centers(c,:)./cluster_count(c); 
    %sumflow(c) = sumflow(c)./cluster_count(c);
end

%discard 4 biggest clusters
[~,cluster_order] = sort(cluster_count,'descend');
valid_clusters = cluster_order(1:4);
cluster_centers = cluster_centers(valid_clusters,:);
cluster_dim = cluster_dim(valid_clusters,:);
sumflow = sumflow(valid_clusters);

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

img3 = img2;
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

xclick = cluster_centers(minority_cluster,1);
yclick = cluster_centers(minority_cluster,2);

click = [lastframe xclick yclick];

img4 = highlightCircle(img4,[xclick, yclick],5,2,1,[0,255,0]);
figure; imshow(img4);