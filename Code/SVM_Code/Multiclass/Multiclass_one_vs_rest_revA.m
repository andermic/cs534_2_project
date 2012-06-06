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
ScaledTheta = ScaledTheta(y>0,:);
y = y(y>0);

% Define the class labels explicently
label = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

% Loop through each label, assigning it to class +1 and all others to class
% -1.  Then perform the training with a grid search for the appropriate
% trade-off parameter (lambda) and slack variable (eta).  Choose the lambda
% and eta with the maximum classification accuracy and save the resulting
% weight vector and bias term.  Do this for all labels.

for i=1:length(label)
    idx_1   = find(label == label(i)); % The ONE, label being classified
    idx_r   = find(label ~= label(i)); % The REST
    
    % Assign +1 to the current label being classified, -1 to everybody else
    y_lab = ones(size(y));
    y_lab(y ~= label(i)) = -1;
    
    % Course Grid Search eta and lambda
    eta = 0:0.1:1;
    lambda = 1:0.1:5;
    accuracy = zeros(length(eta),length(lambda));
    for j = 1:length(eta)
        for k = 1:length(lambda)
            [wT,b,accuracy(j,k)] = pegasos(ScaledTheta,y_lab,lambda(k),[],[],[]);
        end
    end
    
    [temp,inx_M] = max(accuracy);
    
end

