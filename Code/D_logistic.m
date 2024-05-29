%%Compute D-optimal designs 
%%K-compartmental model
%Dette et al. (2008)

clear;
runningtime=cputime;  %record computation time

    tol = 10^(-4);

    N1=40;
    N2=50;     
    N = N1*N2; %number of design points
     
    b1=  1.5;   % bounds of design space (x1 and x2 respectively)
    b2=  1.7;   %

    sc=100;

    s1 = 2; %scales to test scaling property
    s2 = 3;


    theta0 = 1;
    theta1 = 3;
    theta2 = 4;
    theta3 = 7;
    theta = [theta0 theta1 theta2 theta3]'; %parameter vector

    theta_v = [theta0 theta1/s1 theta2/s2 theta3/(s1*s2)]';
    %scaled parameter vector to test theorem 2


    %evenly spaced points x1, x2 in domain [0,b1] and [0,b2] respectively
    x1 = linspace(0,b1,N1);
    x2 = linspace(0,b2,N2);
    
    %design space, to access design vectors after optimizing 
    x = zeros(2,N);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               MODEL SET UP                       %        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
    
    %calculating Fisher Information Matrix
    q = length(theta);
    Fi = zeros(q,q,N1*N2);
    Fi_v = zeros(q,q,N1*N2);
    
    k = 1;
    for i = 1:N1
        for j = 1:N2
            x(:,k) = [x1(i);x2(j)]; %storing design vectors
            z = [1 x1(i) x2(j) x1(i)*x2(j)]';
            Fi(:,:,k) = (exp(z'*theta)/(1+exp(z'*theta))^2)*(z*z');
            %Fi(:,:,k) = (exp(z'*theta_v)/(1+exp(z'*theta_v))^2)*(z*z');

            % switch between each Fi to test theorem 2
            k = k+1;
        end    
    end
    
   %%

%Compute the D-optimal design
        cvx_begin
            cvx_precision high
            variable w(1,N);
            expression I_eta(q,q);
            
            for j=1:N
                I_eta = I_eta+Fi(:,:,j)*w(j);
            end
           
            I_eta=sc*I_eta;

            minimize(-log(det_rootn(I_eta)))   %D-opt
            %minimize( trace_inv(I_eta) )   %A-opt

            0 <= w <= 1;
            sum(w)==1;

        cvx_end


    I_eta=I_eta/sc;
      
    design=[x(:,(find(w(1,:)>tol)))' w(1,find(w(1,:)>tol))'] %optimal design 
    
   
    resulttime=cputime-runningtime  %computation time
 
    %%

     %Necessary and sufficient condition plot (3d)
     
     dd1=zeros(N,1);
     ddline=dd1;
     
     invI_eta=inv(I_eta);
      
     
     %d-optimality condition
     for j=1:N
         dd1(j,1)=trace(invI_eta*Fi(:,:,j))-q; %D-opt
          
     end
     
   
     Condi=max(dd1)
     
    %resulttime=cputime-runningtime  %computation time
 
    tiledlayout(1,1)
    ax1=nexttile;
    surf(x1,x2,reshape(dd1,[N2,N1]))
    title(ax1,' ')
    xlabel("x1")
    ylabel("x2")
    hold on;
    
     
    