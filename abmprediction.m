function outputPred = abmprediction(C,m,numIter,f,lambda,pmax,blocklength,opinions_in_analysis)
% Copyright 2020, All Rights Reserved
% Code by Niklas Wulkow
% For Paper, "Memory-based reduced modeling and data-based estimation of opinion spreading"
% by Niklas Wulkow, Peter Koltai and Christof Schuette

% C: Matrix of realisations
T = size(C,1) / m; % Length of each realisation (we assume all realisations have the same length. Can easily be modified)
iterTrain = floor(numIter*0.6); % Use 60 Percent of realisations for training, the rest for validation
tau = 1; % Use every tau-th time step (tau = 1 in paper)
clear Xtrain Xtest
for k = 1:iterTrain
    c = C(1:tau:end,k);
    c = reshape(c,T/tau,m)';
    Xtrain{k} = c(opinions_in_analysis,1:T); % Xtrain is a Cell array with realisations of the 
    % opinion percentages that are to be used for training in SINAR
end
for k = 1:numIter-iterTrain
    c = C(1:tau:end,k+iterTrain);
    c = reshape(c,T/tau,m)';
    Xtest{k} = c(opinions_in_analysis,1:end); % Xtrain is a Cell array with realisations of the 
    % opinion percentages of time that are to be used for testing in SINAR
end
clear MRSE MRSE_Onestep
for p = 1:pmax
    xi = SINARCellArray(Xtrain,p,lambda,f); % Determine coefficients with SINAR

    clear testerror trainerror lens;
    for k = 1:numIter-iterTrain % Iterate over all realisation that are to be used for training
        H = delayMap(Xtest{k}(opinions_in_analysis,:),1,p,'descend'); % Creates Hankel matrix
        Ttest = size(Xtest{k},2); % Number of time steps of current realisation
        counter = 0;
        testerrorblock = zeros(1,floor((Ttest)/blocklength-1));
        for u = 1:(Ttest)/blocklength-1 % Iterate over all blocks of length blocklength of the current realisation
            Xrec = Xtest{k}(:,blocklength*(u)+1-p:blocklength*(u)); % Starting values for this block are last p values of previous block
            for i = 1:blocklength % Compute reconstruction for one block
                x = Xrec(:,i+p-1:-1:i);
                Xrec(:,i+p) = xi*f(x(:));
            end
            Xrec(:,1:p) = [];
            % In case all entries in one block of validation data are 0,
            % exclude it. Otherwise, compute prediction error
            if(norm(Xtest{k}(:,blocklength*(u)+1:blocklength*(u+1)),'fro') > 0)
                testerrorblock(u) = norm(Xrec - Xtest{k}(:,blocklength*(u)+1:blocklength*(u+1)),'fro') / norm(Xtest{k}(:,blocklength*(u)+1:blocklength*(u+1)),'fro'); % Realitve Euclidean prediction error for current block
                counter = counter + 1;
            end
        end
        testerror(k) = sum(testerrorblock)/counter; % Sum of relative Euclidean prediction errors over all blocks for the k-th realisation
        trainerror(k) = norm(xi*f(H(:,pmax:end-1)) - H(1:length(opinions_in_analysis),pmax+1:end),'fro') / norm(H(1:length(opinions_in_analysis),pmax+1:end),'fro'); % One-Step relative Eucl. pred. error
        lens(k) = size(Xtest{k},2);
    end
    MRSE(p) = testerror*lens'/sum(lens); % Mean rel. Eucl. pred. error
    MRSE_Onestep(p) = trainerror*lens'/sum(lens); % Mean One-Step rel. Eucl. pred. error
    allxis{p} = xi; % Store coeffient matrix Xi for every used memory depth
end
outputPred = {MRSE,MRSE_Onestep,allxis}; % Output

