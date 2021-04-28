function [timg, RB] = trans(img,H,refsize)
%     s = size(img);
%     tx = zeros(s(1:2)); % preparing a transform matrix of twice size in x and yinterp2
%     ty = zeros(s(1:2)); % preparing a transform matrix of twice size in x and yinterp2
%     ox = zeros(s(1:2));
%     oy = zeros(s(1:2));
%     %timg = img;
%     Hinv = inv(H);
%     for i = 1:s(1)
%         for j = 1:s(2)
%            ox(i,j) = i;
%            oy(i,j) = j;
%            p = Hinv*[i;j;1];
%            tx(i,j) = p(1);
%            ty(i,j) = p(2);
%         end
%     end
%     timg = interp2(ox,oy,img,tx,ty,'cubic');
    %H = H';% using transpose of Homography matrix here in case of error check this\
    %H
    RA = imref2d(refsize);
    tform = projective2d(inv(H')); %Transpose is required as multiplication in imwarp is X*H and X is a row vector
    [timg, RB] = imwarp(img,RA,tform,'cubic');
    
%     imshow(img);
%     figure
%     imshow(timg);
end