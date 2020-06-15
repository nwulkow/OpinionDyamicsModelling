function X = henonExtended(Tend,a,b,c,epsilon,X0)
% Copyright 2020, All Rights Reserved
% Code by Niklas Wulkow
% For Paper, "Memory-based reduced modeling and data-based estimation of opinion spreading"
% by Niklas Wulkow, Peter Koltai and Christof Schuette

% Creates a trajectory of the extended Henon system with length Tend and
% parameter a, b and c. Epsilon is the variance of a normally distributed
% noise term that is added in every step (not done in paper). X0 is the
% initial state

if(nargin < 6)
    X = [0;0];
else
    X = X0;
end
if(nargin < 5)
    epsilon = 0.0;
end
phi = @(X) [1-a*X(1,end)^2 + X(2,end); b*X(1,end) + c*X(2,end)] + randn(2,1)*epsilon;
for i = 1:Tend
    X = [X, phi(X(:,end))];
end