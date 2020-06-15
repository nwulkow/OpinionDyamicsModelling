function [C,ms,Cmean,A,allCs] = executeABM(N,T,m,Alpha,pinside,pbetween,noClusters,mstart,numIter)
% Copyright 2020, All Rights Reserved
% Code by Niklas Wulkow
% For Paper, "Memory-based reduced modeling and data-based estimation of opinion spreading"
% by Niklas Wulkow, Peter Koltai and Christof Schuette


% This function prepares the setting for the creation of the opinion change
% ABM and then executes it

% Output:
% C: Matrix containing all realisations of opinion percentages
% ms: Cell array of all realisation of individial opinions
% A: adjacency matrix
% allCs: Cell array containing all realisations of opinion percentages
for i = 1:m
    Alpha(i,i) = 0;%1-sum(Alpha(i,:)); % Diagonal values of Alpha. This form has computational reasons
end

A = modularnetwork(N,noClusters,pinside,pbetween); % Create an adjacency matrix A for the network that consists of
% clusters. Inside a clusters, agents are connected with probability
% pinside. Agents in different clusters are connected with probability
% pbetween. N is the number of agents (A is an n-times-n matrix)
% Simulations
C = [];
mmean = 0;
for j = 1:numIter % If the Parallelisation toolbox of Matlab is not installed, a "parfor" can be changed to "for"
    fprintf(strcat('Realisation no.: ',num2str(j),'\n'))
    output = ABM_function(N,m,T,Alpha,A,mstart); % ABM realisation
    c = output{1}; % opinion percentages
    op_evol = output{2}; % individual opinions over time
    ms{j} = op_evol;
    c = c(:);
    C = [C,c];
    allCs{j} = reshape(c,T,m);
    mmean = mmean + m;
end
Cmean = sum(C',1)'/numIter; % Average opinion percentages
Cmean = reshape(Cmean,T,m);