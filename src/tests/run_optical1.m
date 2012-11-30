
%% Task 1 level 1
num_images = 10;
optical_flow = cell(num_images-1,1);
for i=1:num_images-1;
    img1 = imread(['frame/t1l1/' num2str(i)   '.jpg']);
    img2 = imread(['frame/t1l1/' num2str(i+1) '.jpg']);
    optical_flow{i} = estimate_flow_interface(img1, img2, 'classic+nl-fast');
end
save ofdata_1-1 optical_flow

%% Task 1 level 2
num_images = 20;
optical_flow = cell(num_images-1,1);
for i=20:num_images-1;
    img1 = imread(['frame/t1l2/' num2str(i)   '.jpg']);
    img2 = imread(['frame/t1l2/' num2str(i+1) '.jpg']);
    optical_flow{i} = estimate_flow_interface(img1, img2, 'classic+nl-fast');
end
save ofdata_1-2 optical_flow

%% Task 1 level 3
num_images = 20;
optical_flow = cell(num_images-1,1);
for i=15:num_images-1;
    img1 = imread(['frame/t1l3/' num2str(i)   '.jpg']);
    img2 = imread(['frame/t1l3/' num2str(i+1) '.jpg']);
    optical_flow{i} = estimate_flow_interface(img1, img2, 'classic+nl-fast');
end
save ofdata_1-3 optical_flow

