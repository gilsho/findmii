function matches = matchKeypoints(desc1, desc2, thresh)
% Each column of desc1 or desc2 is a 128-d descriptor vector of a keypoint.
% matches is a 2 x N array of indices that indicates which keypoints in
% desc1 match which keypoints in desc2.

% YOUR CODE HERE


progressbar = 0;

n = size(desc1,2);
m = size(desc2,2);
matches = [];
%fprintf('matching keypoints');
for i=1:n
    %if ((i*100/n) > progressbar)
    %    fprintf('.');
    %    progressbar = progressbar + 5;
    %end
    g = desc1(:,i);
    gvector = repmat(g,1,m);
    euclidean = sqrt(sum((gvector - desc2).^2,1));
    [sortdist,neighbors] = sort(euclidean);
    if (sortdist(1)/sortdist(2) < thresh)
       matches = [matches, [i; neighbors(1)] ];
    end
    
end
%fprintf('\n');



