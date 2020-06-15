function [xi,err] = SINARCellArray(X,p,lambda,phi)

% Copyright 2020, All Rights Reserved
% Code by Niklas Wulkow
% For Paper, "Memory-based reduced modeling and data-based estimation of opinion spreading"
% by Niklas Wulkow, Peter Koltai and Christof Schuette

% Do SINAR on a Cell Array X of realisations of a dynamical system

if(nargin < 4)
    phi = @(x) x;
end
H1 = [];
H2 = [];
len = length(X);
for i = 1:len % For all realisations in Cell Array, store first T-1 columns in H1 and columns 2,...,T in H2
    n = size(X{i},1);
    H = delayMap(X{i},1,p,'descend');
    H1 = [H1,H(:,1:end-1)];
    H2 = [H2,H(1:n,2:end)];
end
H1 = phi(H1); % Transform H1 with basis functions
if(lambda > 0) % With sparsity constraint: Use Script by Brunton et al.
    xi = sparsifyDynamics(H1',H2',lambda,n)';
else % Without sparsity constraint: Use usual Matlab routine
    xi = (H1'\H2')';
end
err = norm(xi*H1-H2,'fro');