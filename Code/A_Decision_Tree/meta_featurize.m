function [new_data] = meta_featurize(base_data, norm)
% Reparameterize the base data in terms of 3 meta-features which are
% described below.

% Feature 1: Distance of the black king to the edge of the board.

% Feature 2: Distance between the two kings. Since this distance is a
% vector, use L-norm distance, where "norm" is an input parameter to the
% function. Set "norm" to -1 for the infinity norm.

% Feature 3: Calculate directly whether the position is drawn. A position
% is drawn if the black king is stalemated OR black can immediately take
% the white rook.

% Outputs an N by 4 matrix, where N is the number of chess positions in the
% dataset. The first 3 columns of the matrix are the 3 meta-features for
% each position, the 4th column is the class label for each position.

feature_1 = min(min(base_data(:,5:6)-1, 8-base_data(:,5:6)), [], 2);

col_difs = abs(base_data(:,1) - base_data(:,5));
row_difs = abs(base_data(:,2) - base_data(:,6));
if norm == -1
    feature_2 = max([col_difs,row_difs], [], 2);
else
    feature_2 = (col_difs.^norm + row_difs.^norm).^(1/norm);
end

% Check for stalemate
for i = 1:size(base_data,1)
    if max()
    else
        stalemate = [stalemate;0];
end

new_data = [feature_1,feature_2,feature_3,base_data(:,7)];
end