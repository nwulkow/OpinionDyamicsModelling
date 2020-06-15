function outputABM = ABM_function(N1,M,T,Alpha,A,m)

% Copyright 2020, All Rights Reserved
% Code by Niklas Wulkow
% For Paper, "Memory-based reduced modeling and data-based estimation of opinion spreading"
% by Niklas Wulkow, Peter Koltai and Christof Schuette

% Creates a realisation of the opinion change ABM

for i = 1:T-1
   m(:,i+1) = opinionchange(A,m(:,i),Alpha);
end
c = [];
for k = 1:M
    c(:,k) = sum(m(1:N1,:)==k) / N1;
end
outputABM = {c,m};
end
%% Methods
function m2 = opinionchange(A,m1,Alpha)
N = length(m1);
m2 = m1;
    for i = 1:N
        ind = find(A(i,:) == 1); % neighbors
        neighbour = ind(randi(length(ind))); % Choose random neighbour
        neighbour_op = m1(neighbour); % opinion of selected neighbour
        selectedAlpha = Alpha(m1(i),neighbour_op); % Corresponding alpha
        u = rand; % Draw random number
        if(u < selectedAlpha) % With probability selectedAlpha, accept opinion
            m2(i) = neighbour_op;
        else
            m2(i) = m1(i);
        end
    end
    m2 = m2';
end

