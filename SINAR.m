function [xi,err] = SINAR(X,p,lambda,phi)
% Copyright 2020, All Rights Reserved
% Code by Niklas Wulkow
% For Paper, "Memory-based reduced modeling and data-based estimation of opinion spreading"
% by Niklas Wulkow, Peter Koltai and Christof Schuette

% Apply SINAR to a data matrix X with memory depth p, sparsity coefficient
% lambda and basis functions phi

if(nargin < 4)
    if(nargin < 4)
        phi = @(x) x;
    end
end
n = size(X,1);
H = delayMap(X,1,p,'descend'); % Hankel matrix
H1 = H(:,1:end-1); % First T-1 columns of Hankel matrix
H1 = phi(H1); % Transform columns of H1
H2 = H(1:n,2:end); % Columns 2,...,T of Hankel matrix 
xi = sparsifyDynamics(H1',H2',lambda,n)'; % Find coefficient matrix Xi
err = norm(xi*H1-H2,'fro'); % Training error
