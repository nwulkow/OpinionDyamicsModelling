function Y = delayMap(X,m,k,varargin)

% Copyright 2020, All Rights Reserved
% Code by Niklas Wulkow
% For Paper, "Memory-based reduced modeling and data-based estimation of opinion spreading"
% by Niklas Wulkow, Peter Koltai and Christof Schuette

% Create Hankel matrix from an n-by-m-dimensional trajectory of length N
% (so even trajectories of n-by-m-matrices).
Y = [];
N = size(X,2) / m; % Number of entries in the trajectory
if(~strcmp(varargin,'descend'))
    for i = 1:k
        start = (i-1)*m+1;
        Y = [Y; X(:,start:start+(N-k)*m)];
    end
else
    for i = k:-1:1
        start = (i-1)*m+1;
        Y = [Y; X(:,start:start+(N-k)*m)];
    end
end