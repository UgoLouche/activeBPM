function [ model, Cuts ] = ...
    KactiveSVM( X, Y, Cuts, Kernel, maxUp )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if (nargin < 5)
    maxUp = 50;
end

update = 0;

% init model
K = Kernel([Cuts; -Cuts],[Cuts; -Cuts]);
K = [(1:2*size(Cuts,1))', K];
Ycuts = [ones(size(Cuts,1), 1); -ones(size(Cuts,1), 1)];
model = svmtrain(Ycuts, [(1:2*size(Cuts,1))', K], ...
        '-t 4 -c 10000000000000000000000 -q');
    
K = Kernel(X, [Cuts; -Cuts]);
K = [(1:size(X,1))', K];
PossibleCut = true(size(X,1),1);




while (update < maxUp)
    update = update + 1;
    
    [~, ~, margins] = ...
        svmpredict(ones(size(X,1),1), K, model, '-q');
    margins(margins < 0) = -1*margins(margins < 0);
    margins(~PossibleCut) = Inf;
    [dist, query] = min(margins);
    %disp(['Query Point n? ' num2str(query) '@ dist ' num2str(dist)])
    PossibleCut(query) = false;
    
    Cuts = [Cuts; Y(query,1)*X(query, :)];
    
    K = Kernel([Cuts; -Cuts],[Cuts; -Cuts]);
    Ycuts = [ones(size(Cuts,1)); -ones(size(Cuts,1))];
    model = svmtrain(Ycuts, [(1:2*size(Cuts,1))', K], ...
        '-t 4 -c 10000000000000000000000 -q');
    
    K = Kernel(X, [Cuts; -Cuts]);
    K = [(1:size(X,1))', K];
    
end

end

