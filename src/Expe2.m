clear all

disp('Loading Reuters');
load Reuters21578.mat
Xte = fea(testIdx, :);
Yte = gnd(testIdx, 1);
Xtr = fea(trainIdx, :);
Ytr = gnd(trainIdx, 1);

trainSize = size(trainIdx,1);
testSize = size(testIdx, 1);

nbRun = 10;
maxLabel = 20;
nbClass = 2;
Kernel = @(x1, x2) PolyKernel(x1, x2, 1, 0, 3);
step = 10;

AccCCSVM500 = zeros(nbClass,maxLabel);
AccCCSVM1000 = zeros(nbClass,maxLabel);

AccCCBPM500 = zeros(nbClass,maxLabel);
AccCCBPM1000 = zeros(nbClass,maxLabel);

AccCCPerc500 = zeros(nbClass,maxLabel);
AccCCPerc1000 = zeros(nbClass,maxLabel);

AccCGSVM500 = zeros(nbClass,maxLabel);
AccCGSVM1000 = zeros(nbClass,maxLabel);

AccCGBPM500 = zeros(nbClass,maxLabel);
AccCGBPM1000 = zeros(nbClass,maxLabel);

AccCGPerc500 = zeros(nbClass,maxLabel);
AccCGPerc1000 = zeros(nbClass,maxLabel);

for k=1:nbClass
    disp(['- Class : ' num2str(k)])
    disp('- Preprocessing...')
    Ytrain = Ytr;
    Xtrain = Xtr;
    Ytest = Yte;
    Xtest = Xte;
    
    Ytrain(Ytrain ~= k) = -1;
    Ytrain(Ytrain == k) = 1;
    Ytest(Ytest ~= k) = -1;
    Ytest(Ytest == k) = 1;
    
    %Swtich Xtest
    for i=1:testSize
        Xtest(i,:) = Ytest(i,1) * Xtest(i,:);
    end
    disp('- Done')
    
    
    for r=1:nbRun
       disp(['-- Entering Run : ' num2str(r)])
       disp('-- Sampling') 
       %Sampling 500 and 1000 training Set
       [~, order] = sort( rand(trainSize, 1) );
       Xorder = Xtrain(order, :);
       Yorder = Ytrain(order, 1);
       %Give two examples
       GivenCuts = [Yorder(1)*Xorder(1,:); ...
                    Yorder(2)*Xorder(2,:)] ; 
       X1000 = Xorder(3:1000, :);
       Y1000 = Yorder(3:1000, 1);
       X500 = Xorder(3:500, :);
       Y500 = Yorder(3:500, 1); 

       for i=1:maxLabel
           disp(['--- Max Label : ' num2str(i*step)])
           %
           %
           %500
           %
           %

           %
           %CC Cutting Planes
           %
           disp('--- CC Query, 500 Sample')
           [~, Cuts] = KactiveSVM( ...
               X500, Y500, GivenCuts, Kernel, step*i);

           Ksvm = Kernel([Cuts; -Cuts], [Cuts; -Cuts]); %for SVM
           Ksvm = [(1:2*(2+step*i))', Ksvm]; %2+i -> Two given + i
           Ysvm = [ones(2+i*step,1); -ones(2+i*step,1)];
           K = Kernel(Cuts, Cuts);

           %train Classifiers
           SVM = svmtrain(Ysvm, Ksvm, '-t 4 -c 100000000000000000 -q');
           CG = KCGapprox(K);
           Perc = KperceptronCP_train(K, 0);
           Perc = Perc.W;
           Classifier.Xs = Cuts;
           Classifier.Kernel = Kernel;

        
           %Get accuracy
           Ksvm = Kernel(Xtest, [Cuts; -Cuts]);
           Ksvm = [(1:testSize)', Ksvm];
           %K = Kernel(Xtest, Cuts);

           [~, AccSVM, ~] = svmpredict(ones(testSize,1), Ksvm, SVM, '-q');
           
           Classifier.W = CG;
           [Y, ~] = Kpredict(Xtest, Classifier);
           AccCG = sum(Y > 0) / testSize;

           Classifier.W = Perc;
           [Y, ~] = Kpredict(Xtest, Classifier);
           AccPerc = sum(Y > 0) / testSize;

           AccCCSVM500(k,i) = AccCCSVM500(k,i) + AccSVM(1,1);
           AccCCBPM500(k,i) = AccCCBPM500(k,i) + AccCG;
           AccCCPerc500(k,i) = AccCCPerc500(k,i) + AccPerc;


           %
           %CG Cutting Planes
           %
           disp('--- CG Query, 500 Sample')
           [~, Cuts] = KactiveCP( ...
               X500, Y500, GivenCuts, Kernel, step*i);

           Ksvm = Kernel([Cuts; -Cuts], [Cuts; -Cuts]); %for SVM
           Ksvm = [(1:2*(2+i*step))', Ksvm]; %2+i -> Two given + i
           Ysvm = [ones(2+i*step,1); -ones(2+i*step,1)];
           K = Kernel(Cuts, Cuts);

           %train Classifiers
           SVM = svmtrain(Ysvm, Ksvm, '-t 4 -c 100000000000000000 -q');
           CG = KCGapprox(K);
           Perc = KperceptronCP_train(K, 0);
           Perc = Perc.W;
           Classifier.Xs = Cuts;
           Classifier.Kernel = Kernel;


           %Get accuracy
           Ksvm = Kernel(Xtest, [Cuts; -Cuts]);
           Ksvm = [(1:testSize)', Ksvm];
           %K = Kernel(Xtest, Cuts);

           [~, AccSVM, ~] = svmpredict(ones(testSize,1), Ksvm, SVM, '-q');

           Classifier.W = CG;
           [Y, ~] = Kpredict(Xtest, Classifier);
           AccCG = sum(Y > 0) / testSize;

           Classifier.W = Perc;
           [Y, ~] = Kpredict(Xtest, Classifier);
           AccPerc = sum(Y > 0) / testSize;

           AccCGSVM500(k,i) = AccCGSVM500(k,i) + AccSVM(1,1);
           AccCGBPM500(k,i) = AccCGBPM500(k,i) + AccCG;
           AccCGPerc500(k,i) = AccCGPerc500(k,i) + AccPerc;

           %
           %
           %1000
           %
           %
           %
           %CC Cutting Planes
           %
           disp('--- CC Query, 1000 Sample')
           [~, Cuts] = KactiveSVM( ...
               X1000, Y1000, GivenCuts, Kernel, step*i);

           Ksvm = Kernel([Cuts; -Cuts], [Cuts; -Cuts]); %for SVM
           Ksvm = [(1:2*(2+i*step))', Ksvm]; %2+i -> Two given + i
           Ysvm = [ones(2+i*step,1); -ones(2+i*step,1)];
           K = Kernel(Cuts, Cuts);

           %train Classifiers
           SVM = svmtrain(Ysvm, Ksvm, '-t 4 -c 100000000000000000 -q');
           CG = KCGapprox(K);
           Perc = KperceptronCP_train(K, 0);
           Perc = Perc.W;
           Classifier.Xs = Cuts;
           Classifier.Kernel = Kernel;


           %Get accuracy
           Ksvm = Kernel(Xtest, [Cuts; -Cuts]);
           Ksvm = [(1:testSize)', Ksvm];
           %K = Kernel(Xtest, Cuts);

           [~, AccSVM, ~] = svmpredict(ones(testSize,1), Ksvm, SVM, '-q');

           Classifier.W = CG;
           [Y, ~] = Kpredict(Xtest, Classifier);
           AccCG = sum(Y > 0) / testSize;

           Classifier.W = Perc;
           [Y, ~] = Kpredict(Xtest, Classifier);
           AccPerc = sum(Y > 0) / testSize;

           AccCCSVM1000(k,i) = AccCCSVM1000(k,i) + AccSVM(1,1);
           AccCCBPM1000(k,i) = AccCCBPM1000(k,i) + AccCG;
           AccCCPerc1000(k,i) = AccCCPerc1000(k,i) + AccPerc;


           %
           %CG Cutting Planes
           %
           disp('--- CG Query, 1000 Sample')
           [~, Cuts] = KactiveCP( ...
               X1000, Y1000, GivenCuts, Kernel, step*i);

           Ksvm = Kernel([Cuts; -Cuts], [Cuts; -Cuts]); %for SVM
           Ksvm = [(1:2*(2+i*step))', Ksvm]; %2+i -> Two given + i
           Ysvm = [ones(2+i*step,1); -ones(2+i*step,1)];
           K = Kernel(Cuts, Cuts);

           %train Classifiers
           SVM = svmtrain(Ysvm, Ksvm, '-t 4 -c 100000000000000000 -q');
           CG = KCGapprox(K);
           Perc = KperceptronCP_train(K, 0);
           Perc = Perc.W;
           Classifier.Xs = Cuts;
           Classifier.Kernel = Kernel;


           %Get accuracy
           Ksvm = Kernel(Xtest, [Cuts; -Cuts]);
           Ksvm = [(1:testSize)', Ksvm];
           %K = Kernel(Xtest, Cuts);

           [~, AccSVM, ~] = svmpredict(ones(testSize,1), Ksvm, SVM, '-q');

           Classifier.W = CG;
           [Y, ~] = Kpredict(Xtest, Classifier);
           AccCG = sum(Y > 0) / testSize;

           Classifier.W = Perc;
           [Y, ~] = Kpredict(Xtest, Classifier);
           AccPerc = sum(Y > 0) / testSize;

           AccCGSVM1000(k,i) = AccCGSVM1000(k,i) + AccSVM(1,1);
           AccCGBPM1000(k,i) = AccCGBPM1000(k,i) + AccCG;
           AccCGPerc1000(k,i) = AccCGPerc1000(k,i) + AccPerc;


       end
    end
   
   
   Result.AccCCSVM500 = AccCCSVM500;
   Result.AccCCSVM1000 = AccCCSVM1000;
   
   Result.AccCCBPM500 = AccCCBPM500;
   Result.AccCCBPM1000 = AccCCBPM1000;
   
   Result.AccCCPerc500 = AccCCPerc500;
   Result.AccCCPerc1000 = AccCCPerc1000;
   
   
   Result.AccCGSVM500 = AccCGSVM500;
   Result.AccCGSVM1000 = AccCGSVM1000;
   
   Result.AccCGBPM500 = AccCGBPM500;
   Result.AccCGBPM1000 = AccCGBPM1000;
   
   Result.AccCGPerc500 = AccCGPerc500;
   Result.AccCGPerc1000 = AccCGPerc1000; 
   
   Result.nbRun = nbRun;
   Result.step = step;
   
   save Expe2 Result
    
end