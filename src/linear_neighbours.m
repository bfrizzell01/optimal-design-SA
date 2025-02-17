function xn = linear_neighbours(x,delta,k)
% for a vector x of n entries, get an evenly spaced neighbourhood of k^n points with size
% defined by delta

dim = length(x);

x_new = zeros(dim,k);

for i = 1:dim
    x_new(i,:) = linspace(x(i)-delta(i),x(i)+delta(i),k);
end

rowDist = ones(1,dim);
args = mat2cell(x_new,rowDist);

xn = setprod(args{:});