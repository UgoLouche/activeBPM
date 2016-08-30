function [W] = minkaBPM(X, Y, kernel)

if nargin > 2
    data = bpm_task(X, Y, 0, 'step', 0, kernel);
else
    data = bpm_task(X, Y, 0); %0 is for bias
end

EPobject = bpm_ep(data);

classifier = train(EPobject, data);

if nargin > 2
   W = classifier.alpha; 
else
    W = classifier;
    %W = classifier.mw';
    %W = W / norm(W);
end

end