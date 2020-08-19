function match = compute_matches(image1,image2)
%% Compute and return the matching points between image 1
% and image 2 using SIFT. Outout contains nx4 matrix data
% n - represents number of points matches between image 1 and 2
% 4 - Number of columns: columns 1-2: Point in image 1, columns 3-4: points in image 2

    % Read and convert the image to single precision
    I1 = single(rgb2gray(image1));
    I2 = single(rgb2gray(image2));
    
    % Compute SIFT Features
    [f1,d1] = vl_sift(I1);
    [f2,d2] = vl_sift(I2);
    
    % Feature matching between image 1 and image2, with threshold of 3
    [matches, ~] = vl_ubcmatch(d1,d2,3);
    matches = matches';
    s = size(matches);
    match = zeros(s(1),4);
    f1 = f1';
    f2 = f2';
    f1_c = f1(:,1:2);
    f2_c = f2(:,1:2);
    match(:,1:2) = f1_c(matches(:,1),:);
    match(:,3:4) = f2_c(matches(:,2),:);
end