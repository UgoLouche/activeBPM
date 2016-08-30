function [ CG Ws ] = CGapprox( X )
%CGAPPROX Summary of this function goes here
%   Detailed explanation goes here

dim = size(X,2);

%Ws = 0;
Ws = zeros(dim, 1000);
CG = zeros(dim, 1);

for i=1:1000
    R = rand(size(X,1), 1);
    [~, order] = sort(R);
    X = X(order, :);
    
    W = CuttingPlanes(X);
    W = PerceptronCP_train(X, zeros(dim,1), X(1,:));
    W = W / norm(W);
    Ws(:,i) = W;
    CG = CG + W;

end

CG = CG / norm(CG);

%hold all
%plot(CG(1,1), CG(2,1), '-s', 'MarkerSize', 20)

% for i=1:1000
%     plot(Ws(1,i), Ws(2,i), '-*', 'MarkerSize', 10)
% end

end