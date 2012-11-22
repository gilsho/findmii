function newimg = highlightBox(img,pos,width,height,linewidth,alpha,clr)
%HIGHLIGHTBOX highlights a rectangle in an image
% img is a 3 channel image
% pos is a (2x1) vector specifying x and y coordinates of top left corner
% width is the width of the box
% height is the height of the box
% alpha is the transperancy of the filling. 1 - means completely filled, 0
%                                               means empty
% color is a (3x1) vector specifying the rgb color value of the circle

newimg = img;

x = pos(2);
y = pos(1);
[rows cols channels] = size(img);

rowmap = repmat([1:rows]',1,cols);
colmap = repmat([1:cols],rows,1);

%rowmapshift = rowmap - center(1);
%colmapshift = colmap - center(2);
%distance = sqrt(rowmapshift.^2 + colmapshift.^2);

maskline = uint8(((colmap >= x-linewidth).*(colmap <= x) + ...
                  (colmap >= x+width).*(colmap <= x+width+linewidth)) .*...
                 ((rowmap >= y-linewidth).*(rowmap <= y) + ...
                  (rowmap >= y+height).*(rowmap <= y+height+linewidth)));
maskfill = uint8((colmap >= x).*(colmap <= x+width).*(rowmap >= y).*...
                 (rowmap <= y+height));


for i=1:channels
   ch = img(:,:,i);
   ch = (1-maskline).*ch + clr(i).*maskline;
   ch = (1-maskfill).*ch + maskfill.*((1-alpha).*ch) + clr(i).*maskfill.*alpha;
   newimg(:,:,i) = ch;
end



end

