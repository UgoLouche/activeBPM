function [K] = LinKernel(X1, X2)

if (size(X1, 2) == 1)
    X1 = X1';
end

if (size(X2,2) == 1)
    X2 = X2';
end

K = X1 * X2';

end