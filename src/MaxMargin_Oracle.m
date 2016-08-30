function [ Cut ] = MaxMargin_Oracle( X, Query )
%return the cutting plane with maximum margin

margins = X * Query;

[val ind] = min(margins);

if (val > 0)
    Cut = 0;
else
    Cut = ind;
end

end