function A = modularnetwork(N,noClusters,p_inside,p_between)
% Copyright 2020, All Rights Reserved
% Code by Niklas Wulkow
% For Paper, "Memory-based reduced modeling and data-based estimation of opinion spreading"
% by Niklas Wulkow, Peter Koltai and Christof Schuette

% Creates a matrix of zeros and ones that has clusters.
% p_inside = Probability that two agents inside a cluster are connected (equal to 1 in paper). Can be a vector if different for every cluster
% p_between = Probability that two agents in different clusters are connected

if(length(p_inside) == 1)
    p_inside = p_inside*ones(1,noClusters);
end
A = round(rand(N)*0.5+p_between*0.5); % Randomly fill the matrix with zeros and ones. A 1 is placed with probability p_between
n = floor(N / noClusters); % Number of agents per cluster
for i = 1:noClusters
    A1 = round(rand(n)*0.5+p_inside(i)*0.5); % A1 is a submatrix representing only one cluster
    
    %%% ------ All rows that have no neighbour yet inside their cluster (very improbable if pinside is not very small) are randomly assigned exactly one
    zerorows = find(sum(A1') == 0);
    for j = zerorows
        all_other_indices = setdiff(1:n,j); % All agents that are not the j-th one
        ind = all_other_indices(randi(n-1)); % Choose one of them uniformly at random
        A1(j,ind) = 1; % Make the j-th agent a neighbor the agent with index ind
        A1(ind,j) = 1;
    end
    %%% -----
    % Make the submatrix symmetric by...
    A_upper = triu(A,1); % Setting all entries below the diagonal to 0 and then...
    A = diag(diag(A)) + A_upper + A_upper'; % ... copying the upper triangular part of A to the lower triangular part 
  
    A((i-1)*n+1:i*n,(i-1)*n+1:i*n) = A1; % A1 is placed into one block of A
end

% If the number of agents divided by the number of clusters is not a full
% number, the remaining rows are a smaller cluster of their own
restm = noClusters*n+1:N;
if(length(restm) > 1)
    A1 = round(rand(length(restm))*0.5+p_inside(1)*0.5);
    zerorows = find(sum(A1') == 0);
    for j = zerorows
        all_other_indices = setdiff(1:length(restm),j); % All agents that are not the j-th one
        ind = all_other_indices(randi(length(restm)-1)); % Choose one of them uniformly at random
        A1(j,ind) = 1; % Make the j-th agent a neighbor the agent with index ind
        A1(ind,j) = 1;
    end
    A((noClusters)*n+1:end,(noClusters)*n+1:end) = A1;
end

% All diagonal entries are set to 1 (every agent is its own neighbour)
for i = 1:length(A)
    A(i,i) = 1; 
end
% Make the matrix symmetric by...
A_upper = triu(A,1); % Setting all entries below the diagonal to 0 and then...
A = diag(diag(A)) + A_upper + A_upper';  % ... copying the upper triangular part of A to the lower triangular part 