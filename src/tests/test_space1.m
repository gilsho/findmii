clear all;
clc;
load('optflow_1_3_36 1');
flow1 = flow;
load('optflow_1_3_37 1');
flow2 = flow;

datadir = 'data/';
ref_img = imread([datadir 'ref-task1level1.bmp']);
%ref_img = imresize(ref_img,ratio);
    
%COMPUTE OPTICAL FLOW
fprintf(1,'Computing optical flow..\n');
%uv = ...
uvmag = sqrt(flow(:,:,2).^2+flow(:,:,1).^2);
uvorient = atan2(flow(:,:,2),flow(:,:,1));

%figure; subplot(2,1,1); imagesc(uvmag_thresh); subplot(2,1,2); imshow(img2);
%figure; subplot(2,1,1); imagesc(uvorient); subplot(2,1,2); imshow(img2);

%LOAD MASKS
space_mask = double(rgb2gray(imread('space-mask.jpg'))) > 128;
earth_mask = double(rgb2gray(imread('space-mask.jpg'))) < 128;

%PERFORM CLUSTERING
fprintf(1,'Clustering characters...\n');
%cluster on earth.
flow_threshold = 0.5;
flowdiff = ((flow2(:,:,1).^2+flow1(:,:,2).^2)-...
            (flow1(:,:,1).^2 + flow1(:,:,2))>flow_threshold);

%world_orient = sum(sum(uvorient.*earth_mask))./(sum(sum(earth_mask)));
mag_threshold = 0.7;
%orient_threshold = 1;
layout_earth = ((uvmag>mag_threshold) + (flowdiff) ).*earth_mask;
figure; subplot(2,1,1); imshow(img2); subplot(2,1,2); imagesc(layout_earth);
[earth_clusters, ~, earth_cluster_centers,~,~,earth_cluster_dim] = ...
      clusterAssign(layout_earth,500);

%cluster on space
imgbw = double(rgb2gray(img2));
bg_threshold = 45;
layout_space = imgbw.*(imgbw > bg_threshold).*(space_mask);
[space_clusters, ~, space_cluster_centers,~,~,space_cluster_dim] = ...
      clusterAssign(layout_space,500);
  
clusters = earth_clusters+space_clusters;
cluster_centers = [earth_cluster_centers; space_cluster_centers];
cluster_dim = [earth_cluster_dim; space_cluster_dim];

%PRINT BOUNDING BOXES
img4 = img2;
for c=1:size(cluster_centers,1)
    img4 = highlightBox(img4,cluster_dim(c,1),cluster_dim(c,2),cluster_dim(c,3),...
        cluster_dim(c,4),5,0,[255,0,0]);

end
figure; imshow(img4);

%EXTRACT FACES
numfaces = clusters;
faces = cell(numfaces,1);
for i=1:numfaces
    faces{i} = img2(cluster_dim(i,1):cluster_dim(i,2),...
                    cluster_dim(i,3):cluster_dim(i,4),:);
end

%DETECT SIFT FEATURES
fprintf(1,'Computing the SIFT features for face in reference image...\n');
imgbw = im2single(rgb2gray(ref_img));
[ref_frames, ref_descriptors] = vl_covdet(imgbw,'method', 'DoG',...
                                    'EstimateOrientation', true);

fprintf(1,'Computing the SIFT features for faces in frame');
frames = cell(numfaces,1);
keypoints = cell(numfaces,1);
descriptors = cell(numfaces,1);
for i=1:numfaces
    fprintf(1,'.');
    imgbw = im2single(rgb2gray(faces{i}));
    [frames{i}, descriptors{i}] = vl_covdet(imgbw,'method', 'DoG',...
                                        'EstimateOrientation', true);
end
fprintf('\n');


%MATCH KEYPOINTS
fprintf(1,'Matching keypoints...\n');
threshold = 0.75;
score = zeros(numfaces,1);
for i=1:numfaces
    matches = matchKeypoints(ref_descriptors,descriptors{i},threshold);
    score(i) = numel(matches);
end

score

%PRINT BOUNDING BOXES
img4 = img2;
for c=1:size(cluster_centers,1)
    if (score(c) < 1)
        continue;
    end
    img4 = highlightBox(img4,cluster_dim(c,1),cluster_dim(c,2),cluster_dim(c,3),...
        cluster_dim(c,4),5,0,[255,0,0]);

end
figure; imshow(img4);

%CALCULATE CONFIDENCE LEVEL
[score_sorted,sorted_index] = sort(score,'Descend');    
confidence = score_sorted(1)/score_sorted(2);


