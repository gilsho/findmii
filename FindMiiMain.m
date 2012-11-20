%%-----------------------------------------------------------------------%%
%                                                                         
% CS231A Project: Find Mii
%                              
% This function is the main interface for the project.
% PLEASE READ ALL COMMENTS CAREFULLY
%
% Huayan Wang huayanw@cs.stanford.edu
%
%%-----------------------------------------------------------------------%%

% This function is the main interface for the project. We will be running
% it to get the final results of your project to score. Make sure it runs
% and invokes all parts of your project properly.

% Even if you plan to do the project in C++ and OpenCV, you should also be
% using this Matlab interface. See the comments in FindMiiTask1Level1().

% Example Usage:
% FindMiiMain('/afs/ir/class/cs231a/findmii/')

% Make sure to include the '/' at the end of the path.

function FindMiiMain(dir)

datadir = [dir 'data/'];
click = FindMiiTask1Level1(datadir);

ClickMii([datadir 't1l1.avi'], [dir 'gt/' 't1l1.gt'], click);

% ClickMii() will save an image (for each click you made) showing the frame 
% you clicked on, with a red circle overlaid, centering at your click, and
% also a green box, showing the ground truth. We save it as an image
% instead of showing it in a figure so that you will be able to work in 
% Matlab with command line only.

% IMPORTANT: DUE TO REASONS, IF YOU USE RANDOM NUMBER GENERATOR IN ANY PART 
% OF YOUR ALGORITHM, USE A FIXED SEED SUCH THAT YOUR PROGRAM WOULD RETURN
% IDENTICAL RESULTS IF CALLED MULTIPLE TIMES IN THIS FUNCTION. 
%(In this regard, our current example code in FindMiiTask1Level1() is not 
% valid. Try it yourself.)


%%------------------------------------------------------------------------
% Uncomment the following to do other tasks and levels
% YOU ARE ONLY ALLOWED TO COMMENT AND UNCOMMENT THE FUNCTIONS BELOW
% DO NOT MODIFY THIS FILE IN OTHER WAYS (For example, if you want to do task 2
% level 3 with your OpenCV program, you should first create the Matlab function
% FindMiiTask2Level3.m, call your OpenCV progrom in it, uncomment the
% corresponding line below, and your result should be returned in 'click'.)

% click = FindMiiTask1Level2(datadir);
% click = FindMiiTask1Level3(datadir);
% click = FindMiiTask2Level1(datadir);
% click = FindMiiTask2Level2(datadir);
% click = FindMiiTask2Level3(datadir);
% click = FindMiiTask3Level1(datadir);
% click = FindMiiTask3Level2(datadir);
% click = FindMiiTask3Level3(datadir);
% click = FindMiiTask4Level1(datadir);
% click = FindMiiTask4Level2(datadir);
% click = FindMiiTask4Level3(datadir);

