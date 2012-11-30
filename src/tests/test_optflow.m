

%img1 = imread('frame/t4l1/32.jpg');
%img2 = imread('frame/t4l1/33.jpg');
%uv = estimate_flow_interface(img1, img2, 'classic+nl-fast');
%save ofdata4-1 uv

img1 = imread('frame/t3l3/9.jpg');
img2 = imread('frame/t3l3/10.jpg');
load ofdata3-3;

%uv = estimate_flow_interface(img1, img2, 'classic+nl-fast');
%save ofdata4-2 uv

%img1 = imread('frame/t1l2/1.jpg');
%img2 = imread('frame/t1l2/2.jpg');
%uv = estimate_flow_interface(img1, img2, 'classic+nl-fast');
%save ofdata1-2 uv

%%

%figure; imagesc(uv(:,:,1));
%figure; imagesc(uv(:,:,2));

%uvx = uv(:,:,1);
uvx = uv(:,:,2);
threshold = 0.5;
uvx_thresh = uvx.*(abs(uvx)>threshold);
%figure; imagesc(uvx_thresh);

%assign to clusters
[m,n] = size(uvx_thresh);
cluster_assign = zeros(m,n);
clusters = 0;
q = [];
cluster_count = [];
for i=1:m
    %fprintf('%d,',i);
    for j=1:n
        if ((abs(uvx_thresh(i,j)) > 0) && (cluster_assign(i,j) == 0))
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
                      (abs(uvx_thresh(px(1),px(2))) > 0))
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
           sumflow(c) = sumflow(c) + uvx_thresh(i,j);
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

%discard clusters with fewer elements than threshold
valid_clusters = cluster_count > minpx;
cluster_centers = cluster_centers(valid_clusters,:);
sumflow = sumflow(valid_clusters);

img3 = img2;
img4 = img2;
for c=1:size(cluster_centers,1)
    img4 = highlightBox(img4,cluster_dim(c,1),cluster_dim(c,2),cluster_dim(c,3),...
        cluster_dim(c,4),5,0,[255,0,0]);
   if (sumflow(c) > 0)
       img3 = highlightCircle(img3,cluster_centers(c,:),5,2,1,[255,0,0]);
   else
       img3 = highlightCircle(img3,cluster_centers(c,:),5,2,1,[0,0,255]);
   end
end
figure; imshow(img4);

