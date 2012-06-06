function [tree] = decision_tree(data, continuous_norm, feature, feature_val, threshold)
% Return a tree that represents splitting of the training data so that
% leaves of the data contain only elements from one class.

% Input - data: The training data set.
%       - continous_norm: Set if the norm feature is treated as a
%          continuous variable.
%       - feature: The feature about which the parent was split.
%       - feature_val: The feature value about which the parent was split. 
%       - threshold: The threshold value about which the parent was split.

features = data(:,1:(size(data,2)-1));
classes = data(:,size(data,2));

THIS = 1;
PARENT = 2;
FEATURE = 3;
FEATURE_VAL = 4;
THRESHOLD = 5;
CLASS_VAL = 6;

NORM = 2;

node = zeros(5,1);
node(THIS) = 0;
node(PARENT) = 0;
node(FEATURE) = feature;
node(FEATURE_VAL) = feature_val;
node(THRESHOLD) = threshold;
node(CLASS_VAL) = -2;

% First base case: Return if all of the data belong to the same class.
if nnz(classes(1) == classes) == 0
    node(CLASS_VAL) = classes(1);
    tree = node;

else
    % Calculate mutual information of each feature to each class.
    mut_infs = arrayfun(@(i) mutual_information(features(:,i),classes), 1:size(features,2));

    % If we treat the norm feature as a continuous variable, then find the
    % best threshold value to split along.
    if continuous_norm
        norms = unique(features(:,NORM));
        if size(norms,1) > 1
            threshs = norms(1:(size(norms,1)-1))+eps;
            thresh_mis = zeros(size(threshs,1),1);
            for i = 1:size(threshs,1)
                higher = +(threshs(i) > features(:,NORM));
                thresh_mis(i) = mutual_information(higher, classes);
                best_thresh = find(max(thresh_mis) == thresh_mis);
                best_thresh = best_thresh(1); % Break ties
            end
            mut_infs(NORM) = thresh_mis(best_thresh);
        else
            mut_infs(NORM) = 0;
        end
    end
    
    % Second base case: Return if no additional information can be gained from a
    % split.
    if max(mut_infs) == 0
        % Do not split. Instead, make this a leaf node with class label
        % that is a majority vote amongst the associated data.
        uc = unique(classes);
        class_counts = histc(classes, uc);
        class_place = find(class_counts == max(class_counts));
        class_place = class_place(1); % Break ties
        node(CLASS_VAL) = uc(class_place);
        tree = node;

    else
        % Best feature is the one that gives the most information gain
        % about the class label.
        best = find(max(mut_infs) == mut_infs);
        best = best(1); % Break ties

        % Split using the given feature.
        tree = node;
        if continuous_norm && (best == NORM)
            features(:,NORM) = (features(:,NORM) > threshs(best_thresh));
            threshold = threshs(best_thresh);
        end
        for i = unique(features(:,best))'
            new_data = data(features(:,best) == i,:);
            child = decision_tree(new_data, continuous_norm, best, i, threshold);
            child(PARENT,1) = 1;
            child(PARENT,2:size(child,2)) = child(PARENT,2:size(child,2)) + size(tree,2);
            tree = [tree, child];
        end
    end
end
tree(THIS,:) = 1:size(tree,2);
end