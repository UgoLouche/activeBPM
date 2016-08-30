function [] = MTBananaSlidePlot()

%Learn SVM & BPM with max 150 query, show queried points and boundary
%evolution


%Load Data and sample
disp('Loading / Sorting Data')

load benchmarks banana
% Xraw = banana.x;
% Yraw = banana.t;

Xraw = rand(5300, 2) * 8 - 4;
Yraw = double(sin(Xraw(:,1)*2) < (Xraw(:,2)) / 2);
Yraw(Yraw == 0) = -1;

R = rand( size( banana.t ) );
[~, order] = sort(R);
Xraw = Xraw(order, :);
Yraw = Yraw(order);

X = Xraw(1:2000, :);
Y = Yraw(1:2000);

Cuts =  [ Xraw(2001:2001, :) ];
CutsY = [ Yraw(2001:2001   ) ];

Kernel = @(x1, x2) RBFKernel(x1, x2, 0.5);


disp('Learning Active-BPM, 100 Queries')
[~, ~, BPM_CutsInd] = MTActiveBPM(X, Y, Cuts, CutsY, Kernel, 100);

disp('Learning Active-SVM, 100 Queries')
[~, ~, SVM_CutsInd] = MTActiveSVM(X, Y, Cuts, CutsY, Kernel, 100);


disp('Setting meshgrid')
[A B] = meshgrid(-4:0.025:4, -4:0.025:4);
VectGrid = zeros( size(A,1) * size(A,2), 2 );
for i=1:size(A,1)
    for j=1:size(A,2)
        %inverted A and B don't panic
        VectGrid( (i-1)*size(A,1) + j, : ) = [B(i,j), A(i,j)];
    end
end


disp('Making Predictions and plots')

fig = figure('Position', [400 400 1200 512]);

for step=1:100
    
    %First retrieve the training set at each step
    SVM_Xtr = [ Cuts ; X( SVM_CutsInd(2:step), : ) ];
    SVM_Ytr = [ CutsY; Y( SVM_CutsInd(2:step)    ) ];
    BPM_Xtr = [ Cuts ; X( BPM_CutsInd(2:step), : ) ];
    BPM_Ytr = [ CutsY; Y( BPM_CutsInd(2:step)    ) ];
    
    %Learn a classifier
    SVM_class = MTlearnSVM(SVM_Xtr, SVM_Ytr, Kernel);
    BPM_class = MTlearnBPM(BPM_Xtr, BPM_Ytr, Kernel);
    
    %Make predictions
    SVM_C = MTPredict(VectGrid, SVM_class, 'SVM');
    BPM_C = MTPredict(VectGrid, BPM_class, 'BPM');
    
    SVM_C2 = reshape( SVM_C, size(A) );
    BPM_C2 = reshape( BPM_C, size(A) );
    
    SVM_Ytr = MTPredict(X, SVM_class, 'SVM');
    BPM_Ytr = MTPredict(X, BPM_class, 'BPM');
    
    %Misc
    lastQ = size(SVM_Xtr, 1);
    
    %Plot
    clf
    subplot(1,2,1)
    xlim([-4 4]);
    ylim([-4 4]);
    hold all
    scatter( X(:,1), X(:,2), 5, Y, 's', 'filled');
    scatter( SVM_Xtr(:,1), SVM_Xtr(:,2), 50, 'om', 'filled');
    scatter( SVM_Xtr( lastQ ,1), SVM_Xtr( lastQ ,2), 100, 'oc', 'filled');
    contour(A, B, SVM_C2, 1, 'm', 'LineWidth', 5);
    subplot(1,2,2)
    xlim([-4 4]);
    ylim([-4 4]);
    hold all
    scatter( X(:,1), X(:,2), 5, Y, 's', 'filled');
    scatter( BPM_Xtr(:,1), BPM_Xtr(:,2), 75, 'og', 'filled');
    scatter( BPM_Xtr( lastQ ,1), BPM_Xtr( lastQ ,2), 100, 'oc', 'filled');
    contour(A, B, BPM_C2, 1, 'g', 'LineWidth', 5);
    
    frame = getframe(fig);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if step == 1;
      imwrite(imind, cm, 'test.gif', 'gif', 'Loopcount', inf     );
    else
      imwrite(imind, cm, 'test.gif', 'gif', 'WriteMode', 'append');
    end
    
end



end









































