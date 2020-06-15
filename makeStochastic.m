function P = makeStochastic(M)
% Makes a Matrix M with nonnegative entries stochastic, i.e. divides every
% entry by the correspondingrow sum
[n,m] = size(M);
for i = 1:n
    P(i,:) = M(i,:) / sum(M(i,:));
end