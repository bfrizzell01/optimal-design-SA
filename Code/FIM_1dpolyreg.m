function FIM = FIM_3dlinreg(x)
% fim_3dlinreg(x): return Fischer Information Matrix terms given design space x
% for a 1D polynomial regression model of degree 3

Z = [ones([length(x) 1]) x x.^2 x.^3 ];
   
q = size(Z,2);

FIM = zeros(q,q,size(x,1));

for i = 1:size(x,1)
    FIM(:,:,i) = Z(i,:)'*Z(i,:);
end

end