function FIM = FIM_3dlinreg(x,theta)
% fim_3dlinreg(x): return Fischer Information Matrix terms given design space x
% for a 3D linear regression model

Z = [ones([length(x) 1]) x(:,1) x(:,2) x(:,3) x(:,1).*x(:,2) x(:,1).*x(:,3) x(:,2).*x(:,3) x(:,1).*x(:,2).*x(:,3)];
   
q = size(Z,2);

FIM = zeros(q,q,size(x,1));

for i = 1:size(x,1)
    FIM(:,:,i) = (exp(Z(i,:)*theta')/(1+exp(Z(i,:)*theta'))^2)*Z(i,:)'*Z(i,:);
end

end

