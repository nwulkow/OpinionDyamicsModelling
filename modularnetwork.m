function A = modularnetwork(N,noClusters,p_inside,p_between)
% Copyright 2020, All Rights Reserved
% Code by Niklas Wulkow
% For Paper, "Memory-based reduced modeling and data-based estimation of opinion spreading"
% by Niklas Wulkow, Peter Koltai and Christof Schuette

% Creates a matrix of zeros and ones that has clusters.
% p_inside = Probability that two agents inside a cluster are connected
% p_between = Probability that two agents in different clusters are connected

% The number of agents N has to be a multiple of the number of clusters

if(length(p_inside) == 1)
    p_inside = p_inside*ones(1,noClusters);
end
A = round(rand(N)*0.5+p_between*0.5);
m = floor(N / noClusters);
for i = 1:noClusters
    A1 = round(rand(m)*0.5+p_inside(i)*0.5); % A1 is a submatrix representing only one cluster
    % All rows that have no neighbour yet inside their cluster are randomly assigned exactly one
    zerorows = find(sum(A1') == 0);
    for j = 1:zerorows
        A1(zerorows,max(1,round(rand(1,m)))) = 1;
    end
    A1 = ceil((A1+A1')/2); % This makes the subcluster matrix symmetric
  
    A((i-1)*m+1:i*m,(i-1)*m+1:i*m) = A1;
end

% If the number of agents divided by the number of clusters is not a full
% number, the remaining rows are taken care of 
% restm = length(A)-noClusters*m;
% A1 = round(rand(restm)*0.5+p_inside(1)*0.5);
% zerorows = find(sum(A1') == 0);
% for j = 1:zerorows
%     A1(zerorows,max(1,round(rand(1,restm)))) = 1;
% end
% A((noClusters)*m+1:end,(noClusters)*m+1:end) = A1;
% A = min(A,1);

for i = 1:length(A)
    A(i,i) = 1;
end

A = ceil((A+A')/2);  % This makes the whole matrix symmetric
