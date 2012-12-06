

function clicks = FindMiiTask3Level1(datadir)
clicks = zeros(2,3);

MAX_FRAME = 150;

% change the number accordingly for other tasks and levels
mov_input = mmreader([datadir 't3l1.avi']);



%hardcoded faces coordinates
%      ylow  yhigh  xlow xhigh
bbox = [95    152   108   162
        99    152   220   275
        97    151   330   384
        94    153   442   501
        97    153   553   606
        144   199   162   214
        138   195   275   326
        138   197   389   445
        138   198   502   557
        182   244    89   156
        184   243   212   270
        186   245   327   384
        184   243   443   503
        184   245   566   627
        230   294   152   210
        230   300   269   329
        233   294   387   450
        234   297   511   573];
    
numfaces = size(bbox,1);
lastframe = 1;
CONFIDENCE_THRESHOLD = 1.5;
confidence = 0;
while ((confidence < CONFIDENCE_THRESHOLD) && (lastframe < MAX_FRAME))
    lastframe=lastframe+1;
    fprintf('Examining frame %d/%d...\n',lastframe,MAX_FRAME);
    img1 = read(mov_input,lastframe-1);
    img2 = read(mov_input,lastframe);

    %CALCULATING OPTICAL FLOW
    fprintf('Calculating optical flow for faces...\n');              
    faces = cell(numfaces,2);
    fmotion = zeros(numfaces,2);
    fuv = cell(numfaces,1);
    for i=1:numfaces

        fprintf('.');
        faces{i,1} = img1(bbox(i,1):bbox(i,2),bbox(i,3):bbox(i,4),:);
        faces{i,2} = img2(bbox(i,1):bbox(i,2),bbox(i,3):bbox(i,4),:);
        
        uv = estimate_flow_interface(faces{i,1}, faces{i,2}, 'classic+nl-fast');
        fuv{i} = uv(:,:,1);
        fmotion(i,1) = sum(sum(uv(:,:,1) > 0));
        fmotion(i,2) = sum(sum(uv(:,:,1) < 0));
        fmotion(i,:) = fmotion(i,:)./sum(sum(fmotion));
    end
    fprintf('\n');
    
    MOTION_THRESHOLD = 1.5;
    %DETERMINE MOTION
    avg_xmag = 0;
    for i=1:numfaces
       avg_xmag = avg_xmag + max(max(fuv{1})); 
    end
    avg_xmag = avg_xmag ./ numfaces;
    
    if (avg_xmag < MOTION_THRESHOLD)
       fprintf('no motion detected.\n');
       confidence = 0;
       continue;
    end
    
    %DETERMINING ODD SIDE
    orient = zeros(size(fmotion));
    orient(:,1) = fmotion(:,1) > fmotion(:,2);
    orient(:,2) = fmotion(:,2) > fmotion(:,1);
    
     minority_orientation = 1;
    if (sum(orient(:,1)) > sum(orient(:,2)))
        minority_orientation = 2;
    end
    MINORITY_THRESHOLD = 4;
    if (sum(orient(:,minority_orientation)) > MINORITY_THRESHOLD)
        confidence = 0;
        fprintf('Did not detect minority orientation!\n');
        continue;
    end
    
    %DETERMINE FACES
    motion_mag = zeros(size(numfaces),1);
    for i=1:numfaces
       motion_mag(i) = fmotion(i,1)/fmotion(i,2);
    end


    if (sum(orient(:,2)) < sum(orient(:,1)))
       motion_mag = 1./motion_mag;
    end

    [motion_mag_sorted,rank] = sort(motion_mag,'Descend');

    findex1 = rank(1);
    findex2 = rank(2);
    
    confidence = motion_mag_sorted(2);
    
end

if (confidence >= CONFIDENCE_THRESHOLD)
    xclick1 = (bbox(findex1,3)+bbox(findex1,4))/2;
    yclick1 = (bbox(findex1,1)+bbox(findex1,2))/2;

    xclick2 = (bbox(findex2,3)+bbox(findex2,4))/2;
    yclick2 = (bbox(findex2,1)+bbox(findex2,2))/2;

    clicks(1,:) = [lastframe xclick1 yclick1];
    clicks(2,:) = [lastframe xclick2 yclick2];
end

%PLOT RESULTS
fprintf(1,'Suggested Click: frame:[%d], x:[%d], y:[%d]\n',lastframe,xclick1,yclick1);
fprintf(1,'Suggested Click: frame:[%d], x:[%d], y:[%d]\n',lastframe,xclick2,yclick2);
%figure; imshow(plotPoints(img2,clicks(:,2:3)));


end

