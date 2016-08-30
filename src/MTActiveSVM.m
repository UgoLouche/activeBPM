function [ Classifier, Acc, Cuts_indices, Cuts_dist ] = ...
    MTActiveSVM( X, Y, Cuts, YCuts, Kernel, MaxQuery, TestX, TestY )
%Run an Active SVM
%X : Dataset
%Y : Labels
%Cuts :  Revealed Points (At least one positive and one negative)
%YCuts : Labels for the revealed Points
%Kernel : Kernel Function
%MaxQuery (optional) : maximum Iteration
%TestX (optional) : Test set for accuracy
%TestY (optional) : Test labels for accuracy
%%%%
%Classifier : final classifier
%Acc : Accuracy rates (Acc(i) is the Accuracy after performing the ith
%   call; First call correspond to Cuts)
%Cuts_indices : indices of each Cuts (Cuts_indices(i) is the indice of the
%   ith cuts, First is always 0 and correspond to initial Cuts)
%Cuts_dist : distance of each cuts from the current classifier
%   (Cuts_dist(i) is the distance of Cuts-indices(i); First is always 0 and
%   correspond to initial Cuts)

%Parse arguments
if ( nargin < 6 )
    MaxQuery = Inf;
end

MaxQuery = min( MaxQuery, size(X, 1) ); %Enforce Maxquery < # Points

if ( nargin < 7 )
    disp('Test data unavailable, using training data for test')
    disp('Accuracy results may be inaccurate')
    
    Xte = X;
    Yte = Y;
elseif ( nargin < 8 )
    disp('I have test Data but not labels, setting everything to +1')
    disp('This is probably an error though')
    
    Xte = TestX;
    Yte = ones( size(Xte, 1) );
else
    Xte = TestX;
    Yte = TestY;
end


%Main Code

%Initiali(s|z)e variables
Cuts_indices    = zeros(MaxQuery + 1, 1);
Cuts_dist       = zeros(MaxQuery + 1, 1);
Acc             = zeros(MaxQuery + 1, 1);

curr_update = 0; %First round (up = 0) is warm up with initial cuts 
ValidCut = true( size(X,1) ); %Each Cuts can be selected only once

while (curr_update < MaxQuery)
    
    curr_Classifier = MTlearnSVM(Cuts, YCuts, Kernel);
    
    %Compute Accuracy
    Ypred = MTPredict(Xte, curr_Classifier, 'SVM');
    Acc( curr_update + 1 ) = 1 - ( sum( Ypred ~= Yte ) / size( Yte, 1 ) );
    
    %Consistency Checks
    if ( Cuts_dist( curr_update + 1 ) >= Inf )
        disp([ 'Invalid Cuts used (Inf) @ step : ' ...
            num2str( curr_update ) ]);
    end
    
    if ( Cuts_dist( curr_update + 1 ) < 0 )
        disp([ 'Misclassified Cuts used (Margin < 0) @ step : ' ...
            num2str( curr_update ) ]);
    end
    
    [~, VspaceMargins] = MTPredict(Cuts, curr_Classifier, 'SVM');
    VspaceMargins = YCuts .* VspaceMargins; %Flip 'negative' Points
    if ( any( VspaceMargins < 0 ) )
        disp([ 'The classifier seems to be out of the version space' ...
            ' (Some cuts are misclassified) @ step : ' ...
            num2str( curr_update ) ]);
    end
    
    if ( curr_update > 1 )
        if ( Acc( curr_update + 1 ) < Acc( curr_update ) )
            disp([ 'Accuracy has reduced' ...
                ' from : ' num2str( Acc( curr_update ) ) ...
                ' to : ' num2str( Acc( curr_update + 1 ) ) ...
                ' @ step : ' num2str( curr_update ) ]);
        end
    end
    %END of Consistency Checks
    %END of the Previous Update Round
    
    curr_update = curr_update + 1; %Update Process Start Here
    
    %Select Next Cut
    [ ~, Margins ] = MTPredict(X, curr_Classifier, 'SVM');
    Margins( Margins < 0 ) = -1 * Margins( Margins < 0 ); %Abs Dist
    Margins( ~ValidCut ) = Inf;
    [ Cuts_dist( curr_update + 1 ), Cuts_indices( curr_update + 1 ) ] = ...
        min(Margins);
    Cuts = [ Cuts; X( Cuts_indices( curr_update + 1 ), : ) ];
    YCuts = [YCuts; Y( Cuts_indices( curr_update + 1 ) ) ];
    ValidCut( Cuts_indices( curr_update + 1 ) ) = false;
    
end

%Learn the final classifier
Classifier = MTlearnSVM(Cuts, YCuts, Kernel);

%Compute Accuracy
Ypred = MTPredict(Xte, Classifier, 'SVM');
Acc( MaxQuery + 1 ) = 1 - ( sum( Ypred ~= Yte ) / size( Yte, 1 ) );

%Consistency Checks
if ( Cuts_dist( MaxQuery + 1 ) >= Inf )
    disp([ 'Invalid Cuts (Inf) @ step : ' num2str( MaxQuery ) ]);
end

if ( Cuts_dist( MaxQuery + 1 ) < 0 )
    disp([ 'Misclassified Cuts (Margin < 0) @ step : ' ...
        num2str( MaxQuery ) ]);
end
 
[~, VspaceMargins] = MTPredict(Cuts, Classifier, 'SVM');
VspaceMargins = YCuts .* VspaceMargins; %Flip 'negative' Points
if ( any( VspaceMargins < 0 ) )
    disp([ 'The classifier seems to be out of the version space' ...
        ' (Some cuts are misclassified) @ step : ' ...
        num2str( MaxQuery ) ]);
end
   
if ( curr_update > 1 )
    if ( Acc( MaxQuery + 1 ) < Acc( MaxQuery ) )
        disp([ 'Accuracy has reduced' ...
            ' from : ' num2str( Acc( MaxQuery ) ) ...
            ' to : ' num2str( Acc( MaxQuery + 1 ) ) ...
            ' @ step : ' num2str( MaxQuery ) ]);
    end
end
%END of Consistency Checks
%END of the Last Update Round

end

