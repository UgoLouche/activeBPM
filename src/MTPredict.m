function [ Ypred, Margins ] = MTPredict( X, Classifier, Type, Y )
%X : new data
%Classifier : Classifier
%Type ('BPM' or 'SVM') : Type of classifier
%Y : True label (optional, for accuracy display)
%%%
%Ypred : Prediction
%Margins : Margins

if strcmp(Type, 'SVM')
    
    Kernel = Classifier.Kernel;
    Xtr = Classifier.Xtr;
    
    K = [ ( 1:size(X,1) )', Kernel(X, Xtr) ];
    
    [ Ypred, ~, Margins ] = svmpredict( ones( size(X,1), 1 ),  K, ...
        Classifier.model, '-q');
    
elseif strcmp(Type, 'BPM')
    
    K = Classifier.kernel(X, Classifier.X);
    
    Margins = K * ( Classifier.Y .* Classifier.alpha );
    Ypred = sign(Margins);
    
else
    disp(['Unknown Classifier Type : "' Type '"']);
end

if nargin > 3 %Display Accuracy
    Err = sum(Ypred ~= Y);
    Acc = 1- ( Err / size(Y,1) );
    
    disp(['(Errors, Accuracy) = (' num2str(Err) ', ' num2str(Acc) ')']);
end

end