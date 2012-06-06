% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Multiclass - one-vs-rest
% Gregory Gutshall
% Date: 06/03/2012
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is used for testing the two class linear SVM, with the
% one-versus-rest multiclass criteria.  See page.338 in Bishop

% Load in the orginal Test Parameterizations
load('..\Parameterizations');

% Define the classes you want to grab
% Note, you might want to grab to very seperate classes
Class1 = 3;
Class2 = 4;

% Create new variables Theta and y to hold the reduced dataset
Class1_indexes = find(y == Class1);
Class2_indexes = find(y == Class2);

% Intialize space
y_reduced = zeros((length(Class1_indexes) + length(Class2_indexes)),1);
ScaledTheta_reduced = zeros((length(Class1_indexes) + length(Class2_indexes)),5);

% Assign +1 and -1 to y_reduced
y_reduced(1:length(Class1_indexes)) = 1;
y_reduced(length(Class1_indexes)+1:length(y_reduced)) = -1;

% Assign reduced dataset to ScaledTheta_reduced
ScaledTheta_reduced(1:length(Class1_indexes),:) = ScaledTheta(Class1_indexes,:);
ScaledTheta_reduced(length(Class1_indexes)+1:length(y_reduced),:) = ScaledTheta(Class2_indexes,:);

% Loop through each label, assigning it to class +1 and all others to class
% -1.  Then perform the training with a grid search for the appropriate
% trade-off parameter (lambda) and slack variable (gamma).  Choose the lambda
% and gamma with the maximum classification accuracy and save the resulting
% weight vector and bias term.  Do this for all labels.


% Course Grid Search gamma and lambda
[wT,b,accuracy] = pegasos_rbf(ScaledTheta_reduced,y_reduced,1,[],[],[],1.2);
% gamma = 0.1:0.1:5;
% lambda = 0.1:0.1:5;
% accuracy = zeros(length(gamma),length(lambda));
% for j = 1:length(gamma)
%     display(['iter: ',num2str(j),'/',num2str(length(gamma))]);
%     for k = 1:length(lambda)
%         [wT,b,accuracy(j,k)] = pegasos_rbf(ScaledTheta_reduced,y_reduced,lambda(k),[],[],[],gamma(j));
%     end
% end
    

