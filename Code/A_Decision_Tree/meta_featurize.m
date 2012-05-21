function [new_data] = meta_featurize(base_data, norm)
% Reparameterize the base data in terms of 3 meta-features which are
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

% Outputs an N by 4 matrix, where N is the number of chess positions in the
% dataset. The first 3 columns of the matrix are the 3 meta-features for
% each position, the 4th column is the class label for each position.


% These constants will be useful
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
stalemate = zeros(size(base_data,1),1);
free_rook = zeros(size(base_data,1),1);
for i = 1:size(base_data,1)
    % Check for stalemate.
    % Stalemate can only occur if the black king is in the corner.
    if (col_dists(i) == 0) && (row_dists(i) == 0)
        % 1st stalemate check. The rook is one column and one row away from
        % the black king.
        if (abs(BKC(i) - WRC(i)) == 1) && (abs(BKR(i) - WRR(i)) == 1)
            % Also, the white king protects the rook
            if (max(abs(WKC(i) - WRC(i)), abs(WKR(i) - WRR(i)) == 1))
                stalemate(i) = 1;
            end
        % 2nd stalemate check. The rook is one row away from the black king
        %  and the white king is two rows away on the same column.
        elseif (abs(BKC(i) - WRC(i)) == 1) && (abs(BKR(i) - WKR(i)) == 2) && (BKC(i) == WKC(i))
            stalemate(i) = 1;
        % Must check reverse of row/column logic in previous.
        elseif (abs(BKR(i) - WRR(i)) == 1) && (abs(BKC(i) - WKC(i)) == 2) && (BKR(i) == WKR(i))
            stalemate(i) = 1;
        end
    end
    
    % Check for capturable rook.
    % Black king must be next to the rook, white king must not be next to
    % the rook.
    if (max(abs(BKC(i)-WRC(i)),abs(BKR(i)-WRR(i))) == 1) && (max(abs(WKC(i)-WRC(i)),abs(WKR(i)-WRR(i))) > 1)
        free_rook(i) = 1;
    end
end
feature_3 = stalemate | free_rook;


% Feature 4
feature_4 = zeros(size(base_data,1),1);
for i = 1:size(base_data,1)
    % Black king must be on an edge, rook must be on the same edge but not
    % right next to the black king.
    if (BKC(i) == 1) && (WRC(i) == 1) && (abs(BKR(i) - WRR(i)) > 1)
        % White king must be 2 squares away.
        if WKC(i) == 3
            % White king must be directly opposed.
            if WKR(i) == BKR(i)
                feature_4(i) = 1;
            % Also if the black king is in the corner, the kings do not
            % need to be perfectly opposed.
            elseif ((BKR(i) == 1) || (BKR(i) == 8)) && (abs(BKR(i) - WKR(i)) == 1)
                feature_4(i) = 1;
            end
        end
    end
    % Duplicate this code for each of the 4 edges on the chessboard
    if (BKC(i) == 8) && (WRC(i) == 8) && (abs(BKR(i) - WRR(i)) > 1)
        if WKC(i) == 6
            if WKR(i) == BKR(i)
                feature_4(i) = 1;
            elseif ((BKR(i) == 1) || (BKR(i) == 8)) && (abs(BKR(i) - WKR(i)) == 1)
                feature_4(i) = 1;
            end
        end
    end
    if (BKR(i) == 1) && (WRR(i) == 1) && (abs(BKC(i) - WRC(i)) > 1)
        if WKR(i) == 3
            if WKC(i) == BKC(i)
                feature_4(i) = 1;
            elseif ((BKC(i) == 1) || (BKC(i) == 8)) && (abs(BKC(i) - WKC(i)) == 1)
                feature_4(i) = 1;
            end
        end
    end
    if (BKR(i) == 8) && (WRR(i) == 8) && (abs(BKC(i) - WRC(i)) > 1)
        if WKC(i) == 6
            if WKC(i) == BKC(i)
                feature_4(i) = 1;
            elseif ((BKC(i) == 1) || (BKC(i) == 8)) && (abs(BKC(i) - WKC(i)) == 1)
                feature_4(i) = 1;
            end
        end
    end

    
new_data = [feature_1,feature_2,feature_3,feature_4,CLASS];
end