function tf = isIn(v,A)
% determine if 1xM array v is a row in NxM array V
tf = 0;
for i = 1:size(A,1)
    if A(i,:) == v
        tf = 1;
    end
end
end
