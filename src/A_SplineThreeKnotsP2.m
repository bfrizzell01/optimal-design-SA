%%Compute A- and D-optimal designs 
%%Spline models with degrees p, knots a1, a2, .., ak
%Dette et al. (2008)

clear;
runningtime=cputime;  %record computation time
    tol = 10^(-4);
    N=201;         %number of design points   
     
    a=  0;   %[a, b] is the design space
    b=   1;   %
    sc=1;
    %t1=[0.3 0.65 0.8]; sc=10000000; %change points
    t1=[0.3 0.5 0.75]; sc=30000000; 
    thetat1=1;
    thetat2=1;
    thetat3=1;
     p=2;            %degree of polynomial regression model 
    %sc=30000000; %for t1=[0.3 0.5 0.75]; p=2
    %sc=10000000;  % t1=[0.3 0.65 0.8];
     
     
    k=length(t1);  %number of knots
    u=linspace(a,b,N); %equally spaced N points in [a,b]

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               MODEL SET UP                       %        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
    
    %The following vectors and matrices are used in the information
    %matrices below.
    f = power(u(:), 0:p);          
    
    Fi=zeros(p+1+2*k,p+1+2*k,N);
    
    for j=1:N 
        z1=max(0, u(1,j)-t1(1,1));
        z2=max(0, u(1,j)-t1(1,2));
        z3=max(0, u(1,j)-t1(1,3));
        f1=[f(j,:) z1^p z2^p z3^p -p*thetat1*z1^(p-1) -p*thetat2*z2^(p-1) -p*thetat3*z3^(p-1) ];
        
        Fi(:,:,j)=f1'*f1;
    end
   
%Compute the A-optimal design  for model 1
        cvx_begin
            cvx_precision high
            variable w(1,N);
            expression A(p+1+2*k,p+1+2*k);%  model 1
            
            for j=1:N
                A = A+Fi(:,:,j)*w(j);
            end
            
             
             A=sc*A;   % 
            minimize( trace_inv(A) )   %A-opt
            0 <= w <= 1;
            sum(w)==1;
        cvx_end
        
        A=A/sc;
        
        loss1A=sum(diag(inv(A)))  %Loss at model 1
       

    design=[u(find(w(1,:)>tol))' w(1,find(w(1,:)>tol))'] %optimal design 
    
   
    resulttime=cputime-runningtime  %computation time
 
     %Necessary and sufficient condition plot
   
    dd1=zeros(N,1);
     ddline=dd1;
     
     invA=inv(A);
      
     
     
     for j=1:N
         dd1(j,1)=trace(invA*Fi(:,:,j)*invA)-loss1A; %A-opt
          
     end
     
   
     Condi=max(dd1)
     
    resulttime=cputime-runningtime  %computation time
 
    tiledlayout(1,1)
    ax1=nexttile;
    plot(u,dd1,u,ddline,'r--')
    title(ax1,' ')
    xlabel("u_i")
    ylabel("d")
    hold on;
    plot(t1,[0 0 0],'r.','LineWidth',2,'MarkerSize',25)
    
     
    