function X = random_neighbours(d,k,a,b)
% random_neighbours(d,k,a,b): generate k vectors with same dimension as d in range
% [a,b]
N = size(d,1);
dim = size(d,2);

X = zeros(N*(k+1),dim);
X_new = a*ones([N*k,dim]) + (b-a)*rand([N*k,dim]);

X(1:N,:) = d;
X(N+1:N*(k+1),:) = X_new;
end