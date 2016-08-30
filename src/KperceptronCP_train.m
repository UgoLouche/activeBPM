function [ Classifier ] = ...
    KperceptronCP_train( K, Xs, Opt, Wstart, firstUp )
% Train a perceptron from Wstart using firstUp as first update
% until no errors are made
% Only positive examples
% Kernel

if (nargin < 5)
    firstUp = 1;
end
if (nargin < 4)
    Wstart = zeros(size(K,1),1);
end
if (nargin < 3)
    Opt.Kernel = @(x1, x2) PolyKernel(x1, x2, 1, 0, 1);
end

Classifier.Kernel = Opt.Kernel;
isOver = false;
update = 0;

while (~isOver)
    if (update == 0)
        Wperc = Wstart;
        Wperc(firstUp,1) = Wperc(firstUp,1) + 1;
    else
        margins(margins == 0) = -1e-6;
        margins(margins > 0) = 0; %wtf warning
        up = find(margins);
        up = up(1);
        Wperc(up,1) = Wperc(up,1) + 1;
    end
    
    margins = K * Wperc;
    
    if ( all( margins > 0 ) )
        isOver = true;
    end 
    
    update = update + 1;
end

Classifier.W = Wperc;
Classifier.update = update;
Classifier.Xs = Xs;


end

