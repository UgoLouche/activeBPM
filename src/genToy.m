function [ X maxRange minMargin W ] = ...
    genToy( N, margin, range )
%2-class, monolabel data
%enforce margin
%Not normalized
%bounded
%2-dimensionnal

if (nargin < 3)
    range = 10;
end

if (nargin < 2)
    margin = 0.1;
end

if (nargin < 1)
    N = 1000;
end

X = rand(N, 2) * 2* range - range;

W = rand(2,1);
W = W ./ norm(W);

margins = X * W;

X(margins < 0, :) = -X(margins < 0, :);
margins = X * W; %inefficient but bug catching

if (any(margins < 0))
    disp('margins < 0 !');
end

maxRange = 0;
minMargin = +Inf;
Selector = true(N, 1);
for i=1:N
    if (margins(i) < margin)
        Selector(i) = false;
    else
        if (norm(X(i,:)) > maxRange)
            maxRange = norm(X(i,:));
        end
        if (margins(i) < minMargin)
            minMargin = margins(i);
        end
    end
end

X = X(Selector, :);
    


end

