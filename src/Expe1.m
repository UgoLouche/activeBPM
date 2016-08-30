Opt1.Query = @PerceptronCP_train;
Opt1.CP_Oracle = @MaxMargin_Oracle;

Opt2.Query = @PerceptronCP_train;
Opt2.CP_Oracle = @MinMargin_Oracle;

Opt3.Query = @PerceptronCP_train;
Opt3.CP_Oracle = @Rnd_Oracle;



for r=1:1000
    disp(['run' num2str(r)]);
    
    [X maxRange minmargin] = genToy();
    

    [~, update1, percUp1, ~] = CuttingPlanes(X, Opt1);

    [~, update2, percUp2, ~] = CuttingPlanes(X, Opt2);

    [~, update3, percUp3, ~] = CuttingPlanes(X, Opt3);
    
    maxUp = max([update1 update2 update3]);
    
    for i=1:(update1-1)
        if (r == 1)
            if (i == 1)
                UpPerCP1 = percUp1(i);
                NbElem1 = 1;
            else
                UpPerCP1 = [UpPerCP1 percUp1(i)];
                NbElem1 = [NbElem1 1];
            end
        else
            if (size(UpPerCP1,2) == i-1)
                UpPerCP1 = [UpPerCP1 percUp1(i)];
                NbElem1 = [NbElem1 1];
            else
                UpPerCP1(i) = UpPerCP1(i) + percUp1(i);
                NbElem1(i) = NbElem1(i)+1;
            end
        end
    end
    
    for i=1:(update2-1)
        if (r == 1)
            if (i == 1)
                UpPerCP2 = percUp2(i);
                NbElem2 = 1;
            else
                UpPerCP2 = [UpPerCP2 percUp2(i)];
                NbElem2 = [NbElem2 1];
            end
        else
            if (size(UpPerCP2,2) == i-1)
                UpPerCP2 = [UpPerCP2 percUp2(i)];
                NbElem2 = [NbElem2 1];
            else
                UpPerCP2(i) = UpPerCP2(i) + percUp2(i);
                NbElem2(i) = NbElem2(i)+1;
            end
        end
    end
    
    for i=1:(update3-1)
        if (r == 1)
            if (i == 1)
                UpPerCP3 = percUp3(i);
                NbElem3 = 1;
            else
                UpPerCP3 = [UpPerCP3 percUp3(i)];
                NbElem3 = [NbElem3 1];
            end
        else
            if (size(UpPerCP3,2) == i-1)
                UpPerCP3 = [UpPerCP3 percUp3(i)];
                NbElem3 = [NbElem3 1];
            else
                UpPerCP3(i) = UpPerCP3(i) + percUp3(i);
                NbElem3(i) = NbElem3(i)+1;
            end
        end
    end    
end

for i=1:size(UpPerCP1,2)
    UpPerCP1(i) = UpPerCP1(i) / NbElem1(i);
end
for i=1:size(UpPerCP2,2)
    UpPerCP2(i) = UpPerCP2(i) / NbElem2(i);
end
for i=1:size(UpPerCP3,2)
    UpPerCP3(i) = UpPerCP3(i) / NbElem3(i);
end

maxSize = max( ...
    [size(UpPerCP1,2) size(UpPerCP2,2) size(UpPerCP3,2)]);

if (size(UpPerCP1,2) ~= maxSize)
    UpPerCP1 = [UpPerCP1 ...
        zeros(1, maxSize-size(UpPerCP1,2))];
    NbElem1 = [NbElem1 ...
        zeros(1, maxSize-size(NbElem1,2))];
end
if (size(UpPerCP2,2) ~= maxSize)
    UpPerCP2 = [UpPerCP2 ...
        zeros(1,maxSize-size(UpPerCP2,2))];
    NbElem2 = [NbElem2 ...
        zeros(1, maxSize-size(NbElem2,2))];
end
if (size(UpPerCP3,2) ~= maxSize)
    UpPerCP3 = [UpPerCP3 ...
        zeros(1,maxSize-size(UpPerCP3,2))];
    NbElem3 = [NbElem3 ...
        zeros(1, maxSize-size(NbElem3,2))];
end

%Plot time, season 1
UpPerCP = [UpPerCP1; UpPerCP2; UpPerCP3];
NbElem = [NbElem1; NbElem2; NbElem3];
x = 1:maxSize;
figure();
bar(x, UpPerCP');
legend('Biggest Error', 'Smallest Error', 'Random Error')
xlabel('CP iteration')
ylabel('# internal Perceptron updates')
save UpPerCP UpPerCP

figure();
bar(x, NbElem'/1000);
legend('Biggest Error', 'Smallest Error', 'Random Error')
xlabel('Cutting Plane')
ylabel('Aparation Frequency')

ind = 1:size(0.01:0.01:0.3, 2);
NbCP1 = zeros(size(ind));
NbCP2 = zeros(size(ind));
NbCP3 = zeros(size(ind));

NbUp1 = zeros(size(ind));
NbUp2 = zeros(size(ind));
NbUp3 = zeros(size(ind));
NbUp4 = zeros(size(ind));

step = 0;

for i=0.01:0.01:0.3
    step = step + 1;
    disp(['margin : ' num2str(i)]);
    for r=1:1000
        [X maxRange minmargin] = genToy(1000, i);

        [~, update1, percUp1, ~] = CuttingPlanes(X, Opt1);

        [~, update2, percUp2, ~] = CuttingPlanes(X, Opt2);

        [~, update3, percUp3, ~] = CuttingPlanes(X, Opt3);
        
        [~, percUp4] = PerceptronCP_train(X, zeros(2,1), X(1,:));

        NbCP1(step) = NbCP1(step) + update1 - 1;
        NbUp1(step) = NbUp1(step) + sum(percUp1);

        NbCP2(step) = NbCP2(step) + update2 - 1;
        NbUp2(step) = NbUp2(step) + sum(percUp2);

        NbCP3(step) = NbCP3(step) + update3 - 1;
        NbUp3(step) = NbUp3(step) + sum(percUp3);
        
        NbUp4(step) = NbUp4(step) + percUp4;

        if (r == 1000)
            NbCP1(step) = NbCP1(step)/1000;
            NbUp1(step) = NbUp1(step)/1000;
            
            NbCP2(step) = NbCP2(step)/1000;
            NbUp2(step) = NbUp2(step)/1000;
            
            NbCP3(step) = NbCP3(step)/1000;
            NbUp3(step) = NbUp3(step)/1000;
            
            NbUp4(step) = NbUp4(step)/1000;
        end
    end
end

figure()
plot(ind/100, NbCP1, '-', ...
    ind/100, NbCP2, '+-', ...
    ind/100, NbCP3, '*-')
legend('Biggest error','Smallest Error','Random Error')
xlabel('Margin')
ylabel('# of cutting planes')
NbCP.Biggest = NbCP1;
NbCP.Smallest = NbCP2;
NbCP.Random = NbCP3;
save NbCP NbCP

figure()
plot(ind/100, NbUp1, '-', ...
    ind/100, NbUp2, '+-',  ...
    ind/100, NbUp3, '*-',  ...
    ind/100, NbUp4, '--')
legend('Biggest Error', 'Smallest Error', 'Random Error', 'Perceptron')
xlabel('Margin')
ylabel('Total number of Perceptron Update')
NbUp.Biggest = NbUp1;
NbUp.Smallest = NbUp2;
NbUp.Random = NbUp3;
NbUp.Perc = NbUp4;
save NbUp NbUp

































