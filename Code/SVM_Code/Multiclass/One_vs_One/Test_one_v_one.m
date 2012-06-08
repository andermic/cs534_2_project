% Testing one-v-one

% Testing
% Find the accuracy
predicted_label = zeros(length(y),1);
for i=1:size(X,1)
    
    % Vote
    vote_r = zeros(length(label),1);
    for ir=1:length(label)
        vote_c = zeros(length(label)-1,1);
        for ic=1:(length(label)-1)
            vote_c(ic) = sign(W{ir,ic}*X(i,:)' + B(ir,ic));
        end
        % Tally Column Votes
        vote_r(ir) = sum(vote_c > 0);
    end
    % Tally Row Votes (label votes)
    [maxVote, predicted_label(i)] = max(vote_r); 

end

% Calculate Error
error = abs(y - predicted_label);
mean_error = mean(error);
std_error = std(error);

error_p = sum(error > 1);
accuracy = (1 - error_p/length(y))*100;