function merged = merge_images(img1,img2)
%% Compute matches b/w images and merge images

% Compute size reference of image 1
R1 = imref2d(size(img1));

% find matches between the two images
match12 = compute_matches(img1,img2);

% Merge two images based on matching, match12
[merged,~, H, ~] = process_images(img1,R1,eye(3),img2,match12,0);
H
fprintf('\n\n\n')

% Display merged image
figure
imshow(merged); 
end