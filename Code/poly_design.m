% Ex. 6.1 Univariate polynomial regression
% Dette et al. (2008)

clear;
runningtime=cputime;  %record computation time

    tol = 10^(-4);

    % Design space construction 
    a =  -1;  
    b =  1;  
    N = 400;

    x=linspace(a,b,N); %equally spaced N points in [a,b]

    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               MODEL SET UP                       %        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
    d = 5; %polynomial degree
    n = 1; %number of polynomial variables

    delta = 0; %relaxation order

    sc = 1;

    %mapping appropriate moments to moment matrices

    moment_inds = 1:nchoosek(n+d+delta,n);

    Md_delta_inds = zeros(nchoosek(n+d+delta,n),nchoosek(n+d+delta,n));

    for i=1:nchoosek(n+d+delta,n)
        Md_delta_inds(i,:) = moment_inds + i-1;
    end

    Md_inds = Md_delta_inds(1:nchoosek(n+d,n),1:nchoosek(n+d,n));
    
    Md_delta_1_inds = Md_delta_inds(1:nchoosek(n+d+delta-1,n),1:nchoosek(n+d+delta-1,n));

    

    


    
   %%

%Compute the D-optimal design
        cvx_begin
            cvx_precision high
            variable yd(1,nchoosek(n+2*(d+delta),n));

            expression Md_delta(nchoosek(n+d+delta,n),nchoosek(n+d+delta,n));
            expression Md_delta_1(nchoosek(n+d+delta-1,n),nchoosek(n+d+delta-1,n));
            expression Md(nchoosek(n+d,n),nchoosek(n+d,n))

            Md_delta = yd(Md_delta_inds);
            Md = yd(Md_inds);
            Md_delta_1 = yd(Md_delta_1_inds) - yd(Md_delta_1_inds + 2);

            %TODO:
            
            %figure out way to get M_(d+delta-1)(1-||x||^2*yd)



            minimize(-log_det(Md))
            
            yd(1) == 1;
            Md_delta >= 0;
            Md_delta_1 >= 0;


        cvx_end

        %getting christoffel polynomial



      
   
   
   
    resulttime=cputime-runningtime  %computation time
 
    
    
    