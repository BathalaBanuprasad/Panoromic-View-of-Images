function [h,A] = homo(p1,p2)
%% Compute homography between sets p1 and p2

s = size(p1);
n = s(1);
A = zeros(2*n,9);

%% Compute A
for i = 1:n
   % b = ['index: ', num2str(i)];
   x11 = p1(i,1);
   y11 = p1(i,2);
   x22 = p2(i,1);
   y22 = p2(i,2);
   A(2*i-1,:) = [x11 y11 1 0 0 0 -x11*x22 -y11*x22 -x22];
   A(2*i,:) = [0 0 0 x11 y11 1 -x11*y22 -y11*y22 -y22];
end

%% Estimate homography h through A'*A
B = A'*A;
[V,D] = eig(B);
[d,ind] = sort(diag(D));
Ds = D(ind,ind);
Vs = V(:,ind);
h = Vs(:,1)';
end