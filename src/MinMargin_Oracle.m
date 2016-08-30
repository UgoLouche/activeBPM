function [ Cut ] = MinMargin_Oracle( X, Query )
%return the cutting plane with maximum margin

margins = X * Query;

margins(margins > 0) = -Inf;

[val ind] = max(margins);

if (val == -Inf)
    Cut = 0;
else
    Cut = ind;
end

end