function x = drawFromDistribution(distr,n,m,values)
% Draws an n-times-m matrix of which every entry is distributed by a
% distribution distr. "Values" transforms the output to desired values,
% i.e., distr(i) is the probability to draw the value values(i)

if(length(distr) == 0)
    x = [];
else
    distr = makeStochastic(distr);
    r = rand(n,m); % Draw random numbers uniformly between 0 and 1
    cumdistr = cumsum(distr); % Cumulated distribution
    R = zeros(n,m);
    for i = 1:n
        for j = 1:m
            R(i,j) = find(r(i,j) <= cumdistr, 1, 'first' ); % Compare r(i,j) to entries of cumdistr. The lowest value of
            % cumdistr corresponds to the entry that is drawn and stored in R(i,j)
        end
    end
    x = R;
    if(nargin > 3)
        x = values(R);
    end
end