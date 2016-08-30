function [ Y margins ] = KPredict( X, Classifier)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

Xs = Classifier.Xs;
W = Classifier.W;
Kernel = Classifier.Kernel;

margins = Kernel(X, Xs) * W;
margins = margins';

Y(margins <= 0) = -1;
Y(margins > 0) = 1;


end

