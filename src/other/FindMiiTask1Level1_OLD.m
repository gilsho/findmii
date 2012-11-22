%%-----------------------------------------------------------------------%%
%                                                                         
% CS231A Project: Find Mii
%                              
% This function do the job for task 1, level 1
% PLEASE READ ALL COMMENTS CAREFULLY
%
% Huayan Wang huayanw@cs.stanford.edu
%
%%-----------------------------------------------------------------------%%

% You should create functions in a simiar format as this one to do the job
% for other tasks and levels. They should all be invoked in FindMiiMain().

% For the tasks or levels you are not doing, just comment the corresponding
% line in FindMiiMain(), and then do nothing. They will not be scored.

% You may call any other programs INSIDE this function, including Matlab
% functions or MEX files or executables compiled from your C++ OpenCV code
% (if you are using OpenCV). Call executables by 'system()'.

% The only requirement is that, you should return 'click' to FindMiiMain().

% NUMBER OF CLICKS REQUIRED !!!
% For task 1 (any level), you should only make 1 click.
% For task 2 (any level), you should make 2 clicks.
% For task 3, level 1, you should make 2 clicks.
% For task 3, level 2, you should make 3 clicks.
% For task 3, level 3, you should only make 1 click.
% For task 4 (any level), you should only make 1 click.

function click = FindMiiTask1Level1(datadir)

% The following are example code for you to do the job in matlab.

% Read the reference image, only do this for task 1 (all levels)
% Change filename for level 2 and 3
refImage = imread([datadir 'ref-task1level1.bmp']);

% We have 150 frames for task 1 level 1,
% change the number accordingly for other tasks and levels
mov_input = mmreader([datadir 't1l1.avi']);
for i=1:150
    
    % Read current frame, change file name for other tasks and levels
    %mov = read(, i);
    
    img = read(mov_input,i);
    
    % As a toy example, we make a random click
    if rand(1,1)<0.1
     
        y = rand(1,1) * size(img,1);
        x = rand(1,1) * size(img,2);
        
        click  = [i x y];
        
        % 'i' is the ID of frame you want to click
        % (x, y) is the position you want to click 
        % To make n clicks, the variable 'click' should be a n-by-3 matrix.
 
        % Use break to exit loop, so you don't access any frame hereafter
        break;
        
    end
    
    % Scoring: correct click on frame 1 is worth 1 point, each frame
    % thereafter is discounted by 0.99. Score is averaged over multiple
    % clicks if applicable. For example, if a task requires two clicks, you
    % return 1st click at frame 5, and 2nd click at frame 20 (both of them 
    % are correct), your score is (0.99^4 + 0.99^19)/2 = 0.8934. In this
    % case, you can NOT access any frame after frame 20. YOU CAN NOT EVEN
    % READ THEM INTO MEMORY, WE WILL BE ABLE TO CHECK THIS.
    
    % In other words, you can make use of the information from all
    % frames prior to your final click, but NOT thereafter.
    
end

