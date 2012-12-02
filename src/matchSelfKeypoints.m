function matches = matchSelfKeypoints(desc, thresh)
% Each column of desc1 or desc2 is a 128-d descriptor vector of a keypoint.
% matches is a 2 x N array of indices that indicates which keypoints in
% desc1 match which keypoints in desc2.

% YOUR CODE HERE


progressbar = 0;

n = size(desc,2);
matches = [];
%fprintf('matching keypoints');
for i=1:n
    %if ((i*100/n) > progressbar)
    %    fprintf('.');
    %    progressbar = progressbar + 5;
    %end
    g = desc(:,i);
    gvector = repmat(g,1,n);
    euclidean = sqrt(sum((gvector - desc).^2,1));
    [sortdist,neighbors] = sort(euclidean);
    
    %assume sort(1) will be the vector itself!
    if (sortdist(2)/sortdist(3) < thresh)
       matches = [matches, [i; neighbors(2)] ];
    end
    
end
%fprintf('\n');



