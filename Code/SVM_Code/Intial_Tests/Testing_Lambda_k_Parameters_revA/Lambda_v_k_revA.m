% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Multiclass - one-vs-rest
% Gregory Gutshall
% Date: 06/03/2012
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is used for testing the two class linear SVM, with the
% one-versus-rest multiclass criteria.  See page.338 in Bishop

% Load in the orginal Test Parameterizations
%load('..\..\Parameterizations');

% Define the classes you want to grab
% Note, you might want to grab to very seperate classes
Class1 = 10;
Class2 = 15;

% Create new variables Theta and y to hold the reduced dataset
Class1_indexes = find(y == Class1);
Class2_indexes = find(y == Class2);

y_reduced = zeros((length(Class1_indexes) + length(Class2_indexes)),1);
ScaledTheta_reduced = zeros((length(Class1_indexes) + length(Class2_indexes)),5);

% Assign +1 and -1 to y_reduced
y_reduced(1:length(Class1_indexes)) = 1;
y_reduced(length(Class1_indexes)+1:length(y_reduced)) = -1;

% Assign reduced dataset to Theta_reduced
ScaledTheta_reduced(1:length(Class1_indexes),:) = ScaledTheta(Class1_indexes,:);
ScaledTheta_reduced(length(Class1_indexes)+1:length(y_reduced),:) = ScaledTheta(Class2_indexes,:);
    
% Course Grid Search eta and lambda
tic;
k = 0.01:0.01:0.5;
lambda = 3.5:0.01:5;
accuracy = zeros(length(k),length(lambda));
for j = 1:length(k)
    display(['iter: ',num2str(j),'/',num2str(length(k))]);
    for i = 1:length(lambda)
        [wT,b,accuracy(j,i)] = pegasos(ScaledTheta_reduced,y_reduced ,lambda(i),k(j),[],[]);
    end
end
toc;

save 'xyz'
    

