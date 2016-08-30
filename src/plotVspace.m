function [ ] = plotVspace( )
%PLOTVSPACE Summary of this function goes here
%   Detailed explanation goes here

for (m=1:100)
    W = randn(3,1);

    X = randn(4,3);

    W = W / norm(W);

    for i=1:size(X,1);
        X(i,:) = X(i,:) / norm(X(i,:));
        if (X(i, :) * W <= 0)
            X(i,:) = -X(i,:);
        end
    end

    %Wscat = scale * W';
    %scatter3(Wscat(:,1), Wscat(:,2), Wscat(:,3), 50, -1 * C, 'filled')

    %[CG, Ws] = CGapprox(X);


    %Wscat = scale* CG';
    %scatter3(Wscat(:,1), Wscat(:,2), Wscat(:,3), 50, -1.1 * C, 'filled')

    % for i=1:size(Ws,2)
    %     Wscat = scale* Ws(:,i)';
    %     scatter3(Wscat(:,1), Wscat(:,2), Wscat(:,3), 50, -1.2 * C, 'filled')
    % end

    %SVM
    SVM = svmtrain( [ones(size(X,1),1); -ones(size(X,1),1)], [X; -X], '-t 0 -c 1e10'  )
    SVs = SVM.SVs;
    coef = SVM.sv_coef;
    Wsvm = 0;
    for i=1:size(SVs,1)
        Wsvm = Wsvm + coef(i) * SVs(i,:);
    end
    Wsvm = Wsvm / norm(Wsvm) * 1.1;

    %BPM
    data = bpm_task(X, ones(size(X,1), 1), 0, 'step', 0);
    EPobject = bpm_ep(data);
    classifier = train(EPobject, data);
    Wbpm = classifier.mw';
    Wbpm = Wbpm / norm(Wbpm) * 1.1;


    if (norm(Wbpm - Wsvm) > 0.34)
        figure();
        hold

        [x y] = meshgrid(-1.2:0.04:1.2);
        C = zeros(size(x));

        for i=1:size(X,1)
            z = - ( X(i,1) * x + X(i,2) * y ) / X(i,3);
            z( find(z < -1.2) ) = NaN;
            z( find(z > 1.2) ) = NaN;

            surf(x,y,z,C);
        end

        [x,y,z] = sphere(300);
        C = ones(size(x)) * Inf;

        for i=1:size(x,1)
            for j=1:size(x,1)
                for k=1:size(X,1)
                    tmp = X(k,:) * [x(i,j); y(i,j); z(i,j)];
                    if (C(i,j) == Inf)
                        C(i,j) = tmp;
                    end

                    if (C(i,j) > tmp)
                        C(i,j) = tmp;
                    end
                end

                if (C(i,j) <= 0)
                    C(i,j) = -1;
                else
                    C(i,j) = 1;
                end
            end
        end

        surf(x,y,z,C, 'EdgeColor', 'none');

        scale = 1:1;
        scale = scale';
        C = ones(size(scale,1), 1);

        scatter3(Wsvm(:,1), Wsvm(:,2), Wsvm(:,3), 300, -2, 'filled')
        scatter3(Wbpm(:,1), Wbpm(:,2), Wbpm(:,3), 300, -3, 'filled')


        Wbpm
        Wsvm
        Wbpm - Wsvm
        norm(Wbpm - Wsvm)


        axis([-2 2 -2 2 -2 2]);
        box on
        grid on
    else
        disp('Too close')
    end
end






end



