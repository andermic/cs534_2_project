% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Multiclass - one-vs-one
% Gregory Gutshall
% Date: 06/03/2012
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is used for testing the two class linear SVM, with the
% one-versus-one multiclass criteria.  See page.338 in Bishop

% Load in the orginal Test Parameterizations
load('..\..\Parameterizations');

% Knock off class labels -1 and 0, since they are deterministically found
X = ScaledTheta(y>0,:);
y = y(y>0);

% Define the class labels explicently
label = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];

% Subsample 60 samples from each class
sample = 60;
for i=1:length(label)
    idx = find(y == label(i));
    idx = idx(randperm(length(idx),sample));  % Select 60 random samples from that class
    
    if (i > 1)
        Xsub = [Xsub ; X(idx,:)];
        ysub = [ysub ; y(idx,:)];
    else
        Xsub = X(idx,:);
        ysub = y(idx);
    end
    
end


W = cell(length(label),length(label)-1);
B = zeros(length(label),length(label)-1);
K = 0.1:0.1:0.5;
lambda = 1:10:100;
accuracy_matrix = zeros(length(K),length(lambda));
% Assign +1 to the current label being classified, -1 to the other
y_lab = [ones(sample,1); -1*ones(sample,1)];      
tic;
for i=1:length(label)
    display(['Label Iter:',num2str(i),'/',num2str(length(label))]);

    % Find the required indexes
    idx_1   = find(label == label(i)); % The ONE, label being classified
    idx_r   = find(label ~= label(i)); % The REST

    % Loop over all K(K-1)/2 possiblities
    for r=1:length(idx_r)
        display(['   Inner-Label Iter:',num2str(r),'/',num2str(length(idx_r))]);
        % Create a test feature sub matrix of the ONE and REST
        X_lab = [Xsub(find(ysub == label(idx_1)),:) ; Xsub(find(ysub == label(idx_r(r))),:)];

        % Grid Search over K and Lambda
        wT = cell(length(K),length(lambda));
        b = zeros(length(K),length(lambda));
        accuracy = zeros(length(K),length(lambda));
        for k=1:length(K) 
            for ell=1:length(lambda)
                [wT{k,ell},b(k,ell),accuracy(k,ell)] = pegasos(X_lab,y_lab,lambda(ell),K(k),[],[]);
            end
        end
        % Get the best value for Lambda and K
        [maxaccuracy,ind] = max(accuracy(:));
        [Kimax,Lambdaimax] = ind2sub(size(accuracy),ind);

        % Store the wT and b for the max accuracy
        W{i,r} = wT{Kimax,Lambdaimax};
        B(i,r) = b(Kimax,Lambdaimax);
    end

end
elapsed_time = toc;

save 'xyz';

% Testing
% Find the accuracy
predicted_label = zeros(length(y),1);
for i=1:size(X,1)
    
    % Vote
    vote_r = zeros(length(label),1);
    for ir=1:length(label)
        vote_c = zeros(length(label)-1,1);
        for ic=1:(length(label)-1)
            vote_c(ic) = sign(W{ir,ic}*X(i,:) + B(io,ii));
        end
        % Tally Column Votes
        vote_r(ir) = sum(vote_c > 0);
    end
    % Tally Row Votes (label votes)
    [maxVote, predicted_label(i)] = max(vote_r); 

end


error = abs(y - predicted_label);
error = sum(error > 1);
accuracy = (1 - error/length(y))*100;


