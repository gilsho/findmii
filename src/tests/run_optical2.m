
%% Task 2 level 1
num_images = 20;
optical_flow = cell(num_images-1,1);
for i=20:num_images-1;
    img1 = imread(['frame/t2l1/' num2str(i)  '.jpg']);
    img2 = imread(['frame/t2l1/' num2str(i+1) '.jpg']);
    optical_flow{i} = estimate_flow_interface(img1, img2, 'classic+nl-fast');
end
save ofdata_2-1 optical_flow

%% Task 2 level 2
num_images = 20;
optical_flow = cell(num_images-1,1);
for i=20:num_images-1;
    img1 = imread(['frame/t2l2/' num2str(i)   '.jpg']);
    img2 = imread(['frame/t2l2/' num2str(i+1) '.jpg']);
    optical_flow{i} = estimate_flow_interface(img1, img2, 'classic+nl-fast');
end
save ofdata_2-2 optical_flow

%% Task 2 level 3
num_images = 5;
optical_flow = cell(num_images-1,1);
for i=20:num_images-1;
    img1 = imread(['frame/t2l3/' num2str(i)   '.jpg']);
    img2 = imread(['frame/t2l3/' num2str(i+1) '.jpg']);
    optical_flow{i} = estimate_flow_interface(img1, img2, 'classic+nl-fast');
end
save ofdata_2-3 optical_flow

