% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create Parameterized Vectors for SVM
% Gregory Gutshall
% Date: 06/02/2012
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is used to create parameter vectors for use with the
% subgradient Pegasos SVM code.

% Load in the orginal MATLAB dataset
load('../Original_Dataset/base_data');


% Now create a scaled version of Theta in accordence with recommendations
% for SVM implementation
% Note: BkWr_{binary} feature is sparse so, just copy this over, do not
% scale.
meanTheta = mean(ScaledTheta);
stdTheta = std(ScaledTheta);
for j=[1,2,3]
    ScaledTheta(:,j) = (ScaledTheta(:,j) - meanTheta(j))./stdTheta(j);
end

% Break out the class labels y from the orginal dataset
y = base_data(:,7);

% Clean up the garbage
clear base_data Theta;
clear meanTheta stdTheta j;
clear BK_corner1 BK_corner2 BK_corner3 BK_corner4 Bk_L1edgeRankDistance Bk_L1edgeFileDistance;
clear Kings_L2 Bk_L1edge Bk_L2corner Bk_Wr_binary WhiteKingRook_L2;


