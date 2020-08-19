%% Read Images
img1 = imread('image01.jpg');
img2 = imread('image02.jpg');
img3 = imread('image03.jpg');
img4 = imread('image04.jpg');
img5 = imread('image05.jpg');

%% Merge Image 1 and 2
tic
fprintf('Merging images 1&2....\n');
merge_12 = merge_images(img1,img2);
toc;
fprintf('Merging images 1&2 completed\n\n\n');

%% Merge Image 3 and 4
tic
fprintf('Merging images 3&4 ....\n');
merge_34 = merge_images(img3,img4);
toc;
fprintf('Merging images 3&4 completed\n\n\n');

%% Merge Image 34 and 5
tic
fprintf('Merging images 34&5 ....\n');
merge_345 = merge_images(merge_34,img5);
toc;
fprintf('Merging images 34&5 completed\n\n\n');

save('Results')
%% Merge Image 12 and 345
tic
fprintf('Merging images 12 & 345 ....\n');
merge_full = merge_images(merge_12,merge_345);
toc;
fprintf('Merging images 12 & 345 completed\n\n\n');
imwrite(merge_full, 'mosaic_3.png');