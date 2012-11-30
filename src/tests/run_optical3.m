
%% Task 3 level 1
num_images = 20;
optical_flow = cell(num_images-1,1);
for i=20:num_images-1;
    img1 = imread(['frame/t3l1/' num2str(i)   '.jpg']);
    img2 = imread(['frame/t3l1/' num2str(i+1) '.jpg']);
    optical_flow{i} = estimate_flow_interface(img1, img2, 'classic+nl-fast');
end
save ofdata_3-1 optical_flow

%% Task 3 level 2
num_images = 20;
optical_flow = cell(num_images-1,1);
for i=20:num_images-1;
    img1 = imread(['frame/t3l2/' num2str(i)   '.jpg']);
    img2 = imread(['frame/t3l2/' num2str(i+1) '.jpg']);
    optical_flow{i} = estimate_flow_interface(img1, img2, 'classic+nl-fast');
end
save ofdata_3-2 optical_flow

%% Task 3 level 3
num_images = 20;
optical_flow = cell(num_images-1,1);
for i=20:num_images-1;
    img1 = imread(['frame/t3l3/' num2str(i)   '.jpg']);
    img2 = imread(['frame/t3l3/' num2str(i+1) '.jpg']);
    optical_flow{i} = estimate_flow_interface(img1, img2, 'classic+nl-fast');
end
save ofdata_3-3 optical_flow

