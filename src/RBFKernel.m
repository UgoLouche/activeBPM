function [ K ] = RBFKernel( X1, X2, sigma )
% exp( - ||X1 - X2||^2 / 2*sigma^2 )

if (nargin < 3)
    sigma = 1;
end

if (size(X1, 2) == 1)
    X1 = X1';
end

if (size(X2,2) == 1)
    X2 = X2';
end

%Decompose the norm in the sum of 3 matrices
%Then add all together
S1 = size(X1, 1);
S2 = size(X2, 1);

X1sq = sum(X1.^2, 2);
X1sq = repmat(X1sq, 1, S2);
X2sq = sum(X2.^2, 2);
X2sq = repmat(X2sq, 1, S1);
X1X2 = X1 * X2';

K = X1sq + X2sq' - 2*X1X2;
K = exp( - K ./ (2 * sigma^2) );



end