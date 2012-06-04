% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Scatter Plot Script
% Gregory Gutshall
% Date: 05/19/2012
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is used to create n-dimension scatter plots used for debugging
% and getting a feal for data
% NOTE: This code uses the scaled version of Theta i.e. ScaledTheta

% Number of each class to scatter plot
K = 25;

% Define the marker type
marker = {'ob','or','ok','og',...
          '+b','+r','+k','+g',...
          '*b','*r','*k','*g',...
          'sb','sr','sk','sg',...
          'db','dr','dk','dg',...
          };
      
% Define Class space
classSpace = -1:1:max(y);
startIndex = 1;
endIndex = length(classSpace);
%endIndex = 4;  % Debugging

% Create a blank figure
h1 = figure(1);hold on;

% Loop through each class and grab K examples from that class
for classID = startIndex:endIndex
    % Capture all members of the current Class index
    % note, currentCL is a index
    currentCL = find(y == classSpace(classID));
    
    % Take a K-sample random uniform permutation of the current class
    % Note, p is a index
    p = randperm(length(currentCL),K);
    
    % Now mask off the desired samples
    Ksamples = currentCL(p);
    
    % Form a temporary matrix Ai of the parameters for given class
    A = ScaledTheta(Ksamples,1:3);
    
    % Add the points to the scatter plot
    scatter3(A(:,1),A(:,2),A(:,3),marker{classID});
end

% Scatter Plot 
view(-60,60);
grid on;
title(['Feature Space for K = ',num2str(K),' random samples from each class y_i']);
xlabel(Theta_Labels{1});
ylabel(Theta_Labels{2});
zlabel(Theta_Labels{3});
legend('draw','0','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16');
hold off;