function mask = imageDifferenceMask(img,bg,bgthresh)
%SUBTRACTBACKGROUND Summary of this function goes here
%   Detailed explanation goes here

[m,n,~] = size(img);

bgdiff = double(img) - double(bg);
bgdiffnorm = zeros(m,n);

fprintf('performing background subtraction');
progbar = 0;
for i=1:m
    if (i*100/m > progbar)
       progbar = progbar + 5;
       fprintf('.');
    end
    for j=1:n
        bgdiffnorm(i,j) = norm(squeeze(bgdiff(i,j,:)));
    end
end
fprintf('\n');

mask = bgdiffnorm > bgthresh;

end

