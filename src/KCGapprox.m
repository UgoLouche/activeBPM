function [ CG ] = ...
    KCGapprox( K )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

N = size(K,1);
nbIte = 10*N;
CG = zeros(N, 1);

for i=1:nbIte
    [~, order] = sort( rand(N,1) );
    [~, backOrder] = sort(order);
    Ki = K(order, :);
    Ki = Ki(:, order);
    
    Classifier = KperceptronCP_train(Ki, 0);
    W = Classifier.W;
    W = W(backOrder, 1);
    
    CG = CG + W;
end

    CG = CG / norm(CG);

end

