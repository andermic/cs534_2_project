% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create Parameterized Vectors for SVM
% Gregory Gutshall
% Date: 05/19/2012
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is used to create parameter vectors for use with the
% subgradient Pegasos SVM code.

% Load in the orginal MATLAB dataset
load('../Orginal_Dataset/base_data.mat');

% Create a vector parameters
% 1) White King to Black King distance
Kings_L2 = sqrt(abs(base_data(:,1)-base_data(:,5)).^2 + abs(base_data(:,2)-base_data(:,6)).^2 );

% 2) Black King to nearest board edge
Bk_L1edge = min([(base_data(:,5) - 1)'; (base_data(:,6) - 1)'])';

% 3) Black King to nearest board corner
BK_corner1 = sqrt(abs(base_data(:,5) - 1).^2 + abs(base_data(:,6) - 1).^2 )';
BK_corner2 = sqrt(abs(base_data(:,5) - 8).^2 + abs(base_data(:,6) - 1).^2 )';
BK_corner3 = sqrt(abs(base_data(:,5) - 8).^2 + abs(base_data(:,6) - 8).^2 )';
BK_corner4 = sqrt(abs(base_data(:,5) - 1).^2 + abs(base_data(:,6) - 8).^2 )';
Bk_L2corner = min([BK_corner1; BK_corner2; BK_corner3; BK_corner4])';

% 4) Black King to White Rook distance (Binary Classifier)
% This parameter is a little different since it checks to see tha the Bk is
% not adjacent to the Wr
Bk_Wr_binary = sqrt(abs(base_data(:,3)-base_data(:,5)).^2 + abs(base_data(:,4)-base_data(:,6)).^2 );
Bk_Wr_binary = Bk_Wr_binary <= sqrt(1^2+1^2);

% Combining all the parameters into one easy matrix
Theta = [Kings_L2 Bk_L1edge Bk_L2corner Bk_Wr_binary];
Theta_Labels = {'Kings_{L2}','Bk_{L1edge}','Bk_{L2corner}','BkWr_{binary}'};

% Break out the class labels y from the orginal dataset
y = base_data(:,7);

% Clean up the garbage
clear base_data;
clear BK_corner1 BK_corner2 BK_corner3 BK_corner4;
clear Kings_L2 Bk_L1edge Bk_L2corner Bk_Wr_binary;


