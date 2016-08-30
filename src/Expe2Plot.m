clear all

load Expe2

maxLabel = size(Result.AccCCSVM500, 2);
nbClasses = size(Result.AccCCSVM500, 1);
nbRun = Result.nbRun;
step = Result.step;
x = 1:step:step*maxLabel;


AccCCSVM500 = Result.AccCCSVM500/(100*nbRun);
AccCCSVM1000 = Result.AccCCSVM1000/(100*nbRun);

AccCCBPM500 = Result.AccCCBPM500/nbRun;
AccCCBPM1000 = Result.AccCCBPM1000/nbRun;

AccCCPerc500 = Result.AccCCPerc500/nbRun;
AccCCPerc1000 = Result.AccCCPerc1000/nbRun;


AccCGSVM500 = Result.AccCGSVM500/(100*nbRun);
AccCGSVM1000 = Result.AccCGSVM1000/(100*nbRun);

AccCGBPM500 = Result.AccCGBPM500/nbRun;
AccCGBPM1000 = Result.AccCGBPM1000/nbRun;

AccCGPerc500 = Result.AccCGPerc500/nbRun;
AccCGPerc1000 = Result.AccCGPerc1000/nbRun;


for i=1:nbClasses
    figure()
    plot(x, AccCCSVM500(i,:), '-o', x, AccCCBPM500(i,:), '-s', x, AccCCPerc500(i,:), '-x')
    xlabel('# of Query')
    ylabel('Accuracy')
    title(['CC-based query, 500 Samples, class ' num2str(i)])
    legend('SVM', 'BPM', 'Perceptron')
    
    figure()
    plot(x, AccCCSVM1000(i,:), x, AccCCBPM1000(i,:), x, AccCCPerc1000(i,:))
    xlabel('# of Query')
    ylabel('Accuracy')
    title(['CC-based query, 1000 Samples, class ' num2str(i)])
    legend('SVM', 'BPM', 'Perceptron')
    
    figure()
    plot(x, AccCGSVM500(i,:), x, AccCGBPM500(i,:), x, AccCGPerc500(i,:))
    xlabel('# of Query')
    ylabel('Accuracy')
    title(['CG-based query, 500 Samples, class ' num2str(i)])
    legend('SVM', 'BPM', 'Perceptron')
    
    figure()
    plot(x, AccCGSVM1000(i,:), x, AccCGBPM1000(i,:), x, AccCGPerc1000(i,:))
    xlabel('# of Query')
    ylabel('Accuracy')
    title(['CG-based query, 1000 Samples, class ' num2str(i)])
    legend('SVM', 'BPM', 'Perceptron')
    
end

