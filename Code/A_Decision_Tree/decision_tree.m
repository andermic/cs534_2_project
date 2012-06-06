function [tree] = decision_tree(features, classes, feature, feature_val)
% Return a tree that represents splitting of the training data so that
% leaves of the data contain only elements from one class.

THIS = 1;
PARENT = 2;
FEATURE = 3;
FEATURE_VAL = 4;
CLASS_VAL = 5;

node = zeros(5,1);
node(THIS) = 0;
node(PARENT) = 0;
node(FEATURE) = feature;
node(FEATURE_VAL) = feature_val;
node(CLASS_VAL) = -2;

% First base case: Return if all of the data belong to the same class.
if nnz(classes(1) == classes) == 0
    node(CLASS_VAL) = classes(1);
    tree = node;

% Recursive case: Perform a split.
else
    % Calculate mutual information of each feature to each class.
    mut_infs = arrayfun(@(i) mutual_information(features(:,i),classes), 1:size(features,2));
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
        for i = unique(features(:,best))'
            feat_places = find(features(:,best) == i);
            new_feats = features(feat_places,:);
            new_classes = classes(feat_places);
            child = decision_tree(new_feats, new_classes, best, i);
            child(PARENT,1) = 1;
            child(PARENT,2:size(child,2)) = child(PARENT,2:size(child,2)) + size(tree,2);
            tree = [tree, child];
        end
    end
end
tree(THIS,:) = 1:size(tree,2);
end