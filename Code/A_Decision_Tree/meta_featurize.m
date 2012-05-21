function [new_data] = meta_featurize(base_data, norm)
% Reparameterize the base data in terms of 4 meta-features which are
% described below.

% Feature 1: Distance of the black king to the edge of the board.

% Feature 2: Distance between the two kings. Since this distance is a
% vector, use L-norm distance, where "norm" is an input parameter to the
% function. Set "norm" to -1 for the infinity norm.

% Feature 3: Calculate directly whether the position is drawn. A position
% is drawn iff the black king is stalemated OR black can immediately take
% the white rook.

% Feature 4: Calculate directly whether the position is checkmate. A
% position is checkmate iff the two kings are correctly opposed, the black
% king is on the edge, and the rook is on the same edge as the black king.

% Outputs an N by 5 matrix, where N is the number of chess positions in the
% dataset. The first 4 columns of the matrix are the 4 meta-features for
% each position, the 5th column is the class label for each position.


% These constants will be useful.
WKC = base_data(:,1);
WKR = base_data(:,2);
WRC = base_data(:,3);
WRR = base_data(:,4);
BKC = base_data(:,5);
BKR = base_data(:,6);
CLASS = base_data(:,7);


% Feature 1
col_dists = min(BKC-1, 8-BKC);
row_dists = min(BKR-1, 8-BKR);
feature_1 = min(col_dists, row_dists);


% Feature 2
col_difs = abs(WKC - BKC);
row_difs = abs(WKR - BKR);
if norm == -1
    feature_2 = max([col_difs,row_difs], [], 2);
else
    feature_2 = (col_difs.^norm + row_difs.^norm).^(1/norm);
end


% Feature 3

% Check for stalemate.
% Stalemate can only occur if the black king is in the corner.
eval_strs = ['(col_dists == 0) & (row_dists == 0)'];
% 1st stalemate check. The rook is one column and one row away from
% the black king.
eval_strs = [eval_strs, '& (((abs(BKC - WRC) == 1) & (abs(BKR - WRR) == 1)'];
% Also, the white king protects the rook
eval_strs = [eval_strs, '& max(abs(WKC - WRC), abs(WKR - WRR) == 1))'];
% 2nd stalemate check. The rook is one row away from the black king and
% the white king is two rows away on the same column.
eval_strs = [eval_strs, '| ((abs(BKC - WRC) == 1) & (abs(BKR - WKR) == 2) & (BKC == WKC))'];
% Must check reverse of row/column logic in previous.
eval_strs = [eval_strs, '| ((abs(BKR - WRR) == 1) & (abs(BKC - WKC) == 2) & (BKR == WKR)))'];
stalemate = eval(strcat(eval_strs));

% Check for capturable rook.
% Black king must be next to the rook, white king must not be next to
% the rook.
free_rook = (max(abs(BKC-WRC),abs(BKR-WRR)) == 1) & (max(abs(WKC-WRC),abs(WKR-WRR)) > 1);

feature_3 = stalemate | free_rook;


% Feature 4

% Black king must be on an edge, rook must be on the same edge but not
% right next to the black king.
eval_strs = '(BKC == 1 & WRC == 1 & (abs(BKR - WRR) > 1)';
% White king must be 2 squares away.
eval_strs = [eval_strs, '& WKC == 3'];
% White king must be directly opposed.
eval_strs = [eval_strs, '& (WKR == BKR'];
% Or if the black king is the in the corner, the kings do not need to be
% perfectly opposed.
eval_strs = [eval_strs, '| ((BKR == 1 | BKR == 8) & (abs(BKR - WKR) == 1))))'];

% Run analogous tests for each of the 4 edges of a chessboard.
eval_strs = [eval_strs, '| (BKC == 8 & WRC == 8 & (abs(BKR - WRR) > 1)'];
eval_strs = [eval_strs, '& WKC == 6'];
eval_strs = [eval_strs, '& (WKR == BKR'];
eval_strs = [eval_strs, '| ((BKR == 1 | BKR == 8) & (abs(BKR - WKR) == 1))))'];

eval_strs = [eval_strs, '| (BKR == 1 & WRR == 1 & (abs(BKC - WRC) > 1)'];
eval_strs = [eval_strs, '& WKR == 3'];
eval_strs = [eval_strs, '& (WKC == BKC'];
eval_strs = [eval_strs, '| ((BKC == 1 | BKC == 8) & (abs(BKC - WKC) == 1))))'];

eval_strs = [eval_strs, '| (BKR == 8 & WRR == 8 & (abs(BKC - WRC) > 1)'];
eval_strs = [eval_strs, '& WKR == 6'];
eval_strs = [eval_strs, '& (WKC == BKC'];
eval_strs = [eval_strs, '| ((BKC == 1 | BKC == 8) & (abs(BKC - WKC) == 1))))'];

feature_4 = eval(eval_strs);


new_data = [feature_1,feature_2,feature_3,feature_4,CLASS];
end