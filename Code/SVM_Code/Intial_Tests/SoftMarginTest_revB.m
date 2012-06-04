% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reduce the Parameterization for y \in [-1,1]
% Gregory Gutshall
% Date: 05/23/2012
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is used for testing the two class linear SVM with very distant
% classes.  



% Load in the orginal Test Parameterizations
load('Parameterizations');

% Define the classes you want to grab
% Note, you might want to grab to very seperate classes
Class1 = 15;
Class2 = 16;

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

% Run the regular Pegasos on this reduced dataset
display(['--- HardMargin:']);
[wT,b] = pegasos(ScaledTheta_reduced,y_reduced);
display(['--- SoftMargin:']);
[wT_scaled,b_scaled] = pegasos_SoftMargin(ScaledTheta_reduced,y_reduced);

% Garbage Cleanup
%clear Class1_indexes Class2_indexes;