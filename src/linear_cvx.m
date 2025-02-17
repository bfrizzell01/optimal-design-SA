% Initial implementation of a "greedy" algorithm that iterates CVX for
% D-optimal designs

%Ex. 1: K-COMPARTMENTAL MODEL
%starting with 1D case for simplicity/visualization


tol =  1e-4;
sc = 400;


% VARIABLE INITIALIZATION %

dim = 1; %dimension of design space
n0 = 20; % # initial number of points in design space


N0 = n0^dim;    %total number of initial points 
a = 0; b = 10; %design space bounds

x0 = linspace(a,b,N0);   %creating initial design space



theta = [1 1 1 1 0.1 0.6 2.3 5.5]'; %initial parameter estimates, k = 4
q = length(theta); %number of parameters



%computing information matrices for CVX
I0 = zeros(q,q,N0);
for i = 1:N0
    I0(:,:,i) = info_kcomp(theta,x0(i)); %storing information matrices
end


% Computing inital design with CVX
cvx_out = D_opt(x0,I0,sc,tol); %returns design points, weights, and objective function value

w0 = cell2mat(cvx_out(2));
d0 = cell2mat(cvx_out(1)); %initial design
L0 = cell2mat(cvx_out(3)); %initial minimized objective function value

%% ANNEALING VARIABLE INITIALIZATION


H = 10;         % total number of cvx iterations
k = 11;          % number of design points generated per neighbourhood = k^dim
delta = 3*ones(1,dim);    % search size parameter
    
d = d0;         % initializing design and objective function
L = L0;
w = w0;
%% ALGORITHM IMPLEMENTATION

    % - generate neighbourhood of k^dim points of variable size for each
    %   design point

    % - new design space becomes union of neighbourhoods

    % - optimize over new design space using CVX, get candidate design

    % - if objective function is less than previous minimum, candidate
    %   design becomes optimal design

    
    
    N = length(d); %number of design points in previous iteration

    X = zeros(k^dim,dim,N); %array to store instances of newly generated design space
    
    xi = zeros(N*k^dim,dim);

    for i = 1:N
        X(:,:,i) = linear_neighbours(d(i,:),delta,k);
    end

    for i = 1:dim
        xi(:,i) = reshape(squeeze(X(:,i,:)),[],1);
    end
    
    xi = xi(xi(:,1) <= b); % removing points past boundaries
    xi = xi(xi(:,1) >= a); % need to change for general dimension
    xi = sort(unique(xi));

    %calculating new information matrix
    
    I_next = zeros(q,q,length(xi)); 
    for i = 1:length(xi)
        I_next(:,:,i) = info_kcomp(theta,xi(i)); %storing information matrices
    end

    cvx_new = D_opt(xi,I_next,sc,tol);      %optimizing with CVX

    L_next = cell2mat(cvx_new(3));          %getting objective function value

    if L_next < L
        w = cell2mat(cvx_new(2));
        d = cell2mat(cvx_new(1))'; %if better solution, output becomes new optimal design
        L = L_next;
        disp("New design found!")

    else
        disp("New design inferior")
    end










