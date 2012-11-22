function A = faceAffinityMatrix(img,fdata,dim)
%UNTITLED returns an affinity matrix with the euclidean distance between
%each pair of faces in an image
%   fdata is an (Nx4) matrix, where N is the number of faces detected in the 
%   image. each row in the matrix contains the x,y position of the center of
%   the face and its width and height
%  dim is the dimension to compare images by

if (nargin < 3)
    dim = 40;
end

numFaces = size(fdata,1);
F = zeros(numFaces,dim^2);
A = zeros(numFaces);



for i=1:numFaces
    y = fdata(i,1);
    x = fdata(i,2);
    w = fdata(i,3);
    h = fdata(i,4);
    ln = min(w,h); %restrict to squares. could also try max
    ratio = ln/dim;
    fbox = resample_bilinear(img(y:y+ln,x:x+ln),ratio);
    F(i,:) = fbox(:)';
end

for i=1:numFaces
    for j=1:numFaces
        if (i==j)
            A(i,j) = inf;
        else
            A(i,j) = norm(F(i,:) - F(j,:));
        end
    end
end

