

%% Ex 2. 1D Quadratic Model

dim = 1;
N0 = 5; % number of design points for 2D model

a = -1; b = 1; % bounds of each component of design space

x = linspace(a,b,N0); % design space

q = 3; % number of parameters


% Compute components of FIM
I0 = zeros(q,q,N0);
for i = 1:N0
    z = [1 ; x(i) ; x(i)^2];
    I0(:,:,i) = z*z';
end

%% Ex 3. 2D Polynomial Linear Model

% z = (x1, x2, x1*x2, x1^2, x2^2)

dim = 2;
N0 = 10; % number of design points = N0^dim

a1 = 0; b1 = 1; % bounds of each component of design space
a2 = 0; b2 = 1;

x = setprod(linspace(a1,b1,N0),linspace(a2,b2,N0)); %generate design space points with set product

q = 6; % number of parameters


% Compute components of FIM
I0 = zeros(q,q,N0);
for i = 1:N0
    z = [1; x(i,1); x(i,2); x(i,1)*x(i,2); x(i,1)^2; x(i,2)^2];
    I0(:,:,i) = z*z';
end

%% Initialize Optimal Design with CVX

sc = 400;
tol = 1e-4;


cvx_begin
            cvx_precision high
            variable w(1,N0); %weights
            expression Ie(q,q); %information matrix
            
            for j=1:N0
                Ie = Ie+I0(:,:,j)*w(j);
            end
           
            Ie=sc*Ie;

            minimize(-log(det_rootn(Ie)))   %D-opt

            0 <= w <= 1;
            sum(w)==1;
cvx_end

Ie=Ie/sc;

%initialize weights, optimal design, and objective function value
w = w(w(1,:)>tol)'; 
d = x(w(1,:)>tol)';
L = cvx_optval;



