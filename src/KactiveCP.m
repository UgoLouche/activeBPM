function [ CG Cuts ] = ...
    KactiveCP( X, Y, Cuts, Kernel, maxUp )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if (nargin < 5)
    maxUp = 50;
end

update = 0;
K = Kernel(X,Cuts);
CG = zeros(size(Cuts,1),1);
PossibleCut = true(size(X,1),1);

while (update < maxUp)
    update = update + 1;
    margins = K * CG;
    margins(margins < 0) = -1*margins(margins < 0);
    margins(~PossibleCut) = Inf;
    [dist, query] = min(margins);
    %disp(['Query Point n? ' num2str(query) '@ dist ' num2str(dist)])
    PossibleCut(query) = false;
    
    Cuts = [Cuts; Y(query,1)*X(query, :)];

    
    CG = KCGapprox(Kernel(Cuts, Cuts));
    K = Kernel(X, Cuts);
       
end

end

