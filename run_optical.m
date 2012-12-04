
function run_optical(task,level,frame_start,frame_end,frame_interval)

run('startup');

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
                num2str(j) ' ' num2str(frame_interval) '.mat'];
    save(filename);
end
fprintf('done.\n');

end
