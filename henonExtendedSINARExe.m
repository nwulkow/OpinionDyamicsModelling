% Copyright 2020, All Rights Reserved
% Code by Niklas Wulkow
% For Paper, "Memory-based reduced modeling and data-based estimation of opinion spreading"
% by Niklas Wulkow, Peter Koltai and Christof Schuette

% 

T = 1000; % Length of trajectory
burnIn = 1000; % Number of initial points that are thrown away
fracTrain = 0.92; % Ratio of points for training 
Ttrain = T*fracTrain;  % Number of points used for training
% Coefficients for the construction of the trajectory
a = 1.3; 
b = 0.3;
c = 0.3;
epsilon = 0; % Noise variance (optional and not in paper)
X = henonExtended(T+burnIn,a,b,c,epsilon);
X(:,1:burnIn) = []; % Throw away first burnIn points 
N = size(X,2); % Length of trajectory
Ntrain = round(N*fracTrain); % Number of points to be used for training in SINAR
lambda = 0.0; % Coefficient lambda in SINAR
pmax = 30; % Maximal value of memory depth p
clear testerrorPrediction hausdorffdist

phi = @(x) [ones(1,size(x,2));x(1,:);x(1,:).^2;x(2:end,:)]; % Basis functions: 1, (x_t)^2, x_{t-1},...,x_{t-p}

for p = 1:pmax
    % SINAR fitting
    xi = SINAR(X(1,1:Ntrain),p,0,phi); % Coefficients determined by SINAR

    H = delayMap(X(1,:),1,p,'descend');  % Hankel Matrix

    Xrec = X(1,Ntrain-pmax+1:Ntrain); % Initialisation of reconstructed trajectory
    for i = pmax:N-Ntrain+pmax-1
        x = Xrec(:,i:-1:i-p+1);
        Xrec(:,i+1) = xi*phi(x(:)); % Forward step: Coefficient matrix Xi times phi(x_t,...x_{t-p+1})
    end
    allXrecs{p} = Xrec; % Store reconstructions
    % Euclidean Errors
    testerror(p) = norm(xi*phi(H(:,Ntrain+1:end-1)) - X(1,Ntrain+1+p:end),'fro') / norm(X(1,Ntrain+p:end),'fro'); % Relative one-step prediction error
    testerrorPrediction(p) = norm(Xrec - X(1,Ntrain-pmax+1:end),'fro') / norm(X(1,Ntrain-pmax+1:end),'fro'); % Relative prediction error
    embed = 2; % Embedding dimension for Hausdorff distance
    hausdorffdist(p) = HausdorffNiklas(delayMap(Xrec,1,embed), delayMap(X(1,Ntrain-pmax+1:end),1,embed)); % Hausdorff distance
end
    fignum = 1; % Column of plot in figure with subplot and 2 columns
    figure(1)
    subplot(1,2,fignum)
    plot(testerrorPrediction,'Linewidth',2,'Marker','.','Markersize',24)
    xlabel('p')
    ylabel('rel. Eucl. error')
    titlestring = '';
    title(strcat('c=',num2str(c)));

    figure(2)
    subplot(1,2,fignum)
    plot(hausdorffdist,'LineWidth',1.5,'Marker','+','Color',[1,0.5,0.2])
    ylabel(strcat('Hausdorff distance w/ embed. dim. ',num2str(embed)))
    titlestring = '';
    title(strcat('c=',num2str(c)));
    xlabel('p')

%% Plot attractors: Original and reconstructed
figure(3)
subplot(3,2,1)
plot(X(1,Ntrain-pmax+1:end-1),X(1,Ntrain-pmax+2:end),'.','Color','green')
title('Original')
xlabel('x_{t-1}')
ylabel('x_t')
plotindices = [1,2,5,10,30]; % Plot attractors that were reconstructed with coefficients with these memory depths
for i = 1:length(plotindices)
subplot(3,2,i+1)
plot(allXrecs{plotindices(i)}(1:end-1),allXrecs{plotindices(i)}(2:end),'.')
title(strcat('p=',num2str(plotindices(i))))
xlabel('x_{t-1}')
ylabel('x_t')
end
    