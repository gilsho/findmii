function descriptors = enhancedSIFT(img,frames)


%compute descriptors for every channel separately
[m,n,channels] = size(img);

descriptors = [];
for ch=1:channels
    [~,desc] = vl_covdet(single(img(:,:,ch)),'Frames',frames);
    descriptors = [descriptors; desc];
end

return;

%add average intensity of every bin
[~,num_frames] = size(frames);
desc_addon = zeros(5,num_frames);
for fr=1:num_frames
    x = round(frames(1,fr));
    y = round(frames(2,fr));
    scale = frames(3,fr);
    th = frames(4,fr);
    
    reg = ceil(5*scale); %region size
    for ch=1:channels
        miny = max(1,y-reg+1); 
        minx = max(1,x-reg+1);
        maxy = min(m,y+reg);
        maxx = min(n,x+reg);
        desc_addon(1,fr) = mean(mean(img(miny:y,minx:x)))/100;
        desc_addon(2,fr) = mean(mean(img(y+1:maxy,minx:x)))/100;
        desc_addon(3,fr) = mean(mean(img(miny:y,x+1:maxx)))/100;
        desc_addon(4,fr) = mean(mean(img(y+1:maxy,x+1:maxx)))/100;
        desc_addon(5,fr) = mean(mean(img(miny:maxy,minx:maxx)))/100;
    end
    
end

descriptors = [descriptors; desc_addon];

end

