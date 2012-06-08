% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reduce the Parameterization for y \in [-1,1]
% Gregory Gutshall
% Date: 05/23/2012
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is used for testing the two class linear SVM with very distant
% classes.  

% Load in the orginal Test Parameterizations
load('..\Parameterizations');

% Define the classes you want to grab
% Note, you might want to grab to very seperate classes
Class1 = 4;
Class2 = 16;

% Create new variables Theta and y to hold the reduced dataset
Class1_indexes = find(y == Class1);
Class2_indexes = find(y == Class2);

y_reduced = zeros((length(Class1_indexes) + length(Class2_indexes)),1);
ScaledTheta_reduced = zeros((length(Class1_indexes) + length(Class2_indexes)),2);

% Assign +1 and -1 to y_reduced
y_reduced(1:length(Class1_indexes)) = 1;
y_reduced(length(Class1_indexes)+1:length(y_reduced)) = -1;

% Assign reduced dataset to Theta_reduced
ScaledTheta_reduced(1:length(Class1_indexes),:) = ScaledTheta(Class1_indexes,[1,3]);
ScaledTheta_reduced(length(Class1_indexes)+1:length(y_reduced),:) = ScaledTheta(Class2_indexes,[1,3]);

% Run the regular Pegasos on this reduced dataset
[wT_scaled,b_scaled] = pegasos(ScaledTheta_reduced(:,1:2),y_reduced);

% Debugging for two class variables
DecisionBoundry2 = wT_scaled(1)*ScaledTheta_reduced(:,1) + wT_scaled(2)*ScaledTheta_reduced(:,2) + b_scaled;

% Create a plotting boundry
x1 = 2:0.01:10;
x2 = -1.5:0.01:3;
ZeroBoundry2 = -1*(1/wT_scaled(2)).*(wT_scaled(1).*x2 + b_scaled);

figure(2);
scatter(ScaledTheta_reduced(1:length(Class1_indexes),1),ScaledTheta_reduced(1:length(Class1_indexes),2),'+b');hold on;
scatter(ScaledTheta_reduced(length(Class1_indexes)+1:end,1),ScaledTheta_reduced(length(Class1_indexes)+1:end,2),'or');
plot(x2,ZeroBoundry2,'g','LineWidth',2);hold off;
title('Scaled \Theta');

% Garbage Cleanup
%clear Class1_indexes Class2_indexes;