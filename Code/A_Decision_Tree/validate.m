function [ pred_class, true_class ] = validate(data, folds)
% Takes data elements and a number of folds. Performs "folds" number of
% runs. For each run, take 1/fold fraction of the data as testing data, and
% use the rest as training data. Return the predicted class labels and true
% class labels across all folds.

% Find the splitting points for each fold.
splits = linspace(1,size(data,1),folds+1);
splits = floor(splits);

% Data is organized by class label, so shuffle it to get a roughly
% representative sample for both training and testing data.
shuffled_data = data(randperm(size(data,1)),:);

pred_class = [];
true_class = [];

n = size(data,1);
NULL = -2;

for i = 1:(size(splits,2)-1)
    i
    train_inds = ((1:n) < splits(i)) | ((1:n) > splits(i+1));
    test_inds = ((1:n) >= splits(i)) & ((1:n) <= splits(i+1));

    % Build a decision tree using the training data
    tree = decision_tree(shuffled_data(train_inds,:), false, NULL, NULL, NULL);

    % Test the decision tree on the test_data
    [pci, tci] = classify_all(tree, shuffled_data(test_inds,:), false);

    % Aggregate data
    pred_class = [pred_class; pci];
    true_class = [true_class; tci];
end

end