function [ classifier ] = MTlearnSVM(X, Y, Kernel)
%X : Dataset
%Y : Labels
%Kernel : Kernel Function
%%%
%Classifier : The learned classifier

K = [ ( 1:size(X,1) )', Kernel(X, X) ];

classifier.model = svmtrain(Y, K, '-t 4 -c 1e10 -q');
classifier.Xtr = X;
classifier.Kernel = Kernel;

end


