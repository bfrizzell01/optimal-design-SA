function s = poly_dim(n,d)
% poly_dim(n,x) -> nchoosek(n+x,n)
% for a polynomial of n variables and degree d, returns the dimension of
% the vector space

s = nchoosek(n+d,n);
end