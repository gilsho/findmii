function newimg = highlightBox(img,ylow,yhigh,xlow,xhigh,linewidth,alpha,clr)
%HIGHLIGHTBOX highlights a rectangle in an image
% img is a 3 channel image
% ylow is the top row of the box
% yhigh is the bottom row of the box
% xlow is the left column of the box
% xhigh is the right column of the box
% alpha is the transperancy of the filling. 1 - means completely filled, 0
%                                               means empty
% color is a (3x1) vector specifying the rgb color value of the circle

newimg = img;

width = abs(xhigh-xlow);
height = abs(yhigh-ylow);

[rows cols channels] = size(img);

rowmap = repmat([1:rows]',1,cols);
colmap = repmat([1:cols],rows,1);

%rowmapshift = rowmap - center(1);
%colmapshift = colmap - center(2);
%distance = sqrt(rowmapshift.^2 + colmapshift.^2);

maskline = uint8(((colmap >= xlow-linewidth).*(colmap <= xlow) + ...
                  (colmap >= xlow+width).*(colmap <= xlow+width+linewidth)) .*...
                 ((rowmap >= ylow-linewidth).*(rowmap <=ylow+height+linewidth)) +... 
                 ((rowmap >= ylow-linewidth).*(rowmap <= ylow) + ...
                  (rowmap >= ylow+height).*(rowmap <= ylow+height+linewidth)).*...
                 ((colmap > xlow).*(colmap < xlow+width))...           
              );
              
maskfill = uint8((colmap >= xlow).*(colmap <= xlow+width).*(rowmap >= ylow).*...
                 (rowmap <= ylow+height));


for i=1:channels
   ch = img(:,:,i);
   ch = (1-maskline).*ch + clr(i).*maskline;
   ch = (1-maskfill).*ch + maskfill.*((1-alpha).*ch) + clr(i).*maskfill.*alpha;
   newimg(:,:,i) = ch;
end



end

