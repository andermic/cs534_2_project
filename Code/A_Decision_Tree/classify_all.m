function [ pred_class, true_class ] = classify_all( tree, data )
% Takes a decision tree and a data set. Uses the tree to classify the set.
% Returns predicted labels and true labels.

pred_class = [];
for i = 1:size(data,1)
    pred_class = [pred_class; classify(tree, data(i,:))];
end
true_class = data(:,size(data,2));

end