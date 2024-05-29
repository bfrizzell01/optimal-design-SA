% Implementation of simulated annealing with CVX for optimal design
% of K-compartmental model

%% INITIALIZE VARIABLES

dim = 1; % dimension of design space
N0 = 20; % number of points in initial design space


a = 0; b = 10; % bounds of design space
x = linspace(a,b,N0)'; % initial design space

theta = [1 1 1 1 0.1 0.6 2.3 5.5]'; % parameter values
q = length(theta); % number of parameters


% Computing terms of FIM
I0 = zeros(q,q,N0);
k = q/2;

for i = 1:N0
    g = zeros(q,1); % gradient vector

    for j = 1:k
        g(j) = exp(-theta(j+k)*x(i));
        g(j+k) = -theta(j)*x(i)*exp(-theta(j+k)*x(i));
    end

    I0(:,:,i) = g*g';
end


%% INITIALIZE OPTIMAL DESIGN %

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

%initialize weights, optimal design, and objective function value
d = x(w(1,:)>tol);
w = w(w(1,:)>tol)'; 
L = cvx_optval;

d0 = d; % storing initial design for comparison after annealing
w0 = w;

%% RUN SIMULATED ANNEALING ALGORITHM

rng(324625) % set seed for replication

h = 15;             % number of design points generated per iteration
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
    x_new = zeros(N*(h+1),1);  
    
    x_new(1:N,:) = d;
    x_new(N+1:N*(h+1),:) = a*ones([N*h,dim]) + (b-a)*rand([N*h,dim]);

    
    % calculate FIM terms for new design space
    Ii = zeros(q,q,N*(h+1)); 
    for i = 1:N*(h+1)

        g = zeros(q,1); % gradient vector

        for j = 1:k
            g(j) = exp(-theta(j+k)*x_new(i));
            g(j+k) = -theta(j)*x_new(i)*exp(-theta(j+k)*x_new(i));
        end

        Ii(:,:,i) = g*g';
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

            minimize(-log(det_rootn(Ie)))

            0 <= wi <= 1;
            sum(wi)==1;
    cvx_end

    di = x_new(wi(1,:)>tol);
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


