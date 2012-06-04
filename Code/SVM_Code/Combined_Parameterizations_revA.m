% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create Parameterized Vectors for SVM
% Gregory Gutshall
% Date: 06/02/2012
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is used to create parameter vectors for use with the
% subgradient Pegasos SVM code.

% Load in the orginal MATLAB dataset
load('../Original_Dataset/base_data');

% Create a vector parameters
% 1) White King to Black King distance
Kings_L2 = sqrt(abs(base_data(:,1)-base_data(:,5)).^2 + abs(base_data(:,2)-base_data(:,6)).^2 );

% 2) Black King to nearest board edge
Bk_L1edgeRankDistance = min([abs(base_data(:,5) - 1)'; abs(base_data(:,5) - 8)']);
Bk_L1edgeFileDistance = min([abs(base_data(:,6) - 1)'; abs(base_data(:,6) - 8)']);
Bk_L1edge = min([Bk_L1edgeRankDistance; Bk_L1edgeFileDistance])';

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

% 5) White King to White Rook L2 norm
% This parameter measures the distance of White King to White Rook
WhiteKingRook_L2 = sqrt(abs(base_data(:,1)-base_data(:,3)).^2 + abs(base_data(:,2)-base_data(:,4)).^2 );

% Combining all the parameters into one easy matrix
Theta = [Kings_L2 Bk_L1edge Bk_L2corner Bk_Wr_binary WhiteKingRook_L2];
Theta_Labels = {'Kings_{L2}','Bk_{L1edge}','Bk_{L2corner}','BkWr_{binary}','WhiteKingRook_{L2}'};

% Now create a scaled version of Theta in accordence with recommendations
% for SVM implementation
% Note: BkWr_{binary} feature is sparse so, just copy this over, do not
% scale.
meanTheta = mean(Theta);
stdTheta = std(Theta);
ScaledTheta = zeros(size(Theta));
for j=[1,2,3,5]
    ScaledTheta(:,j) = (Theta(:,j) - meanTheta(j))./stdTheta(j);
end
ScaledTheta(:,4) = Theta(:,4);

% Break out the class labels y from the orginal dataset
y = base_data(:,7);

% Clean up the garbage
clear base_data Theta;
clear meanTheta stdTheta j;
clear BK_corner1 BK_corner2 BK_corner3 BK_corner4 Bk_L1edgeRankDistance Bk_L1edgeFileDistance;
clear Kings_L2 Bk_L1edge Bk_L2corner Bk_Wr_binary WhiteKingRook_L2;


