function mask = textureMask(imgbw)

%figure;
for i=1:9
    %subplot(3,3,i);
    %imagesc(filter2(filters{i},imgbw));
end


neighborhood = 50;
[m,n] = size(imgbw);
frequency = zeros(m,n);
progbar = 0;

for i=neighborhood/2+1:m-neighborhood/2
    if (i*100/m > progbar)
       progbar=progbar+5;
       fprintf('.');
    end
    for j=neighborhood/2+1:n-neighborhood/2
       ystart=max(i+1-neighborhood/2,1);
       yend=min(i+neighborhood/2,m);
       xstart=max(j+1-neighborhood/2,1);
       xend=min(j+neighborhood/2,n);
       img_portion = imgbw(ystart:yend,xstart:xend);
       ftrans = fft2(double(img_portion));
       frequency(i,j) = ...
           sum(sum(abs(ftrans)));
    end
end
fprintf('\n');

%figure; subplot(2,1,1); imshow(img); subplot(2,1,2); imagesc(results);

threshold = 4000;
mask = (frequency > threshold);
%figure; subplot(2,1,1); imshow(img); subplot(2,1,2); imagesc(mask);


end

