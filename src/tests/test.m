%clear all;
clc;


addpath('tests');
addpath('sift-class');
addpath('sift-class/KeypointDetect');
addpath('sift-class/KeypointMatch');


img = imread('frame/t1l1/1.jpg');
order = 50;
sigbase = 20;
levels = 5;
sigstep = 10;
%[diff scale] = dogfilter(img,levels,sigbase,sigstep);
% figure; imagesc(diff); figure;  imagesc(scale);

CIRCLE_WIDTH = 1;
ALPHA = 0.5;


%%

xstart = [220, 198, 172, 144];
ylevel = [96, 157, 240, 357];
gap = [93, 106, 123, 145];
width = [20, 25, 30, 35];
height = [20 25 30 35];
for i=1:4
    x = xstart(i);
    y = ylevel(i);
    w = width(i);
    g = gap(i);
    for j=1:4
        img = highlightCircle(img, [y x],w,CIRCLE_WIDTH,ALPHA,randomColor());
        x = x + g;
    end
end

imshow(img);
%%

img = imread('frame/t1l1/1.jpg');

xstart = [200, 173, 142, 110];
ylevel = [76, 132, 210, 322];
gap = [93, 106, 123, 145];
width = [40, 50, 60, 70];
height = [40 50 60 60];
fdata = zeros(16,4);
for i=1:4
    x = xstart(i);
    y = ylevel(i);
    w = width(i);
    h = height(i);
    g = gap(i);
    for j=1:4
        %img = highlightBox(img, [y x],w,h,CIRCLE_WIDTH,ALPHA,randomColor());
        fdata((i-1)*4+j,:) = [y x w h];
        x = x + g;
    end
end

A = faceAffinityMatrix(img,fdata);
[minvalscol mindexcol] = min(A);
[dummy, mindexrow] = min(minvalscol);

c = randomColor();
d = fdata(mindexrow,:);
newimg = highlightBox(img, [d(1), d(2)], d(3), d(4), CIRCLE_WIDTH,ALPHA, c);
d = fdata(mindexcol(mindexrow),:);
newimg = highlightBox(newimg, [d(1), d(2)], d(3), d(4), CIRCLE_WIDTH,ALPHA, c);



imshow(newimg);


%%
%detector = vision.CascadeObjectDetector('FrontalFaceCART');
%vision.CascadeObjectDetector('ClassificationModel','FrontalFaceCART','MinSize',30,'MaxSize',60,'ScaleFactor',1.1,'MergeThreshold',4');
%bbox = step(detector,img); %ProfileFace

%shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',[255 255 0]);    
%I_faces = step(shapeInserter, img, int32(bbox));    
%figure, imshow(I_faces), title('Detected faces');


%%

CIRCLE_WIDTH = 1;
ALPHA = 0.5;

img = imread('frame/t2l1/1.jpg');
imshow(img);

xstart = [242, 208];
ylevel = [101, 223];
gap = [180, 220];
width = [60, 60];
height = [70, 70];
fdata = zeros(4,4);
for i=1:2
    x = xstart(i);
    y = ylevel(i);
    w = width(i);
    h = height(i);
    g = gap(i);
    for j=1:2
        %img = highlightBox(img, [y x],w,h,CIRCLE_WIDTH,ALPHA,randomColor());
        fdata((i-1)*2+j,:) = [y x w h];
        x = x + g;
    end
end

A = faceAffinityMatrix(img,fdata);
[minvalscol mindexcol] = min(A);
[dummy, mindexrow] = min(minvalscol);

c = randomColor();
d = fdata(mindexrow,:);
newimg = highlightBox(img, [d(1), d(2)], d(3), d(4), CIRCLE_WIDTH,ALPHA, c);
d = fdata(mindexcol(mindexrow),:);
newimg = highlightBox(newimg, [d(1), d(2)], d(3), d(4), CIRCLE_WIDTH,ALPHA, c);

imshow(newimg);
