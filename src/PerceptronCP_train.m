function [ Wperc, update ] = PerceptronCP_train( X, Wstart, firstUp )
% Train a perceptron from Wstart using firstUp as first update
% until no errors are made
% Only positive examples

isOver = false;
update = 0;

while (~isOver)
    if (update == 0)
        Wperc = Wstart + firstUp';
    else
        [~, up] = min(margins);
        Wperc = Wperc + X(up,:)';
    end
    
    margins = X * Wperc;
    
    if ( all( margins > 0 ) )
        isOver = true;
    end 
    
    update = update + 1;
end

end