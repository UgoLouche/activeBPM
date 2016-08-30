clear all

disp('===Minka BPM and Tong SVM===')

%execution parameters
run = 25;
class = 10;
maxUpdate = 100; %Do not touch this or bug
pool = 500;
%Kernel = @(x1, x2) PolyKernel(x1, x2, 1, 0, 2);
Kernel = @(x1, x2) LinKernel(x1, x2);
%Kernel = @(x1, x2) RBFKernel(x1, x2, 0.5);
Dataset = 'heart';

%Datasets
if ( strcmp(Dataset, 'banana') )
    disp('Loading Banana (Gunnar Raetsch)')
    
    load benchmarks.mat banana    
    
    Xraw = banana.x;
    Yraw = banana.t;
    Yraw (Yraw == -1) = 2;
    
    trainSize = 400;
    testSize = 4900;
    maxClass = max(Yraw);
    nbPoints = trainSize;
    
    disp('Overwriting Kernel');
    Kernel = @(x1, x2) RBFKernel(x1, x2, 0.5);    
end

if ( strcmp(Dataset, 'breastC') )
    disp('Loading Breast Cancer (Gunnar Raetsch)')
    
    load benchmarks.mat breast_cancer    
    
    Xraw = breast_cancer.x;
    Yraw = breast_cancer.t;
    Yraw (Yraw == -1) = 2;
    
    trainSize = 180;
    testSize = 77;
    maxClass = max(Yraw);
    nbPoints = trainSize;
    
    disp('Overwriting Kernel');
    Kernel = @(x1, x2) RBFKernel(x1, x2, 0.9);  %Nearly Handmade 
end

if ( strcmp(Dataset, 'diabetis') )
    disp('Loading Diabetis (Gunnar Raetsch)')
    
    load benchmarks.mat diabetis    
    
    Xraw = diabetis.x;
    Yraw = diabetis.t;
    Yraw (Yraw == -1) = 2;
    
    trainSize = 468;
    testSize = 300;
    maxClass = max(Yraw);
    nbPoints = trainSize;
    
    disp('Overwriting Kernel');
    Kernel = @(x1, x2) RBFKernel(x1, x2, 5);    
end

if ( strcmp(Dataset, 'german') )
    disp('Loading German (Gunnar Raetsch)')
    
    load benchmarks.mat german   
    
    Xraw = german.x;
    Yraw = german.t;
    Yraw (Yraw == -1) = 2;
    
    trainSize = 700;
    testSize = 300;
    maxClass = max(Yraw);
    nbPoints = trainSize;
    
    disp('Overwriting Kernel');
    Kernel = @(x1, x2) RBFKernel(x1, x2, 4); %Handmade
end

if ( strcmp(Dataset, 'heart') )
    disp('Loading Heart (Gunnar Raetsch)')
    
    load benchmarks.mat heart   
    
    Xraw = heart.x;
    Yraw = heart.t;
    Yraw (Yraw == -1) = 2;
    
    trainSize = 170;
    testSize = 100;
    maxClass = max(Yraw);
    nbPoints = trainSize;
    
    disp('Overwriting Kernel');
    Kernel = @(x1, x2) RBFKernel(x1, x2, 10);    
end

if ( strcmp(Dataset, 'image') )
    disp('Loading Image (Gunnar Raetsch)')
    
    load benchmarks.mat image   
    
    Xraw = image.x;
    Yraw = image.t;
    Yraw (Yraw == -1) = 2;
    
    trainSize = 1076;
    testSize = 1010;
    maxClass = max(Yraw);
    nbPoints = trainSize;
    
    disp('Overwriting Kernel');
    Kernel = @(x1, x2) RBFKernel(x1, x2, 1.6); %Pseudo Handmade 1.6-> 0.91  
end

if ( strcmp(Dataset, 'ringnorm') )
    disp('Loading RingNorm (Gunnar Raetsch)')
    
    load benchmarks.mat ringnorm   
    
    Xraw = ringnorm.x;
    Yraw = ringnorm.t;
    Yraw (Yraw == -1) = 2;
    
    trainSize = 400;
    testSize = 7000;
    maxClass = max(Yraw);
    nbPoints = trainSize;
    
    disp('Overwriting Kernel');
    Kernel = @(x1, x2) RBFKernel(x1, x2, 100); %test this kernel 5 -> 0.93 crap
end

if ( strcmp(Dataset, 'splice') )
    disp('Loading Splice (Gunnar Raetsch)')
    
    load benchmarks.mat splice   
    
    Xraw = splice.x;
    Yraw = splice.t;
    Yraw (Yraw == -1) = 2;
    
    trainSize = 816;
    testSize = 2175;
    maxClass = max(Yraw);
    nbPoints = trainSize;
    
    disp('Overwriting Kernel');
    Kernel = @(x1, x2) RBFKernel(x1, x2, 6); %Pseudo Handmade 5 -> 0.79 6,7 -> 0.79 
end

if ( strcmp(Dataset, 'thyroid') )
    disp('Loading Thyroid (Gunnar Raetsch)')
    
    load benchmarks.mat thyroid   
    
    Xraw = thyroid.x;
    Yraw = thyroid.t;
    Yraw (Yraw == -1) = 2;
    
    trainSize = 140;
    testSize = 75;
    maxClass = max(Yraw);
    nbPoints = trainSize;
    
    disp('Overwriting Kernel');
    Kernel = @(x1, x2) RBFKernel(x1, x2, 3);   
end

if ( strcmp(Dataset, 'twonorm') )
    disp('Loading Twonorm (Gunnar Raetsch)')
    
    load benchmarks.mat twonorm   
    
    Xraw = twonorm.x;
    Yraw = twonorm.t;
    Yraw (Yraw == -1) = 2;
    
    trainSize = 816;
    testSize = 2991;
    maxClass = max(Yraw);
    nbPoints = trainSize;
    
    disp('Overwriting Kernel');
    Kernel = @(x1, x2) RBFKernel(x1, x2, 10); %10 -> 0.97   
end

if ( strcmp(Dataset, 'waveform') )
    disp('Loading WaveForm (Gunnar Raetsch)')
    
    load benchmarks.mat waveform  
    
    Xraw = waveform.x;
    Yraw = waveform.t;
    Yraw (Yraw == -1) = 2;
    
    trainSize = 816;
    testSize = 2991;
    maxClass = max(Yraw);
    nbPoints = trainSize;
    
    disp('Overwriting Kernel');
    Kernel = @(x1, x2) RBFKernel(x1, x2, 20); 
end

if ( strcmp(Dataset, 'Reuters') )
    disp('Loading Reuters')

    load Reuters21578
    Xtr = fea(trainIdx, :);
    Ytr = gnd(trainIdx);
    Xte = fea(testIdx, :);
    Yte = gnd(testIdx);
    
    trainSize = -1;
    testSIze = -1;
    maxClass = max(Ytr);
    nbPoints = size(Xtr,1);
end

if ( strcmp(Dataset, 'OptDigits') )
    disp('Loading OptDigits')
    
    load optdigits.tra
    Xtr = optdigits(:, 1:64);
    Ytr = optdigits(:, 65);
    
    load optdigits.tes
    Xte = optdigits(:, 1:64);
    Yte = optdigits(:, 65);
    
    trainSize = -1;
    testSIze = -1;
    maxClass = max(Ytr);
    nbPoints = size(Xtr,1);
end

if ( strcmp(Dataset, '20Newsgroups') )
    disp('Loading Newsgroups')
    load 20Newsgroups
    Xtr = fea(trainIdx, :);
    Ytr = gnd(trainIdx);
    Xte = fea(testIdx, :);
    Yte = gnd(testIdx);
    %Take only half of the dataset
    R = rand(size(Xtr, 1), 1);
    Xtr = Xtr(R >= 0.5, :);
    Ytr = Ytr(R >= 0.5, 1);
    %R = rand(size(Xte, 1), 1);
    %Xte = Xte(R > 0.5, :);
    %Yte = Yte(R >= 0.5, 1);
    
    trainSize = -1;
    testSIze = -1;
    maxClass = max(Ytr);
    nbPoints = size(Xtr,1);
    disp(['Final sizes train : ' num2str(size(Xtr,1)) ', test : ' num2str(size(Xte,1))])
end

%Check parameters consistency
if (maxClass < class)
    class = maxClass;
    disp(['Not enough class in Xtr, reducing "class" to : ' num2str(class)]);
end

if (pool > nbPoints - 2) %-2 for revealed cuts
    pool = nbPoints - 2;
    disp(['Not enough example for pool size, reducing "pool" to : ' num2str(pool)]);
end

if (maxUpdate > pool)
    maxUpdate = pool;
    disp(['Not enough pool examples to query, reducing "maxUpdate" to : ' num2str(maxUpdate)]);
end


%return values
AccSVM = zeros( maxUpdate + 1, class*run );
AccBPM = zeros( maxUpdate + 1, class*run );
distSVM = zeros( maxUpdate + 1, class*run );
distBPM = zeros( maxUpdate + 1, class*run );
%STDDev ?

%additinal measures
AccSVMCC = zeros(class*run ,5);
AccSVMCG = zeros(class*run ,5);
AccBPMCC = zeros(class*run ,5);
AccBPMCG = zeros(class*run ,5);
%STDDev ?

totalRun = 0; %iterate through run AND class

%Main loop
for c=1:class
    for r=1:run
        totalRun = totalRun + 1;
        disp(['Starting run #' num2str(r) ' totalRun #' num2str(totalRun)])
        %Split train/test if needed
        if (trainSize ~= -1)
            R = rand( size( Xraw, 1 ), 1 );
            [~, order] = sort( R );
            Xraw = Xraw( order, : );
            Yraw = Yraw( order );
            
            Xtr = Xraw( 1:trainSize, : );
            Ytr = Yraw( 1:trainSize );
            Xte = Xraw( trainSize+1:trainSize+testSize, : );
            Yte = Yraw( trainSize+1:trainSize+testSize );
        end

        %choose a class for the binary reduction
        ActiveClass = c;
        X = Xtr;
        Y = Ytr;
        Y(Y ~= ActiveClass) = -1;
        Y(Y ~= -1) = 1;

        Xtest = Xte;
        Ytest = Yte;
        Ytest(Ytest ~= ActiveClass) = -1;
        Ytest(Ytest ~= -1) = 1;

        %Suffle Xtr and roll Cuts and pool
        R = rand( size( Xtr, 1 ), 1 );
        [~, order] = sort( R );
        X = X(order, :);
        Y = Y(order);
        X = X(1:pool, :);
        Y = Y(1:pool);

        Revealed = false( size( X, 1 ), 1 );
        Revealed( find( Y == 1, 1, 'first' ) ) = true;
        Revealed( find( Y == -1, 1, 'first' ) ) = true;

        Cuts = X( Revealed, : );
        YCuts = Y( Revealed );
        X = X ( ~Revealed, : );
        Y = Y ( ~Revealed );

        disp(['Active class is ' num2str(ActiveClass) ' with ' ...
            num2str(sum(Y == 1)) ' Positive examples'])

        [~, curr_AccSVM, CCindices, curr_distSVM] = ...
            MTActiveSVM( X, Y, Cuts, YCuts, Kernel, maxUpdate, Xtest, Ytest);
        [~, curr_AccBPM, CGindices, curr_distBPM] = ...
            MTActiveBPM( X, Y, Cuts, YCuts, Kernel, maxUpdate, Xtest, Ytest);

        AccSVM(:, totalRun) = curr_AccSVM;
        AccBPM(:, totalRun) = curr_AccBPM;
        distSVM(:, totalRun) = curr_distSVM;
        distBPM(:, totalRun) = curr_distBPM;
        
        CCSVM = MTlearnSVM(X(CCindices(2:11), :), Y(CCindices(2:11)), Kernel);
        Ypred = MTPredict(Xtest, CCSVM, 'SVM');
        AccSVMCC(totalRun, 1) =  ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );
        CCSVM = MTlearnSVM(X(CCindices(2:26), :), Y(CCindices(2:26)), Kernel);
        Ypred = MTPredict(Xtest, CCSVM, 'SVM');
        AccSVMCC(totalRun, 2) =  ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );
        CCSVM = MTlearnSVM(X(CCindices(2:46), :), Y(CCindices(2:46)), Kernel);
        Ypred = MTPredict(Xtest, CCSVM, 'SVM');
        AccSVMCC(totalRun, 3) =  ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );
        CCSVM = MTlearnSVM(X(CCindices(2:71), :), Y(CCindices(2:71)), Kernel);
        Ypred = MTPredict(Xtest, CCSVM, 'SVM');
        AccSVMCC(totalRun, 4) =  ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );
        CCSVM = MTlearnSVM(X(CCindices(2:101), :), Y(CCindices(2:101)), Kernel);
        Ypred = MTPredict(Xtest, CCSVM, 'SVM');
        AccSVMCC(totalRun, 5) =  ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );
        
        CGSVM = MTlearnSVM(X(CGindices(2:11), :), Y(CGindices(2:11)), Kernel);
        Ypred = MTPredict(Xtest, CGSVM, 'SVM');
        AccSVMCG(totalRun, 1) =   ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );
        CGSVM = MTlearnSVM(X(CGindices(2:26), :), Y(CGindices(2:26)), Kernel);
        Ypred = MTPredict(Xtest, CGSVM, 'SVM');
        AccSVMCG(totalRun, 2) =  ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );
        CGSVM = MTlearnSVM(X(CGindices(2:46), :), Y(CGindices(2:46)), Kernel);
        Ypred = MTPredict(Xtest, CGSVM, 'SVM');
        AccSVMCG(totalRun, 3) =  ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );
        CGSVM = MTlearnSVM(X(CGindices(2:71), :), Y(CGindices(2:71)), Kernel);
        Ypred = MTPredict(Xtest, CGSVM, 'SVM');
        AccSVMCG(totalRun, 4) =  ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );
        CGSVM = MTlearnSVM(X(CGindices(2:101), :), Y(CGindices(2:101)), Kernel);
        Ypred = MTPredict(Xtest, CGSVM, 'SVM');
        AccSVMCG(totalRun, 5) =  ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );
        
        CCBPM = MTlearnBPM(X(CCindices(2:11), :), Y(CCindices(2:11)), Kernel);
        Ypred = MTPredict(Xtest, CCBPM, 'BPM');
        AccBPMCC(totalRun, 1) =  ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );
        CCBPM = MTlearnBPM(X(CCindices(2:26), :), Y(CCindices(2:26)), Kernel);
        Ypred = MTPredict(Xtest, CCBPM, 'BPM');
        AccBPMCC(totalRun, 2) =  ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );
        CCBPM = MTlearnBPM(X(CCindices(2:46), :), Y(CCindices(2:46)), Kernel);
        Ypred = MTPredict(Xtest, CCBPM, 'BPM');
        AccBPMCC(totalRun, 3) =  ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );
        CCBPM = MTlearnBPM(X(CCindices(2:71), :), Y(CCindices(2:71)), Kernel);
        Ypred = MTPredict(Xtest, CCBPM, 'BPM');
        AccBPMCC(totalRun, 4) =  ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );
        CCBPM = MTlearnBPM(X(CCindices(2:101), :), Y(CCindices(2:101)), Kernel);
        Ypred = MTPredict(Xtest, CCBPM, 'BPM');
        AccBPMCC(totalRun, 5) =  ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );
        
        
        CGBPM = MTlearnBPM(X(CGindices(2:11), :), Y(CGindices(2:11)), Kernel);
        Ypred = MTPredict(Xtest, CGBPM, 'BPM');
        AccBPMCG(totalRun, 1) =  ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );
        CGBPM = MTlearnBPM(X(CGindices(2:26), :), Y(CGindices(2:26)), Kernel);
        Ypred = MTPredict(Xtest, CGBPM, 'BPM');
        AccBPMCG(totalRun, 2) =  ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );
        CGBPM = MTlearnBPM(X(CGindices(2:46), :), Y(CGindices(2:46)), Kernel);
        Ypred = MTPredict(Xtest, CGBPM, 'BPM');
        AccBPMCG(totalRun, 3) =  ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );
        CGBPM = MTlearnBPM(X(CGindices(2:71), :), Y(CGindices(2:71)), Kernel);
        Ypred = MTPredict(Xtest, CGBPM, 'BPM');
        AccBPMCG(totalRun, 4) =  ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );
        CGBPM = MTlearnBPM(X(CGindices(2:101), :), Y(CGindices(2:101)), Kernel);
        Ypred = MTPredict(Xtest, CGBPM, 'BPM');
        AccBPMCG(totalRun, 5) =  ...
            1 - ( sum( Ypred ~= Ytest ) / size( Ytest, 1 ) );

    end
end

mAccSVM = sum(AccSVM, 2) / totalRun;
mAccBPM = sum(AccBPM, 2) / totalRun;
mdistSVM = sum(distSVM, 2) / totalRun;
mdistBPM = sum(distBPM, 2) / totalRun;

%Compute stdDev
stdAccSVM = sqrt( sum( ( AccSVM - repmat( mAccSVM, 1, totalRun) ).^2, 2) ./ totalRun  ) / 2;
stdAccBPM = sqrt( sum( ( AccBPM - repmat( mAccBPM, 1, totalRun) ).^2, 2) ./ totalRun  ) / 2;
stddistSVM = sqrt( sum( ( distSVM - repmat( mdistSVM, 1, totalRun) ).^2, 2) ./ totalRun  ) / 2;
stddistBPM = sqrt( sum( ( distBPM - repmat( mdistBPM, 1, totalRun) ).^2, 2) ./ totalRun  ) / 2;

%Other metrics

mAccSVMCC = sum(AccSVMCC, 1) / totalRun;
mAccSVMCG = sum(AccSVMCG, 1) / totalRun;
mAccBPMCC = sum(AccBPMCC, 1) / totalRun;
mAccBPMCG = sum(AccBPMCG, 1) / totalRun;

%stdDev
stdAccSVMCC = sqrt( sum( ( AccSVMCC - repmat( mAccSVMCC, totalRun, 1 ) ).^2, 1) ./ totalRun ) / 2;
stdAccSVMCG = sqrt( sum( ( AccSVMCG - repmat( mAccSVMCG, totalRun, 1 ) ).^2, 1) ./ totalRun ) / 2;
stdAccBPMCC = sqrt( sum( ( AccBPMCC - repmat( mAccBPMCC, totalRun, 1 ) ).^2, 1) ./ totalRun ) / 2;
stdAccBPMCG = sqrt( sum( ( AccBPMCG - repmat( mAccBPMCG, totalRun, 1 ) ).^2, 1) ./ totalRun ) / 2;

%All local for now, copy/paste if good results

%Plots
figure()
hold all
errorbar(1:101, mAccBPM, stdAccBPM);
errorbar(1:101, mAccSVM, stdAccSVM);
legend('BPM', 'SVM');

figure()
hold all
errorbar(1:5, mAccSVMCC, stdAccSVMCC)
errorbar(1:5, mAccSVMCG, stdAccSVMCG)
errorbar(1:5, mAccBPMCC, stdAccBPMCC)
errorbar(1:5, mAccBPMCG, stdAccBPMCG)
legend('SVMCC', 'SVMCG', 'BPMCC', 'BPMCG');

result.run = run;
result.class = class;
result.mAccSVM = mAccSVM;
result.mAccBPM = mAccBPM;
result.mAccSVMCC = mAccSVMCC;
result.mAccSVMCG = mAccSVMCG;
result.mAccBPMCC = mAccBPMCC;
result.mAccBPMCG = mAccBPMCG;
result.stdAccSVM = stdAccSVM;
result.stdAccBPM = stdAccBPM;
result.stdAccSVMCC = stdAccSVMCC;
result.stdAccSVMCG = stdAccSVMCG;
result.stdAccBPMCC = stdAccBPMCC;
result.stdAccBPMCG = stdAccBPMCG;
%save SaveName result








