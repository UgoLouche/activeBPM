function [ Cut ] = Rnd_Oracle( X, Query )
%return the cutting plane with maximum margin

margins = X * Query;

valid = sum(margins <= 0);

if (valid <= 0)
    Cut = 0;
else
    selection = randi(valid);
    for i=1:size(margins)
        if (margins(i) <= 0)
            selection = selection - 1;
        end
        if (selection == 0)
            Cut = i;
            selection = -1;
        end
    end
end
end