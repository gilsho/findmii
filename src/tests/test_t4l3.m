
%function clicks = FindMiiTask4Level2(datadir)
datadir = 'data/';
clicks = zeros(1,3);

mov_input = mmreader([datadir 't4l3.avi']);

y_displacement_factor = [100.4514 0.2655];
x_displacement_factor = [23.2733 0.1131];

MAX_FRAME = 150;

frame_interval = 1; %1 or 2 frames. currently 2 seems better
lastframe = 1; 
consecutive_click_count = 0;
last_click_info = zeros(1,4);
while (lastframe < MAX_FRAME)
    lastframe = lastframe + 1;
    %fprintf('Examining frame %d/%d...\n',lastframe,MAX_FRAME);
    %img1 = read(mov_input,lastframe-2*frame_interval); 
    img2 = read(mov_input,lastframe-frame_interval);
    img3 = read(mov_input,lastframe);
    [m,n,~] = size(img1);

    %fprintf(1,'Computing the SIFT features for face in reference image...\n');
    img1bw = im2single(rgb2gray(img1));
    [frames1, descriptors1] = vl_covdet(img1bw,'method', 'DoG');
    
    %CALCULATE OPTICAL FLOW
    %fprintf('Calculating optical flow...\n');
    %uv12 = estimate_flow_interface(img1, img2, 'classic+nl-fast');
    %uv23 = estimate_flow_interface(img2, img3, 'classic+nl-fast');
    
    img2bw = im2single(rgb2gray(img2));
    [frames2, descriptors2] = vl_covdet(img2bw,'method', 'DoG');
    
    img3bw = im2single(rgb2gray(img2));
    [frames3, descriptors3] = vl_covdet(img3bw,'method', 'DoG');
    
    %MATCH KEYPOINTS
    %fprintf(1,'Matching keypoints...');
    threshold = 0.5;
    matches12 = matchKeypoints(descriptors1, descriptors2, threshold);
    matches23 = matchKeypoints(descriptors2, descriptors3, threshold);

    
    %PLOT MATCHES
    if (numel(matches12) > 1)
        %figure;
        %plotmatches(im2double(img1),im2double(img2),frames1,frames2,...
        %            matches12);
    else
        fprintf('No matches found!');
    end
    %fprintf('\n');
    
    %EXTRACT DISPLACEMENT
    yscale = y_displacement_factor(1) + (1:m)'*y_displacement_factor(2);

    xscale = x_displacement_factor(1) + (1:n)'*x_displacement_factor(2);
    num_matches = size(matches12,2);
    MAX_DIST = 50;
    displacement12 = [];
    for i=1:num_matches
        x1 = frames1(1,matches12(1,i));
        y1 = frames1(2,matches12(1,i));
        x2 = frames2(1,matches12(2,i));
        y2 = frames2(2,matches12(2,i));
        ydisp = (y2-y1);%./yscale(round(y1));
        xdisp = (x2-x1);%./xscale(round(x1));
        dist = sqrt(xdisp.^2+ydisp.^2);
        orient = atan2(ydisp,xdisp);
        if (dist < MAX_DIST)
            displacement12 = [displacement12; ...
                             matches12(2,i), orient, dist];
        end
    end
    
    %FIND KEYPOINT WITH MAXIMAL DISPLACEMENT
    [maxval, maxindex] = max(displacement12(:,3));
   
    frame_index = displacement12(maxindex,1);
    xclick = frames2(1,frame_index);
    yclick = frames2(2,frame_index);
    
    fprintf('frame:[%d].x:[%d], y:[%d] orient:[%d], disp:[%d]\n',...
        lastframe,xclick,yclick,displacement12(maxindex,2),...
        displacement12(maxindex,3));
    
    DISPLACEMENT_THRESHOLD = 17;
    if (maxval > DISPLACEMENT_THRESHOLD)
        fprintf('significant motion detected!\n');
    else
        consecutive_click_count = 0;
        continue;
    end
    
    weight = [1 1 10 10];
    click_info = weight.*[xclick, yclick, displacement12(maxindex,2),...
        displacement12(maxindex,2)];
    
    img4 = highlightCircle(img2,[yclick xclick],5,2,1,[0,255,0]);
    imshow(img4);
    
    %COMPARE TO LAST CLICK POINT
    CLICK_DIFF_THRESHOLD = 5;
    click_diff = norm(click_info - last_click_info);
    last_click_info = click_info;
    if (click_diff < CLICK_DIFF_THRESHOLD)
        consecutive_click_count = consecutive_click_count + 1;
        fprintf('%d consecutive clicks on target\n', ...
            consecutive_click_count);
    else
        consecutive_click_count = 0;
    end
    
    MIN_CONSECUTIVE = 3;
    if (consecutive_click_count > 3)
        clicks = [lastframe xclick yclick];
        break;
    end
end

ClickMii([datadir 't4l3.avi'], ['gt/' 't4l3.gt'], clicks)

fprintf(1,'Suggested Click: frame:[%d], x:[%d], y:[%d]\n',...
    lastframe,xclick,yclick);

%PLOT RESULTS
img4 = highlightCircle(img4,[yclick xclick],5,2,1,[0,255,0]);
%%figure; imshow(img4);

%end
