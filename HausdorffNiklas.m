function H = HausdorffNiklas(X,Y)
% Copyright 2020, All Rights Reserved
% Code by Niklas Wulkow
% For Paper, "Memory-based reduced modeling and data-based estimation of opinion spreading"
% by Niklas Wulkow, Peter Koltai and Christof Schuette
% Computes the Hausdorff distance between two sets
distmax = 0;
[n,mx] = size(X);
[ny,my] = size(Y);

% At first: Find maximum distance of points in X to Y
for i = 1:mx
     currentmaxdist = min(vecnorm(X(:,i) - Y));
     if(currentmaxdist > distmax)
         distmax = currentmaxdist;
     end
end
% Then: Find maximum distance of points in Y to X and take the overall
% maximum
for j = 1:my
     currentmaxdist = min(vecnorm(Y(:,j) - X));
     if(currentmaxdist > distmax)
         distmax = currentmaxdist;
     end
end
H = distmax;