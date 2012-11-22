function [cx, cy, w, h, orient, count] = getObjectRegion(keypt1, keypt2, matches, objbox, thresh)
% Get the center x-y (cx,cy), width and height (w,h), and orientation
% (orient) for each predicted object bounding box in the image.

% YOUR CODE HERE

% Find parameters for object bounding box
objx = (objbox(3)+objbox(1))/2; % x-center
objy = (objbox(4)+objbox(2))/2; % y-center
objw = objbox(3)-objbox(1);
objh = objbox(4)-objbox(2);

% Find parameters for keypoints in image 1
m = size(matches,2);

s1 = keypt1(3,matches(1,:));
o1 = keypt1(4,matches(1,:));
x1 = keypt1(1,matches(1,:));
y1 = keypt1(2,matches(1,:));

% Find parameters for keypoints in image 2
s2 = keypt2(3,matches(2,:));
o2 = keypt2(4,matches(2,:));
x2 = keypt2(1,matches(2,:));
y2 = keypt2(2,matches(2,:));

% Use four uniform bins for each dimension, vote from each keypoint and
% store all the bounding boxes whose votes is larger than thresh.

nbins = 4;

ovec = o2 - o1;
svec = (s2./s1);
xvec = (s2./s1).*((objx-x1).*cos(ovec)-(objy-y1).*sin(ovec))+x2;
yvec = (s2./s1).*((objx-x1).*sin(ovec)+(objy-y1).*cos(ovec))+y2;

obin = assign2bins(ovec,nbins);
sbin = assign2bins(svec,nbins);
xbin = assign2bins(xvec,nbins);
ybin = assign2bins(yvec,nbins);

cx = []; cy = []; w = []; h = []; orient = []; count = [];

%vote
for xb=1:nbins
    for yb=1:nbins
        for sb=1:nbins
            for ob=1:nbins
                votepoints = intersect(find(xbin == xb), ...
                             intersect(find(ybin == yb), ...
                             intersect(find(sbin == sb), ...
                                       find(obin == ob))));
                votes = numel(votepoints);
                if (votes >= thresh) 
                    scale = mean(svec(votepoints));
                    cx      = [cx,      mean(xvec(votepoints))];
                    cy      = [cy,      mean(yvec(votepoints))];
                    orient  = [orient,  mean(ovec(votepoints))];
                    w       = [w,       scale*objw];
                    h       = [h,       scale*objh];
                    count   = [count,   votes];
                end
            end
        end
    end
end
fprintf('\n');

% Potentially useful function:
% creates nb uniform bins within range of x and assigns each x to a bin
% example usage:
% myhistogram = assign2bins(data_vector, number_of_bins)
% myhistogram is now an array of the same length as data_vector, in which
% all entries now correspond to their bin index.

function b = assign2bins(x, nb)
b = min(max(ceil((x-min(x))/(max(x)-min(x))*nb), 1), nb);

