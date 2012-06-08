% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Multiclass - one-vs-one
% Gregory Gutshall
% Date: 06/03/2012
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is used for testing the two class linear SVM, with the
% one-versus-one multiclass criteria.  See page.338 in Bishop

% Load in the orginal Test Parameterizations
load('..\..\Parameterizations');

% Knock off class labels -1 and 0, since they are deterministically found
X = ScaledTheta(y>0,:);
y = y(y>0);

% Define the class labels explicently
label = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

% Subsample 60 samples from each class
sample = 60;
for i=1:length(label)
    idx = find(y == label(i));
    idx = idx(randperm(length(idx),sample));  % Select 60 random samples from that class
    
    if (i > 1)
        Xsub = [Xsub ; X(idx,:)];
        ysub = [ysub ; y(idx,:)];
    else
        Xsub = X(idx,:);
        ysub = y(idx);
    end
    
end


W = cell(length(label),length(label)-1);
B = zeros(length(label),length(label)-1);
K = 0.1:0.1:0.5;
lambda = 1:10:100;
accuracy_matrix = zeros(length(K),length(lambda));
% Assign +1 to the current label being classified, -1 to the other
y_lab = [ones(sample,1); -1*ones(sample,1)];      
tic;
for i=1:length(label)
    display(['Label Iter:',num2str(i),'/',num2str(length(label))]);

    % Find the required indexes
    idx_1   = find(label == label(i)); % The ONE, label being classified
    idx_r   = find(label ~= label(i)); % The REST

    % Loop over all K(K-1)/2 possiblities
    for r=1:length(idx_r)
        display(['   Inner-Label Iter:',num2str(r),'/',num2str(length(idx_r))]);
        % Create a test feature sub matrix of the ONE and REST
        X_lab = [Xsub(find(ysub == label(idx_1)),:) ; Xsub(find(ysub == label(idx_r(r))),:)];

        % Grid Search over K and Lambda
        wT = cell(length(K),length(lambda));
        b = zeros(length(K),length(lambda));
        accuracy = zeros(length(K),length(lambda));
        for k=1:length(K) 
            for ell=1:length(lambda)
                [wT{k,ell},b(k,ell),accuracy(k,ell)] = pegasos(X_lab,y_lab,lambda(ell),K(k),[],[]);
            end
        end
        % Get the best value for Lambda and K
        [maxaccuracy,ind] = max(accuracy(:));
        [Kimax,Lambdaimax] = ind2sub(size(accuracy),ind);

        % Store the wT and b for the max accuracy
        W{i,r} = wT{Kimax,Lambdaimax};
        B(i,r) = b(Kimax,Lambdaimax);
    end

end
elapsed_time = toc;

save 'xyz';

% Testing
% Find the accuracy
% Mv = zeros(size(X,1),1);        % Max Value
% Midx = zeros(size(X,1),1);      % Max Index/Prediction
% for ex = 1:size(X,1)
%     prediction_labels = zeros(length(label),1);
%     
%     % Loop through each class label
%     for i=1:length(label)
%         prediction_labels(i) = (wT(i,:)*X(ex,:)');
%     end
%     
%     % Max value is used, since actual label was assigned to +1
%     [Mv(ex), Midx(ex)] = max(prediction_labels);
%     
% end
% error = abs(y - Midx);
% error = sum(error > 1);
% accuracy_matrix(k,ell) = (1 - error/length(y))*100;


