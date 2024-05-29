% Implementation of simulated annealing with CVX for optimal design
% of 2D polynomial regression (degree 3)

%% INITIALIZE VARIABLES

dim = 2;
N0 = 5; % number of initial design points for 2D model

a1 = -1; b1 = 1; % bounds of each component of design space
a2 = -1; b2 = 1;

x = setprod(linspace(a1,b1,N0),linspace(a2,b2,N0)); 
% 2D design space generated by a cartesian product

q = 6; % number of parameters

% Compute components of FIM
I0 = zeros(q,q,N0^dim);
for i = 1:N0^dim
    z = [1 ; x(i,1); x(i,2); x(i,1)*x(i,2); x(i,1)^3; x(i,2)^2];
    I0(:,:,i) = z*z';
end



%% INITIALIZE OPTIMAL DESIGN %

sc = 1;
tol = 1e-4;
cvx_begin
            cvx_precision high
            variable w(1,N0^dim); %weights
            expression Ie(q,q); %information matrix
            
            for j=1:N0^dim
                Ie = Ie+I0(:,:,j)*w(j);
            end
           
            Ie=sc*Ie;

            minimize(-log(det_rootn(Ie)))   %D-opt

            0 <= w <= 1;
            sum(w)==1;
cvx_end

%initialize weights, optimal design, and objective function value
d = x(w(1,:)>tol,:);
w = w(w(1,:)>tol)'; 
L = cvx_optval;

d0 = d; %storing initial design for comparison after annealing
w0 = w;

%% RUN SIMULATED ANNEALING ALGORITHM

rng(324625) % set seed for replication

h = 5;              % number of design points generated per iteration
T = 10;             % initial temperature
alpha = 0.8;        % cooling rate
Tmin = alpha^7*T;   % minimum temperature

while(T > Tmin)

    % - generate random neighbourhood of current optimal design
    % - optimize over new design space using CVX, get candidate design
    %   and minimized objective function Li
    % - if acceptance probability P(L,Li,T) > rand(0,1),
    %   new design becomes optimal design.
    % - decrease temperature by factor alpha, stop when minimum temperature
    %   reached
    
    % randomly generate design space 
    N = size(d,1);
    x_new = zeros(N*(h+1),2);  
    
    x_new(1:N,:) = d;
    x_new(N+1:N*(h+1),:) = [a1 a2].*ones([N*h,dim]) + [b1-a1 b2-a2].*rand([N*h,dim]);

    
    % calculate FIM terms for new design space
    Ii = zeros(q,q,N*(h+1)); 
    for i = 1:N*(h+1)

        z = [1; x_new(i,1); x_new(i,2); x_new(i,1)*x_new(i,2); x_new(i,1)^2; x_new(i,2)^2];
        Ii(:,:,i) = z*z';
      
    end
    
    % run CVX on new design space
    cvx_begin
            cvx_precision high
            variable wi(1,N*(h+1)); %weights
            expression Ie(q,q); %information matrix
            
            for j=1:N*(h+1)
                Ie = Ie+Ii(:,:,j)*wi(j);
            end
           
            Ie=sc*Ie;

            minimize(-log(det_rootn(Ie)))   %D-opt

            0 <= wi <= 1;
            sum(wi)==1;
    cvx_end

    di = x_new(wi(1,:)>tol,:);
    wi = wi(wi(1,:)>tol)'; 
    Li = cvx_optval;
    
    
    prob = exp(-(Li-L)/T); % acceptance probability

    if prob > rand(1)              
        w = wi;
        d = di;          
        L = Li;
        disp("New design accepted")

    else
        disp("New design rejected")
    end

    T = alpha*T; % decrease temperature

end

