function newimg = plotPoints(img,P)
%PLOTPOINTS draws points on an image
%   P is matrix in which each row represents a point
%   the first column is the x coordinates of the points
%   the second column is the y coordinates of the points
%   the third column is the scale of the points (optional)
%   the fourth column is the orientation of the points (optional)

[m n] = size(P);

CIRCLE_WIDTH = 1;
DEFAULT_SCALE = 1;
ALPHA = 0;

clr = [0 0 255]; %blue

newimg = img;
for i=1:m
    x = P(i,1);
    y = P(i,2);
    if (n > 2)
        s = P(i,3);
    else
        s = DEFAULT_SCALE;
    end
    newimg = highlightCircle(newimg,[y x],s,CIRCLE_WIDTH,ALPHA,clr);
end


end

