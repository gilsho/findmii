%%-----------------------------------------------------------------------%%
%                                                                         
% CS231A Project: Find Mii
%                              
% This function is for you to view the task movie with groundtruth overlaid
%
% Huayan Wang huayanw@cs.stanford.edu
%
%%-----------------------------------------------------------------------%%

% You do NOT have to modify this file.

% Example Usage:

% PlayMii('data/t4l3.avi', 'gt/t4l3.gt'); 

% To use this, you need to ssh with -X and run matlab with full display.
% Make sure the avi file and the gt(groundtruth) file match.

% The video will be played with box(es) overlaid, indicating the range in
% which your click would be considered correct. Generally, a valid click
% should be on the head of the target Mii (even for task 3 level 3, where
% the target Mii is identified by odd footsteps instead of head appearance).

% You can see that for some tasks and levels, the target Mii does not
% always show up throughout the video. In this case, you can NOT assume
% that the target Mii would show up at the beginning of our test video.
% However for some tasks and levels, you CAN make such an assumption, watch
% the task videos and figure out for yourself.


function PlayMii(avifile, gtfile)
figure
boxes = load(gtfile);
mov_input = mmreader(avifile)
for i=1:size(boxes,1);
    img = read(mov_input,i); 
    hold off
    imshow(img);
    hold on
    for j=1:size(boxes,2)/4
        x = boxes(i,(j-1)*4+1);
        y = boxes(i,(j-1)*4+2);
        width = boxes(i,(j-1)*4+3);
        height = boxes(i,(j-1)*4+4);
        plot([ x x x+width x+width; x x+width x x+width], ...
            [ y y y+height y+height; y+height y y+height y], ...
            'LineWidth',2,'color','green');
    end
    pause(0.01);
end