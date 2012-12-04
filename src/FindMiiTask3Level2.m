function clicks = FindMiiTask3Level2(datadir)

clicks = zeros(3,3);

MAX_FRAME = 150;

% change the number accordingly for other tasks and levels
mov_input = mmreader([datadir 't3l2.avi']);

%hardcoded faces coordinates
%      ylow  yhigh  xlow xhigh
bbox = [121  167  126  165 
        124  169  195  239 
        123  165  270  311 
        123  168  341  383 
        120  166  408  454 
        121  167  478  524 
        119  167  545  592 
        157  203   87  130 
        154  199  159  201 
        155  201  230  275 
        155  202  302  348 
        153  201  372  418 
        151  200  442  485 
        155  201  516  559 
        151  199  588  629 
        189  238  114  158 
        187  236  191  232 
        188  236  260  310 
        188  234  334  381 
        186  236  411  459 
        185  236  483  530 
        187  234  552  603 
        221  276   70  117 
        221  271  148  201 
        225  269  224  266
        225  269  298  345 
        225  271  375  415 
        225  270  451  494 
        225  269  524  570 
        222  271  599  645 
        259  311  105  158 
        261  312  184  231 
        258  308  258  308 
        260  310  337  385 
        262  308  412  460 
        261  308  489  539 
        259  308  566  615 ];
        
numfaces = size(bbox,1);
lastframe = 1;
MINORITY_THRESHOLD = 6;
CONFIDENCE_THRESHOLD = 1.5;
confidence = 0;
while ((confidence < CONFIDENCE_THRESHOLD) && (lastframe < MAX_FRAME))
    
    lastframe=lastframe+1;
    fprintf('Examining frame %d/%d...\n',lastframe,MAX_FRAME);
    img1 = read(mov_input,lastframe-1);
    img2 = read(mov_input,lastframe);

    %CALCULATING OPTICAL FLOW
    fprintf('calculating optical flow for faces');      
    faces = cell(numfaces,2);
    fmotion = zeros(numfaces,2);
    facesuv = cell(numfaces,1);
    for i=1:numfaces
        fprintf('.');
        faces{i,1} = img1(bbox(i,1):bbox(i,2),bbox(i,3):bbox(i,4),:);
        faces{i,2} = img2(bbox(i,1):bbox(i,2),bbox(i,3):bbox(i,4),:);
        uv = estimate_flow_interface(faces{i,1}, faces{i,2}, 'classic+nl-fast');
        fmotion(i,1) = sum(sum(uv(:,:,1) > 0));
        fmotion(i,2) = sum(sum(uv(:,:,1) < 0));
        fmotion(i,:) = fmotion(i,:)./sum(sum(fmotion));
        facesuv{i} = uv;
    end
    fprintf('\n');

    %DETERMINE ODD SIDE
    orient = zeros(size(fmotion));
    orient(:,1) = fmotion(:,1) > fmotion(:,2);
    orient(:,2) = fmotion(:,2) > fmotion(:,1);

    minority_orientation = 1;
    if (sum(orient(:,1)) > sum(orient(:,2)))
        minority_orientation = 2;
    end
    sum(orient(:,minority_orientation))
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
    findex3 = rank(3);
    
    confidence = motion_mag_sorted(3);

end

if (confidence >= CONFIDENCE_THRESHOLD)

    xclick1 = (bbox(findex1,3)+bbox(findex1,4))/2;
    yclick1 = (bbox(findex1,1)+bbox(findex1,2))/2;

    xclick2 = (bbox(findex2,3)+bbox(findex2,4))/2;
    yclick2 = (bbox(findex2,1)+bbox(findex2,2))/2;

    xclick3 = (bbox(findex3,3)+bbox(findex3,4))/2;
    yclick3 = (bbox(findex3,1)+bbox(findex3,2))/2;
    
    clicks(1,:) = [lastframe xclick1 yclick1];
    clicks(2,:) = [lastframe xclick2 yclick2];
    clicks(3,:) = [lastframe xclick3 yclick3];
end

%PLOT RESULTS
fprintf(1,'Suggested Click: frame:[%d], x:[%d], y:[%d]\n',lastframe,xclick1,yclick1);
fprintf(1,'Suggested Click: frame:[%d], x:[%d], y:[%d]\n',lastframe,xclick2,yclick2);
fprintf(1,'Suggested Click: frame:[%d], x:[%d], y:[%d]\n',lastframe,xclick3,yclick3);
%figure; imshow(plotPoints(img2,clicks(:,2:3)));


end

