% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reduce the Parameterization for y \in [-1,1]
% Gregory Gutshall
% Date: 05/23/2012
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is used for testing the two class linear SVM with very distant
% classes.  

% Load in the orginal Test Parameterizations
%load('Test_Parameterizations.mat');

% Define the classes you want to grab
% Note, you might want to grab to very seperate classes
Class1 = 8;
Class2 = 15;

% Create new variables Theta and y to hold the reduced dataset
Class1_indexes = find(y == Class1);
Class2_indexes = find(y == Class2);

y_reduced = zeros((length(Class1_indexes) + length(Class2_indexes)),1);
Theta_reduced = zeros((length(Class1_indexes) + length(Class2_indexes)),size(Theta,2));
ScaledTheta_reduced = zeros((length(Class1_indexes) + length(Class2_indexes)),size(Theta,2));

% Assign +1 and -1 to y_reduced
y_reduced(1:length(Class1_indexes)) = 1;
y_reduced(length(Class1_indexes)+1:length(y_reduced)) = -1;

% Assign reduced dataset to Theta_reduced
Theta_reduced(1:length(Class1_indexes),:) = Theta(Class1_indexes,:);
Theta_reduced(length(Class1_indexes)+1:length(y_reduced),:) = Theta(Class2_indexes,:);
ScaledTheta_reduced(1:length(Class1_indexes),:) = ScaledTheta(Class1_indexes,:);
ScaledTheta_reduced(length(Class1_indexes)+1:length(y_reduced),:) = ScaledTheta(Class2_indexes,:);

% Run the regular Pegasos on this reduced dataset
[wT,b] = pegasos(Theta_reduced,y_reduced);
[wT_scaled,b_scaled] = pegasos(ScaledTheta_reduced,y_reduced);

% Debugging for two class variables
DecisionBoundry1 = wT*Theta_reduced' + b;
DecisionBoundry2 = wT_scaled*ScaledTheta_reduced' + b_scaled;

figure(1);
scatter(Theta_reduced(1:length(Class1_indexes),1),Theta_reduced(1:length(Class1_indexes),2),'+b');hold on;
scatter(Theta_reduced(length(Class1_indexes)+1:end,1),Theta_reduced(length(Class1_indexes)+1:end,2),'or');
hold off;
title('\Theta');
figure(2);
scatter(ScaledTheta_reduced(1:length(Class1_indexes),1),ScaledTheta_reduced(1:length(Class1_indexes),2),'+b');hold on;
scatter(ScaledTheta_reduced(length(Class1_indexes)+1:end,1),ScaledTheta_reduced(length(Class1_indexes)+1:end,2),'or');
hold off;
title('Scaled \Theta');

% Garbage Cleanup
clear Class1_indexes Class2_indexes;