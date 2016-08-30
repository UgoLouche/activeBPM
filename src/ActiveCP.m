function [ W Cuts ] = ActiveCP( X, Y)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

dim = size(X, 2);

W = zeros(dim, 1);
CG = W;
density = 0; %Measure the size of version space
update = 0;
dist = 0;

while(update < 50)
    update = update + 1;
    margins = X * CG;
    margins(margins < 0) = -1*margins(margins < 0);
    [dist, query] = min(margins);
    disp(['Query Point n? ' num2str(query) '@ dist ' num2str(dist)])
    
    
    if (update == 1)
        Cuts = Y(query,1)*X(query,:);
    else
        Cuts = [Cuts; Y(query,1)*X(query, :)];
    end
    
    X(query, :) = Inf * ones(1, dim);
    
    [CG Sample] = CGapprox( Cuts);
    %[CG Sample] = HitnRun(Cuts);
    CG = CG / norm(CG);
    %CG = CG'; %HitnRun Only
    
    density = sum(sum( (Sample * Sample') )) / ( size(Sample,1)^2 );
    disp(['New Density : ' num2str(density)]);
    
end

W = CG;

end

