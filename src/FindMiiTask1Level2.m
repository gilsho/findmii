

function clicks = FindMiiTask1Level2(datadir)

clicks = zeros(2,3);

BOX_WIDTH = 5;
ALPHA = 0.5;

% The following are example code for you to do the job in matlab.
% Read the reference image, only do this for task 1 (all levels)
% Change filename for level 2 and 3
ref_img = imread([datadir 'ref-task1level2.bmp']);

% We have 150 frames for task 1 level 1,
% change the number accordingly for other tasks and levels
mov_input = mmreader([datadir 't1l2.avi']);
frame = 30;
img = read(mov_input,frame);

img = imread('frame/t2l1/1.jpg');


%hardcoded faces coordinates

ylow    = [80   80  198 198];
yhigh   = [180  180 297 297];
xlow    = [231  405 197 417];
xhigh   = [311  495 293 518];

faces = cell(numel(ylow),1);
for i=1:numel(ylow)
    faces{i} = img(ylow(i):yhigh(i),xlow(i):xhigh(i),:);
end

A = faceAffinityMatrix(faces);
[minvalscol mindexcol] = min(A);
[~, mindexrow] = min(minvalscol);

c = randomColor();
index1 = mindexrow;
newimg = highlightBox(img, [ylow(index1), xlow(index1)], ...
              xhigh(index1)-xlow(index1), yhigh(index1)-ylow(index1),... 
              BOX_WIDTH,ALPHA, c);
index2 = mindexcol(mindexrow);
newimg = highlightBox(newimg, [ylow(index2), xlow(index2)], ...
              xhigh(index2)-xlow(index2), yhigh(index2)-ylow(index2),... 
              BOX_WIDTH,ALPHA, c);
imshow(newimg);

    
end

