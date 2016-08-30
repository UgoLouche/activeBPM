function [ W update percUp Cutting ] = ...
    CuttingPlanes( X, Opt )

isOver = false;
update = 0;

% Parameters to be added in Arg %
if (nargin < 2)
    Query = @PerceptronCP_train;
    CP_Oracle = @MaxMargin_Oracle;
else
    Query = Opt.Query;
    CP_Oracle = Opt.CP_Oracle;
end

while (~isOver)
    if (update == 0) % Initialization round
        W = zeros( size(X,2), 1 );
        Active = zeros( size(X,1), 1 );
    elseif (update == 1)
        [W, Up] = Query( X(Active == 1, :), W, X(Cut,:) );
        percUp = Up;
    else
        [W, Up] = Query( X(Active == 1, :), W, X(Cut,:) );
        percUp = [percUp Up];
    end
    
    Cut = CP_Oracle( X, W );
    
    if (Cut == 0) 
        isOver = true;
    else
        Active(Cut) = 1;
        if (update == 0)
            Cutting =  X(Cut, :);
        else
            Cutting = [Cutting; X(Cut, :)];
        end
    end
    
    update = update + 1;
end

end

