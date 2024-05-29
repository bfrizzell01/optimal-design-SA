function We = initializeExact(W,N)
% initializeExact(W,N): given list of weights W for approximate design, and
% total number of design points N, return modified weight list We such that
% for each w[i] in We, N*w gives the exact integer number of points for
% the ith support point in the exact design
 
We = floor(N*W); % take floor of approx design*N, sum(We) <= N initially
k = size(We,1);

i = randi(k,1,1);
while(sum(We) < N)  
    We(i) = We(i) + 1; % lazily increase number of         
    i = randi(k,1,1);  % support points until we have N of them
end

We = We/N;
