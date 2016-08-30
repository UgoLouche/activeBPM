function [ K ] = PolyKernel( X1, X2, gamma, coef0, degree )
%(gamma*X1'*X2 + coef0)^degree
%If called with 2 arguments it is a linear kernel

if (nargin < 5)
    degree = 1;
end
if (nargin < 4)
    coef0 = 0;
end
if (nargin < 3)
    gamma = 1;
end


if (size(X1, 2) == 1)
    X1 = X1';
end

if (size(X2,2) == 1)
    X2 = X2';
end

%Regular poly kernel
K = (gamma .* X1*X2' + coef0).^degree;

%Normalized Poly Kenrel
Kx1 = diag( 1 ./ sqrt( (gamma .* sum(X1.^2, 2) + coef0).^degree ) );
Kx2 = diag( 1 ./ sqrt( (gamma .* sum(X2.^2, 2) + coef0).^degree ) );

K = Kx1 * K * Kx2;


end

