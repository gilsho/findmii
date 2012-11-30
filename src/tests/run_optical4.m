
%% Task 4 level 1
num_images = 20;
optical_flow = cell(num_images-1,1);
for i=20:num_images-1;
    img1 = imread(['frame/t4l1/' num2str(i)   '.jpg']);
    img2 = imread(['frame/t4l1/' num2str(i+1) '.jpg']);
    optical_flow{i} = estimate_flow_interface(img1, img2, 'classic+nl-fast');
end
save ofdata_4-1 optical_flow

%% Task 4 level 2
num_images = 20;
optical_flow = cell(num_images-1,1);
for i=20:num_images-1;
    img1 = imread(['frame/t4l2/' num2str(i)   '.jpg']);
    img2 = imread(['frame/t4l2/' num2str(i+1) '.jpg']);
    optical_flow{i} = estimate_flow_interface(img1, img2, 'classic+nl-fast');
end
save ofdata_4-2 optical_flow

%% Task 4 level 3
num_images = 20;
optical_flow = cell(num_images-1,1);
for i=20:num_images-1;
    img1 = imread(['frame/t4l3/' num2str(i)   '.jpg']);
    img2 = imread(['frame/t4l3/' num2str(i+1) '.jpg']);
    optical_flow{i} = estimate_flow_interface(img1, img2, 'classic+nl-fast');
end
save ofdata_4-3 optical_flow

