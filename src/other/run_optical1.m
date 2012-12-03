
%% Task 1 level 3
clear all;
clc;

task = 2;
level = 3;
frame_start = 1;
frame_end = 150;
frame_interval = 1;

MAX_FRAME = 150;

fprintf('Running script with Task: [%d], Level: [%d], start frame: [%d], end frame: [%d], interval: [%d]\n',...
            task,level,frame_start,frame_end,frame_interval);
for j=frame_start:frame_end
    if (j+frame_interval > MAX_FRAME)
        break;
    end
    fprintf('Claculating optical flow between frames %d and %d...\n',...
        j,j+frame_interval);
    img1 = imread(['frame/t1l3/' num2str(j)   '.jpg']);
    img2 = imread(['frame/t1l3/' num2str(j+frame_interval) '.jpg']);
    flow = estimate_flow_interface(img1, img2, 'classic+nl-fast');
    filename = ['optflow_' num2str(task) '_' num2str(level) '_'...
                num2str(frame_start) ' ' num2str(frame_interval) '.mat'];
    save(filename);
end
fprintf('done.\n');

