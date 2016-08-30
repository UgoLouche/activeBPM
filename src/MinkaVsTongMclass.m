clear all

disp('===Minka BPM and Tong SVM===')

%execution parameters
run = 2;
maxUpdate = 100;
Kernel = @(x1, x2) PolyKernel(x1, x2, 1, 0, 3);

%return values
AccSVM = zeros( maxUpdate + 1, 1 );
AccBPM = zeros( maxUpdate + 1, 1 );
distSVM = zeros( maxUpdate + 1, 1 );
distBPM = zeros( maxUpdate + 1, 1 );


disp('Loading OPT digits')

load optdigits.tra
X = optdigits(:, 1:64);
Y = optdigits(:, 65);

newX = zeros(3823*10, 64*10);
newY = zeros(3823 * 10, 1);

m = 1; %newX current row
n = 1; %newX current column

for i=1:3823 %For each point
    for j=1:10 % for each class
        
        if ( j == Y( i ) )
            newY( m ) = +1;
        else
            newY( m ) = -1;
        end
        
        n = 1;
        for k=1:10 %One copy of x at each time
            for l=1:64
                if ( k == j )
                    newX( m, n ) = X( i, l );
                else
                    newX( m, n ) = - X( i, l ); 
                end
                n = n + 1;
            end
        end
        m = m + 1;
    end
end

Xtr = newX;
Ytr = newY;

load optdigits.tes
X = optdigits(:, 1:64);
Y = optdigits(:, 65);

newX = zeros(1797 * 10, 64*10);
newY = zeros(1797 * 10, 1);

m = 1; %newX current row
n = 1; %newX current column

for i=1:1797 %For each point
    for j=1:10 % for each class
        
        if ( j == Y( i ) )
            newY( m ) = +1;
        else
            newY( m ) = -1;
        end
        
        n = 1;
        for k=1:10 %One copy of x at each time
            for l=1:64
                if ( k == j )
                    newX( m, n ) = X( i, l );
                else
                    newX( m, n ) = - X( i, l ); 
                end
                n = n + 1;
            end
        end
        m = m + 1;
    end
end

Xte = newX;
Yte = newY;

for r=1:run
    disp(['Starting run #' num2str(r)])
    
    X = Xtr;
    Y = Ytr;
    Xtest = Xte;
    Ytest = Yte;
    
    %Suffle Xtr and roll Cuts
    R = rand( size( Xtr, 1 ), 1 );
    [~, order] = sort( R );
    X = X(order, :);
    Y = Y(order);
    
    Revealed = false( size( X, 1 ), 1 );
    Revealed( find( Y == 1, 1, 'first' ) ) = true;
    Revealed( find( Y == -1, 1, 'first' ) ) = true;
    
    Cuts = X( Revealed, : );
    YCuts = Y( Revealed );
    X = X ( ~Revealed, : );
    Y = Y ( ~Revealed );
    
    disp('Preprocessing ok ... starting learning')
    
    [~, curr_AccSVM, ~, curr_distSVM] = ...
        MTActiveSVM( X, Y, Cuts, YCuts, Kernel, maxUpdate, Xtest, Ytest);
    [~, curr_AccBPM, ~, curr_distBPM] = ...
        MTActiveBPM( X, Y, Cuts, YCuts, Kernel, maxUpdate, Xtest, Ytest);
    
    AccSVM = AccSVM + curr_AccSVM;
    AccBPM = AccBPM + curr_AccBPM;
    distSVM = distSVM + curr_distSVM;
    distBPM = distBPM + curr_distBPM;
    
end

AccSVM = AccSVM / run;
AccBPM = AccBPM / run;
distSVM = distSVM / run;
distBPM = distBPM / run;

%All local for now, copy/paste if good results

