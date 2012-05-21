function [tree] = decision_tree(features, classes, feature_val)
% Return a tree that represents splitting of the training data so that
% leaves of the data contain only elements from one class.

PARENT = 1;
FEATURE_VAL = 2;
CLASS_VAL = 3;

node = zeros(3,1);
node(PARENT) = 0;
node(FEATURE_VAL) = feature_val;
node(CLASS_VAL) = -2;

% Base case: Return if all of the data belong to the same class.
if sum(classes(1) ~= classes) == 0
    node(CLASS_VAL) = classes(1);
    tree = node;

% Recursive case: Perform a split.
else
    % Find the feature with the highest mutual information gain.
    mut_infs = arrayfun(@(i) mutual_information(features(:,i),classes), 1:size(features,2));
    best = find(max(mut_infs) == mut_infs);
    if size(best,2) > 1
        best = best(1);
    end

    % Split using the given feature.
    tree = node;
    for i = unique(features(:,best))'
        feat_places = features(:,best) == i;
        new_feats = features(feat_places);
        new_classes = classes(feat_places);
        child = decision_tree(new_feats, new_classes, i);
        child(1,:) = child(1,:) + size(tree,2);
        tree = [tree, child];
    end
end
clear PARENT;
clear FEATURE_VAL;
clear CLASS_VAL;
clear features;
clear classes;
clear feature_val;
clear node;
clear mut_infs;
clear best;
clear feat_places;
clear i
clear new_feats;
clear new_classes;
clear child;

end