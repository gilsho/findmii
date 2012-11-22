function A = faceAffinityMatrix(faces,dim)
%UNTITLED returns an affinity matrix with the euclidean distance between
%each pair of faces in an image
%   faces is a cell array containing the faces to compare
%  dim is the dimension to compare images by

if (nargin < 2)
    dim = 40;
end

numFaces = numel(faces);
F = zeros(numFaces,3*dim^2);
A = zeros(numFaces);



for i=1:numFaces
    %convert to square
    face = faces{i};
    [rows,cols,~] =  size(face);
    if (rows > cols)
       diff = rows - cols;
       ylow = round(diff/2);
       if (mod(rows,2) == 1)
          ylow = ylow + 1; 
       end
       yhigh = rows - (diff-round(diff/2));
       face = face(ylow:yhigh,:,:);
    elseif (rows < cols)
       diff = cols - rows;
       xlow = round(diff/2);
       if (mod(cols,2) == 1)
          xlow = xlow + 1; 
       end
       xhigh = cols - (diff-round(diff/2));
       face = face(:,xlow:xhigh,:);
    end
    ln = min(size(face(:,:,1))); %restrict to squares. could also try max
    ratio = ln/dim;
    fbox = zeros(dim,dim,3);
    for j=1:3
        fbox(:,:,j) = resample_bilinear(face(:,:,j),ratio);
    end
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

