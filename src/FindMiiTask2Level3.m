

function clicks = FindMiiTask2Level3(datadir)
clicks = zeros(2,3);

% change the number accordingly for other tasks and levels
mov_input = mmreader([datadir 't2l3.avi']);
lastframe = 2;

img1 = read(mov_input,lastframe-1); %1 or 2 frames. currently 2 seems better
img2 = read(mov_input,lastframe);

[m,n,~] = size(img1);
height_scale_factor = [100.4514 0.2655];
width_scale_factor = [23.2733 0.1131];

uv = estimate_flow_interface(img1, img2, 'classic+nl-fast');
%load ofdata_2-3
save ofdata_2-3

%apply scale gradient to flow
rowscale = ones(m,n)*height_scale_factor(1) + ...
           repmat((1:m)'*height_scale_factor(2),1,n);

colscale = ones(m,n)*width_scale_factor(1) + ...
           repmat((1:m)'*width_scale_factor(2),1,n);

uvx_scale = uv(:,:,1)./colscale;
uvy_scale = uv(:,:,2)./rowscale;

uvmag = (uvx_scale.^2 + uvy_scale.^2);
uvmag = uvmag./max(max(uvmag));
thresh_grad = 0.07;
uvmag_thresh = uvmag.*(abs(uvmag) > thresh_grad);
%imagesc(uvmag_thresh);

[clusters, cluster_count, cluster_centers,sum_values,...
          avg_values,cluster_dim] = clusterAssign(uvmag_thresh,1000);


img4 = img2;
for c=1:clusters
    img4 = highlightBox(img4,cluster_dim(c,1),cluster_dim(c,2),cluster_dim(c,3),...
        cluster_dim(c,4),5,0,[255,0,0]);
end
figure; imshow(img4);      
      
%%%%%%%%%%%%%%%%


% Detect the SIFT features:
fprintf(1,'Computing the SIFT features for entire frame...\n');
[frame, descriptors] = vl_covdet(imgbw,'method', 'DoG');
figure; imshow(img); hold on; vl_plotframe(frame); hold off;


%Texture mask
mask = textureMask(imgbw);
mask(:,1:60) = zeros(m,60);
mask(:,661:end) = zeros(m,60);
mask(1:40,:) = zeros(40,n);
frame_filtered = [];

%[clusters, cluster_count, cluster_centers,~,...
%          ~,cluster_dim] = clusterAssign(mask,1000);
         
%img4 = img;
%for c=1:size(cluster_centers,1)
%    img4 = highlightBox(img4,cluster_dim(c,1),cluster_dim(c,2),cluster_dim(c,3),...
%        cluster_dim(c,4),5,0,[255,0,0]);    
%end
%figure; imshow(img4);

descriptors_filtered = [];
for i=1:size(frame,2)
   x = round(frame(1,i));
   y = round(frame(2,i));
   if (mask(y,x))
      frame_filtered = [frame_filtered,frame(:,i)]; 
      descriptors_filtered = [descriptors_filtered, descriptors(:,i)];
   end
end
%figure; imshow(img); hold on; vl_plotframe(frame_filtered); hold off;

fprintf(1,'Matching keypoints...');
minpts = 2;
threshold = 0.7;
matches = matchSelfKeypoints(descriptors_filtered, threshold);

%PLOT MATCHES
if (numel(matches) > 1)
    figure;
    plotmatches(im2double(img),im2double(img),frame,frame,matches);
else
    fprintf('No matches found!');
end
fprintf('\n');

fprintf(1,'Extracting click regions...\n');
threshold = 0.2;
[yclick xclick] = getClickFromMatches(img,ref_frame,frame,matches,threshold);

%sort results                                            
fprintf(1,'Suggested Click: frame:[%d], x:[%d], y:[%d]\n',1,xclick,yclick);



clicks(1,:) = [lastframe xclick1, yclick1];
clicks(2,:) = [lastframe xclick2, yclick2];

%figure; imshow(plotPoints(img2,clicks(:,2:3)));
    
end

