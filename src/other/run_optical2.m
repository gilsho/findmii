
%% Task 2 level 2
num_images = 20;
for j=1:num_images-1;
    i = 1+(j-1)*5;
    img1 = imread(['frame/t2l2/' num2str(i)   '.jpg']);
    img2 = imread(['frame/t2l2/' num2str(i+1) '.jpg']);
    optflow(j).flow = estimate_flow_interface(img1, img2, 'classic+nl-fast');
    optflow(j).frame1 = i;
    optflow(j).frame2 = i+1;
end
save ofdata_2-2 optflow


%% Task 2 level 3
num_images = 20;
for j=1:num_images-1;
    i = 1+(j-1)*5;
    img1 = imread(['frame/t2l3/' num2str(i)   '.jpg']);
    img2 = imread(['frame/t2l3/' num2str(i+1) '.jpg']);
    optflow(j).flow = estimate_flow_interface(img1, img2, 'classic+nl-fast');
    optflow(j).frame1 = i;
    optflow(j).frame2 = i+1;
end
save ofdata_2-3 optflow