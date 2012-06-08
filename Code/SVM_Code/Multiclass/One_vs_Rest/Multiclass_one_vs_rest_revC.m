% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Multiclass - one-vs-rest
% Gregory Gutshall
% Date: 06/03/2012
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is used for testing the two class linear SVM, with the
% one-versus-rest multiclass criteria.  See page.338 in Bishop

% Load in the orginal Test Parameterizations
load('..\Parameterizations');

% Knock off class labels -1 and 0, since they are deterministically found
X = ScaledTheta(y>0,:);
y = y(y>0);

% Define the class labels explicently
label = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

% Subsample 60 samples from each class
sample = 60;
%Xsub = zeros(sample*length(label),size(X,2));
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

K = 0.01:0.01:1;
lambda = 1:10:1000;
accuracy_matrix = zeros(length(K),length(lambda));
tic;
for k=1:length(K)
    display(['iter: ',num2str(k)]);
    for ell=1:length(lambda)
        % Loop through each label, assigning it to class +1 and all others to class
        % -1.  Then perform the training with a grid search for the appropriate
        % trade-off parameter (lambda) and slack variable (eta).  Choose the lambda
        % and eta with the maximum classification accuracy and save the resulting
        % weight vector and bias term.  Do this for all labels.
        wT = zeros(length(label),size(Xsub,2));
        b = zeros(length(label),1);
        accuracy = zeros(length(label),1);
        for i=1:length(label)
            idx_1   = find(label == label(i)); % The ONE, label being classified
            idx_r   = find(label ~= label(i)); % The REST
            
            % Assign +1 to the current label being classified, -1 to everybody else
            y_lab = ones(size(ysub));
            y_lab(ysub ~= label(i)) = -1;
            
            % Course Grid Search eta and lambda
            [wT(i,:),b(i),accuracy(i)] = pegasos(Xsub,y_lab,lambda(ell),K(k),[],[]);
        end
        
        % Find the accuracy
        Mv = zeros(size(X,1),1);        % Max Value
        Midx = zeros(size(X,1),1);      % Max Index/Prediction
        for ex = 1:size(X,1)
            prediction_labels = zeros(length(label),1);
            
            % Loop through each class label
            for i=1:length(label)
                prediction_labels(i) = (wT(i,:)*X(ex,:)');
            end
            
            % Max value is used, since actual label was assigned to +1
            [Mv(ex), Midx(ex)] = max(prediction_labels);
            
        end
        error = abs(y - Midx);
        error = sum(error > 1);
        accuracy_matrix(k,ell) = (1 - error/length(y))*100;
    end
end
Elapsed_time  = toc;

save 'xyz';


