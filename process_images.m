function [merged,Rm,H, shift] = process_images(img1, R1, H_prev, img2, match, apply_tf_left)
%% Compute homography between images, apply transformation and merge images

    %% Compute mean of sample points (x,y) to get (x',y')
    m1 = [mean(match(:,1)),mean(match(:,2))];
    m2 = [mean(match(:,3)),mean(match(:,4))];
    
    % Computing reduction of mean matrix
    T11 = [1,0,-m1(1);0,1,-m1(2);0,0,1];
    T12 = [1,0,-m2(1);0,1,-m2(2);0,0,1];
    
    % Obtain projective form of data points
    s12 = size(match);
    p12_1 = ones(s12(1),3); %projective form of all matched points in image 1
    p12_2 = ones(s12(1),3); %projective form of all matched pts in img 2
    p12_1(:,1:2) = match(:,1:2);
    p12_2(:,1:2) = match(:,3:4);
    
    % Apply mean transformation in data points
    m_p12_1 = p12_1*T11'; %(x',y',1)
    m_p12_2 = p12_2*T12'; %(x',y',1)  
    
    %% Compute variance transformation matrix on (x',y') to get (x",y")
    c1 = sqrt(2)/hw2_norm(m_p12_1);
    c2 = sqrt(2)/hw2_norm(m_p12_2);
    
    % Variance transformation matrix
    T21 = [c1 0 0; 0 c1 0; 0 0 1];
    T22 = [c2 0 0; 0 c2 0; 0 0 1];
    
    % Apply variance transformation
    c_p12_1 = m_p12_1*T21'; %(x",y",1)
    c_p12_2 = m_p12_2*T22'; %(x",y",1)
    
    %% Computing equivalent tranformation of T11,T21
    T1 = T21*T11;
    T2 = T22*T12;
    
    
    %% Compute Homography between the points c_p12_1 and c_p12_2
    %% RANSAC
    p = 0.9999; %Desired accuracy
    w = 0.6; %Accuracy of inliers in SIFT algorithm
    n = 5; %Minimum number of inliers required to compute homography
    bestH = zeros(1,9);
    besterror = Inf;
    k = ceil(log(1-p)/log(1-w^n));
    s_12 = size(match);
    
    % Iterate RANSAC algo for k iterations 
    for i = 1:k
        perm = randperm(s_12(1),n);
        m1 = c_p12_1(perm,:);
        m2 = c_p12_2(perm,:);
        
        %All inliers
        a1 = c_p12_1;
        a2 = c_p12_2;
        currentError = 0;
        
        % compute homography
        [h,~] = homo(m1,m2);
        for j = 1:s_12(1)
            %a1(j,:)
            if ~ismember(a1(j,:), m1, 'rows') %Checking correctness of homography
                                        %by comparing with other points
               %i,j
               x11 = a1(j,1);
               y11 = a1(j,2);
               x22 = a2(j,1);
               y22 = a2(j,2);
               a = [x11 y11 1 0 0 0 -x11*x22 -y11*x22 -x22];
               b = [0 0 0 x11 y11 1 -x11*y22 -y11*y22 -y22];
               e1 = abs(dot(a,h));
               e2 = abs(dot(b,h));
               currentError = currentError + (e1+e2);
            end
        end

        if(currentError < besterror)
            bestH = h;
            besterror = currentError;
        end
        
    end
    h = bestH;
    H1 = [h(1:3);h(4:6);h(7:9)];
    H = (T2\H1)*T1;%inv(T2)*H1*T1;%Obtaining homography after removing mean and variance

%% Bring img2 into plane of img1
H = H/H(3,3);

%% Merge Two images
if ~apply_tf_left
    %% Removing previous image H
[timg2, R2] = trans(img2,H,size(img2));
[C, RC] = imfuse(img1, R1, timg2, R2, 'blend', 'Scaling', 'joint');
else 
   [timg1,R_temp] = trans(img1,H,size(img1));
   [C,RC] = imfuse(timg1,R_temp,img2,R1, 'blend', 'Scaling', 'joint');
   timg2 = timg1;
end

merged = C;
Rm = RC;

%% Compute linear shift between image 1 and image 2
shift1 = p12_2*inv(H)' - p12_1;
hs = mean(shift1(:,1));
ws = mean(shift1(:,2));
shift = [hs, ws];
end