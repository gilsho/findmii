function clicks = FindMiiTask4Level3(datadir)
clicks = zeros(1,3);

mov_input = mmreader([datadir 't4l3.avi']);

y_displacement_factor = [100.4514 0.2655];
x_displacement_factor = [23.2733 0.1131];

MAX_FRAME = 150;

frame_interval = 2; %1 or 2 frames. currently 2 seems better
lastframe = 2; 
consecutive_click_count = 0;

HISTORY = 10;
click_history = zeros(HISTORY,5);

while (lastframe < MAX_FRAME)
    lastframe = lastframe + 1;
    %fprintf('Examining frame %d/%d...\n',lastframe,MAX_FRAME);
    img1 = read(mov_input,lastframe-frame_interval); 
    img2 = read(mov_input,lastframe);
    [m,n,~] = size(img1);

    %fprintf(1,'Computing SIFT features image...\n');
    img1bw = im2single(rgb2gray(img1));
    [frames1, descriptors1] = vl_covdet(img1bw,'method', 'DoG');
    
    img2bw = im2single(rgb2gray(img2));
    [frames2, descriptors2] = vl_covdet(img2bw,'method', 'DoG');

    
    %MATCH KEYPOINTS
    %fprintf(1,'Matching keypoints...');
    threshold = 0.5;
    matches12 = matchKeypoints(descriptors1, descriptors2, threshold);

    
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

 
    %img4 = highlightCircle(img2,[yclick xclick],5,2,1,[0,255,0]);
    %imshow(img4);
    DISPLACEMENT_THRESHOLD = 13;
    if (maxval > DISPLACEMENT_THRESHOLD)
        fprintf('significant motion detected!\n');
        click_info = [xclick, yclick, displacement12(maxindex,2),...
            displacement12(maxindex,3),lastframe];
    else
        click_info = [0, 0, 0, 0, lastframe];
    end
    
    click_history = [click_info; click_history(1:HISTORY-1,:)];

    %COMPARE TO LAST CLICK POINT
    SCORE_THRESHOLD = 0.5;
    [yclick,xclick,score] = getClickFromHistory(img2,click_history);
    fprintf('score: [%.2f]\n',score);
    if (score > SCORE_THRESHOLD)
        clicks = [lastframe xclick yclick];
        break;
    end 
    
    %img4 = highlightCircle(img4,[yclick xclick],5,2,1,[255,0,0]);
    %imshow(img4);
    
end

fprintf(1,'Suggested Click: frame:[%d], x:[%d], y:[%d]\n',...
    lastframe,xclick,yclick);

%PLOT RESULTS
%figure; imshow(plotPoints(img2,clicks(1,2:3s)));

end



