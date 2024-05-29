function [w,d] = bincount(w0,d0)
% given series of support points d0 with weights d0
d = [];
j = 1;

for i = 1:size(d0,1)
    if isIn(d0(i,:),d) == 0
        d(j,:) = d0(i,:);
        j = j + 1;
    end
end

w = zeros(size(d,1),1);

for i = 1:size(d,1)

    cur = d(i,:);
    
    for j = 1:size(d0,1)
        if cur == d0(j,:)
            w(i) = w(i) + w0(j);
        end
    end

end