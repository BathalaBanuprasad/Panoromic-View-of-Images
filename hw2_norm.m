function c = hw2_norm(a)
s = size(a);
c = 0;
for i = 1:s(1)
  c = c+norm(a(i,1:2));  
end
c = c/s(1);
end