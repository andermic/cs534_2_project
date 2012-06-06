function [ pred_class ] = classify( tree, data_instance )
% Takes a decision tree and a data instance, and predicts the class label
% of said instance.

THIS = 1;
PARENT = 2;
FEATURE = 3;
FEATURE_VAL = 4;
CLASS_VAL = 5;

cur_node = 1;
% Traverse the decision tree until a leaf is reached
while tree(CLASS_VAL, cur_node) == -2
    % Find the children of the current node
    children = tree(:,cur_node == tree(PARENT,:));
    
    % Figure out which feature was split across to create the children
    split_feature = children(FEATURE,1);
    
    % Find the child with the feature value that matches the given data
    % element.
    node = children(:,data_instance(split_feature) == children(FEATURE_VAL,:));
    
    % Get the index of the node
    cur_node = node(THIS);
end
% The class value of the found leaf is the predicted class value
pred_class = tree(CLASS_VAL, cur_node);

end