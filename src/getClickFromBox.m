function [xclick yclick] = getClickFromBox(cx, cy, w, h, orient)
%GETCLICKFROMBOX returns an optimal click location in an bounding box
%according to a policy

%returns position in center of upper 1/3rd line of the image

translation = h/6;
xclick = cx - translation*sin(orient);
yclick = cy - translation*cos(orient);

end

