function [ classifier ] = MTlearnBPM(X, Y, Kernel)
%X : Dataset
%Y : Labels
%Kernel : Kernel Function
%%%
%Classifier : The learned classifier

data = bpm_task(X, Y, 0, 'step', 0, Kernel);
EPobject = bpm_ep(data);

classifier = train(EPobject, data);

end

