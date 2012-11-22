function descriptors = mySIFTdescriptor2(img,keypoints)
%MYSIFTDESCRIPTOR2 Summary of this function goes here
%  Detailed explanation goes here


%initialize your output
gray_img = rgb2gray(img);
% parameters
num_angles = 8;                     %bins
num_bins = 4;                       %new window side
num_samples = num_bins * num_bins;  %new window area
patchSize = 16;                     %side area to compute over

% initialize descriptors to zero
descriptors = zeros(size(keypoints,1), num_samples * num_angles);

% for all patches
for i=1:size(keypoints,1)

    % YOUR CODE HERE: Calcuate the magnitude and orientation of gradient (
    % referred to by m and theta in Lowe's paper).
    % (i) Apply Gaussian Filter to the grey-scale image 'grey_img'.
    % NOTE: Make your gaussian to rescale the image to the keypoint of size
    % 10x10, in other words, use 10 as the filter size.
    % HINT: Use fspecial, imfilter
    
    xkey = round(keypoints(i,1));
    ykey = round(keypoints(i,2));
    scalekey = keypoints(i,3);
    orientkey = keypoints(i,4);
    
    H = fspecial('Gaussian',10,scalekey);
    filtered_img = imfilter(gray_img,H,'replicate');
    
    % (ii) Calculate vertical and horizontal gradient.
    % HINT: Use filter2 commmands, the 'replicate' option may be helpful in
    % dealing with the image boundary.
    
    kernel = [-1 0 1];
    dx = filter2(kernel,filtered_img,'same');
    dy = filter2(kernel',filtered_img,'same');
    
    % (iii) Calculate the magnitude and orientation of gradient.
    % NOTE: The rotation invariance nature of SIFT is achieved by using the
    % relative angle to the feature orientation as theta.
    I_mag = sqrt(dx.^2 + dy.^2); 
    %I_theta = mod(atan2(dy,dx)-orientkey,2*pi); %rotation invariant
    I_theta = mod(atan2(dy,dx),2*pi);            %rotation variant
    
    
    %I_theta(isnan(I_theta)) = pi/2;
    
    
    %%%END YOUR CODE%%%
    angle_step = 2 * pi / num_angles;
    angles = 0:angle_step:2*pi;

    % Find center of patch as defined by keypoint
    sample_x_t = round(keypoints(i,1));
    sample_y_t = round(keypoints(i,2));

    
    % YOUR CODE HERE: find window of pixels that contributes to this descriptor
    % HINT: The patchsize is even, so there will be one more pixels on one side
    % of the keyboint in each dimention, use the convention that one more
    % pixel should be used in the -inf direction in each dimention
    x_lo = xkey - (patchSize/2);
    x_hi = xkey + (patchSize/2)-1;
    y_lo = ykey - (patchSize/2);
    y_hi = ykey + (patchSize/2)-1;
    %%%END YOUR CODE%%%
    try
        % Extract the patch from a window around the keypoint    
        patch_mag = I_mag(y_lo:y_hi,x_lo:x_hi) .* fspecial('gaussian',patchSize, patchSize/2);
        patch_ang = I_theta(y_lo:y_hi,x_lo:x_hi);
    catch
       continue; % skip the point that is too close to the image boundary
    end
   
    
    % YOUR CODE HERE:
    % Now compute the orientation histograms and concatenate them into the
    % 128-length vector
    feature = zeros(1,num_angles*num_bins^2);
    % Use column-wise order for the 4x4 bins in the descriptor. For each
    % bin, calculate the histogram of 8 angle slots by directly summing up
    % the patch_mag of pixels whose patch_ang falls in each slot range.
    % HINT: use the convention that the ith (one indexed) slot represents 
    % angles >=angles(i) and <angles(i+1)
    
    
    bindex = 1;
    for y=1:patchSize
        for x=1:patchSize
            xbin = floor((x-1)/num_bins)+1;
            ybin = floor((y-1)/num_bins)+1;
            angbin = floor(patch_ang(x,y)/angle_step)+1;
            index = (ybin-1)*(num_angles*num_bins) + (xbin-1)*num_angles + angbin;
            feature(index) = feature(index) + patch_mag(x,y);
        end
    end
    
    %%%END YOUR CODE%%%
    
    % The computed feature is now the completed descriptor for that
    % particular interest point!
    descriptors(i,:) = feature;
end

% Normalization step:

% find indices of descriptors to be normalized (those whose norm is larger than 1)
tmp = sqrt(sum(descriptors.^2, 2));
normalize_ind = find(tmp > 1);

descriptors_norm = descriptors(normalize_ind,:);
descriptors_norm = descriptors_norm ./ repmat(tmp(normalize_ind,:), [1 size(descriptors,2)]);

% suppress large gradients
descriptors_norm(find(descriptors_norm > 0.2)) = 0.2;

% finally, renormalize to unit length
tmp = sqrt(sum(descriptors_norm.^2, 2));
descriptors_norm = descriptors_norm ./ repmat(tmp, [1 size(descriptors,2)]);

descriptors(normalize_ind,:) = descriptors_norm;





end

