function x_nb = get_neighbour(x,delta,A,B)
%get_neighbour(x,delta): given point x, return a random neighbour of x in a
% hyperspherical region bound by radius delta

dim = size(x,2); %dimension of x


if dim > 1

x_d = zeros(size(x)); % store point bound by d-sphere of radius delta

phi = pi*rand([1 dim-1]);
phi(dim-1) = 2*pi*rand(1);

r = delta*rand(1);

x_d(1) = r*cos(phi(1));

for i = 2:dim-1
    x_d(i) = x_d(i-1)*tan(phi(i-1))*cos(phi(i));
end

   x_d(dim) = x_d(dim-1)*tan(phi(dim-1));
   x_nb = x + x_d;

   x_nb = check_bounds(x_nb,A,B);

else
    r = -1 + 2*delta*rand(1);
    x_nb = x + r;
    x_nb = check_bounds(x_nb,A,B);

end

end
