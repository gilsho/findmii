
function [clusters, cluster_count, cluster_centers,sum_values,...
          avg_values,cluster_dim] = clusterAssign(data,minpx)
      
if (nargin < 2)
    minpx = 0;
end

%assign to clusters
[m,n] = size(data);
cluster_assign = zeros(m,n);
clusters = 0;
q = [];
cluster_count = [];
for i=1:m
    %fprintf('%d,',i);
    for j=1:n
        if ((abs(data(i,j)) > 0) && (cluster_assign(i,j) == 0))
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
                      (abs(data(px(1),px(2))) > 0))
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

cluster_centers = zeros(clusters,2);
cluster_dim = repmat([Inf -Inf Inf -Inf],clusters,1);
sum_values = zeros(clusters,1);
for i=1:m
    for j=1:n
        c = cluster_assign(i,j);
        if (c ~= 0)
            sum_values(c) = sum_values(c) + data(i,j);
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
avg_values = zeros(size(sum_values));
for c=1:clusters
    cluster_centers(c,:) = cluster_centers(c,:)./cluster_count(c); 
   avg_values(c) = sum_values(c)./cluster_count(c);
end

valid_clusters = find(cluster_count > minpx);
clusters = length(valid_clusters);
cluster_centers = cluster_centers(valid_clusters,:);
sum_values = sum_values(valid_clusters);
avg_values = avg_values(valid_clusters);
cluster_dim = cluster_dim(valid_clusters,:);
cluster_count = cluster_count(valid_clusters);

end

