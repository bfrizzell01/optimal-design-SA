%%polynomial regression optimal design via moment matrix optimization
%Castro et al. (2019)

% INITIALIZING VARIABLES %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

q = 0; % D-optimal design

%q = 1 % A-optimal design

%q = -infty % E-optimal design



d = 5;      % polynomial degree
n = 1;      % number of variables  
delta = 0;  % relaxation order for semidefinite approximation

a = -1;
b = 1;     %bounds of design space
N = 500;    %number of points in design space

x = linspace(a,b,N);

sc = 400;     %scale

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%

% MOMENT MATRICES SETUP %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sdd = poly_dim(n,d+delta); 
sd = poly_dim(n,d);
sdd1 = poly_dim(n,d+delta-1);   %dimension of Md+delta, Md, Md+delta-1 respectively



Mddi = zeros(sdd); %M_d+delta

for i=1:sdd
    Mddi(i,:) = (1:sdd) + i-1;  %generating moment matrix indices Md+delta
end

Mdi = Mddi(1:sd,1:sd);          %moment indices of Md
Mdd1i = Mddi(1:sdd1,1:sdd1);    %moment indices of Md+delta-1


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %               MODEL SET UP                       %        
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    cvx_begin
            cvx_precision high
            variable yd(1,poly_dim(n,2*(d+delta)));

            expression Mdd(sdd);
            expression Mdd1(sdd1);
            expression Md(sd)

            Mdd= yd(Mddi);
            Md = yd(Mdi);
            Mdd1 = yd(Mdd1i) - yd(Mdd1i + 2);

            minimize(-log(det_rootn(Md)))
            
            yd(1) == 1;
            Mdd >= 0;
            Mdd1 >= 0;


    cvx_end

yd

%%

% OBTAINING DESIGN POINTS (VIA CHROSTOFFEL POLYNOMIAL %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%yd = [1;0;0.56;0;0.45;0;0.4;0;0.37;0;0.36]; %expected 

Md = yd(Mdi);

vd =  [ones(1,N); x; x.^2; x.^3; x.^4; x.^5]; %basis monomials
 
ps = trace(Md^q) - sum(vd'.*(inv(Md)*vd)',2);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tol = 1e-3;

tiledlayout(1,1)
plot(x,ps,x,zeros(1,N));
