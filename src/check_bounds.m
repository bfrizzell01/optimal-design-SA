function x_in = check_bounds(x,A,B)
% check_bounds(x,a,b): check that a < x < b for all entries. modify the
% point if not

x_in = x(:,:);
for i = 1:length(x)

    if (x(i) < A(i))
        x_in(i) = A(i);
    elseif (x(i) > B(i))
        x_in(i) = B(i);
    end     

end