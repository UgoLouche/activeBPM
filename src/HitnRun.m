function [ CG Sample ] = HitnRun( X )
%WEIRD HIT AND RUN

Wstart = PerceptronCP_train(X, zeros(size(X,2),1), X(1,:));

dim = size(X,2);
nbSample = 200;
%Sample = zeros(nbSample, dim);
Sample = 0;
CG = zeros(dim,1);

Wcurrent = Wstart;

for i=1:nbSample
    step = randn(dim, 1);
    step = step / norm(step);
    %disp(num2str(i));
    lower = +0;
    upper = -0;
    deltaLower = -1;
    deltaUpper = 1;
    
    while (deltaLower < -1e-6 && deltaLower > -1e6)
        if (all( X * (Wcurrent + (lower + deltaLower)*step) > 0 ))
            lower = lower + deltaLower;
            deltaLower = deltaLower * 2;
        else
            deltaLower = deltaLower / 2;
        end
    end
    
    while (deltaUpper > 1e-6 && deltaUpper < 1e6)
        if (all( X * (Wcurrent + (upper + deltaUpper)*step) > 0 ))
            upper = upper + deltaUpper;
            deltaUpper = deltaUpper * 2;
        else
            deltaUpper = deltaUpper / 2;
        end
    end
    
    shift = rand(1) * ( upper - lower) + lower;
    
    Wcurrent = Wcurrent + shift * step;
    Wcurrent = Wcurrent / norm(Wcurrent);
    
    %Sample(i,:) = Wcurrent;    
    CG = CG + Wcurrent;
end

CG = CG';

%CG = sum(Sample, 1) / nbSample;
%CG = CG / norm(CG);

% hold all
% for i=1:nbSample
%     plot(Sample(i,1), Sample(i,2), '-*');
% end
% 
% plot(CG(1,1), CG(1,2), '-s');

end

