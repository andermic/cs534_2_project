function [tree] = decision_tree(features, classes)
% Return a tree that represents splitting of the training data so that
% leaves of the data contain only elements from one class.

% Base case: Return if all of the data belong to the same class.
if (size(classes,1) == 1) || (sum(classes(1) ~= classes) == 0)
    return
end

% Find the feature with the highest information gain.
mut_infs = arrayfun(@(i) mutual_information(features(:,i),classes), 1:size(features,2));
best = find(max(mut_infs) == mut_infs);
if size(best,2) > 1
    best = best(1);
end

for i = unique(features(best))
    
end

end

