
function bbox = extractBBox(filename, numBox)

img = imread(filename);

figure;
imagesc(img);
colormap(gray);

title('Click a box on this image'); 
axis image;

boxes = zeros(numBox,4);

for i = 1:numBox
    P = ginput(2);
    bbox(i,:) = round([P(:,2)' P(:,1)']);
    fprintf(['Box ' num2str(i) ' position:[ ' num2str(bbox(i,:)) ' ]\n']);
    img = highlightBox(img,bbox(i,1),bbox(i,2),bbox(i,3),bbox(i,4),...
                       2,0.3,[0,0,255]);
    imagesc(img); 
    colormap(gray);
    title('Click a box on this image'); 
    axis image;
end

