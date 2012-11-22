function newimg = highlightCircle(img,center,radius,circlewidth,alpha,clr);
%HIGHLIGHTCIRCLE highlights a circle in an image
% img is a 3 channel image
% center is a (2x1) vector specifying x and y coordinates of circle
% radius is the radius of the circle in pixels
% circlewidth is the width of the circle border
% alpha is the transperancy of the filling. 1 - means completely filled, 0
%                                               means empty
% color is a (3x1) vector specifying the rgb color value of the circle

newimg = img;

[rows cols channels] = size(img);

rowmap = repmat([1:rows]',1,cols);
colmap = repmat([1:cols],rows,1);

rowmapshift = rowmap - center(1);
colmapshift = colmap - center(2);

distance = sqrt(rowmapshift.^2 + colmapshift.^2);
maskline = uint8((distance >= radius) .* (distance <= radius+circlewidth));
maskfill = uint8(distance <= radius);


for i=1:channels
   ch = img(:,:,i);
   ch = (1-maskline).*ch + clr(i).*maskline;
   ch = (1-maskfill).*ch + maskfill.*((1-alpha).*ch) + clr(i).*maskfill.*alpha;
   newimg(:,:,i) = ch;
end

