% Copyright 2020, All Rights Reserved
% Code by Niklas Wulkow
% For Paper, "Memory-based reduced modeling and data-based estimation of opinion spreading"
% by Niklas Wulkow, Peter Koltai and Christof Schuette

% Section 1: Create realisations of the opinion change ABM
% Section 2: Do the SINAR analysis and prediction with multiple memory depths
% Section 3: Plot the results

% ABM PARAMETER
% N = number of agents
% T = number of time steps
% M = number of opinions
% Alpha = Matrix of alpha-Coefficients
% pinside = Probability that two agents inside a cluster are connected
% pbetween = Probability that two agents in different clusters are connected
% noClusters = number of equally-sized clusters
% numIter = number of created realisations of the ABM. Use at least two (One for training, one for prediction)
% mstart = Initial distribution of opinions

% fprintf('One Cluster settings \n')
% N = 5000; T = 600; m = 3; Alpha = [0,0.55,0.1;0.1,0,0.55;0.55,0.1,0]*0.3; pinside = 1; pbetween = 1; noClusters = 1; numIter = 20;
% mstart = [1*ones(0.45*N,1);2*ones(0.1*N,1);3*ones(0.45*N,1)]; % Distribution of opinions in network
% [C,ms,Cmean,A] = executeABM(N,T,m,Alpha,pinside,pbetween,noClusters,mstart,numIter);
% saveABM(N,T,Alpha,pinside,pbetween,noClusters,A,C,ms,'N5000T600_1Cluster');

fprintf('Two Cluster settings \n')
N = 5000; T = 500; m = 3; Alpha = [0,0.55,0.1;0.1,0,0.55;0.55,0.1,0]*0.3; pinside = 1; pbetween = 0.0001; noClusters = 2; numIter = 6;
mstart = [1*ones(0.8*N/2,1);2*ones(0.1*N/2,1);3*ones(0.1*N/2,1)]; % Distribution in first cluster
mstart = [mstart;[1*ones(0.1*N/2,1);2*ones(0.1*N/2,1);3*ones(0.8*N/2,1)]]; % Distribution in second cluster
[C,ms,Cmean,A] = executeABM(N,T,m,Alpha,pinside,pbetween,noClusters,mstart,numIter);
%saveABM(N,T,Alpha,pinside,pbetween,noClusters,A,C,ms,'N5000T600_2Clusters');

% fprintf('Five Cluster settings \n')
% N = 5000; T = 8; m = 3; Alpha = [0,0.55,0.1;0.1,0,0.55;0.55,0.1,0]*0.3; pinside = 1; pbetween = 0.0001; noClusters = 5; numIter = 6;
% mstart = [1*ones(0.8*N/5,1);2*ones(0.1*N/5,1);3*ones(0.1*N/5,1)]; % Distribution in first cluster
% mstart = [mstart, 1*ones(0.1*N/5,1);2*ones(0.1*N/5,1);3*ones(0.8*N/5,1)]; % Distribution in second cluster
% mstart = [mstart, 1*ones(0.1*N/5,1);2*ones(0.8*N/5,1);3*ones(0.1*N/5,1)];
% mstart = [mstart, 1*ones(0.3*N/5,1);2*ones(0.4*N/5,1);3*ones(0.3*N/5,1)];
% mstart = [mstart, 1*ones(0.5*N/5,1);2*ones(0.2*N/5,1);3*ones(0.3*N/5,1)];
% [C,ms,Cmean,A] = executeABM(N,T,m,Alpha,pinside,pbetween,noClusters,mstart,numIter);
% saveABM(N,T,Alpha,pinside,pbetween,noClusters,A,C,ms,'N5000T800_5Clusters');
%%
% ANALYSIS VALUES
% C: Matrix containing all realisations of opinion percentages: i-th
% column: Rows 1-T contain opinion percentages of first opinion over T time
% steps. Rows T+1-2T contain percentages of second opinion...
% ms: All individual opinions stored in Cell Array. i-th cell represents
% individual opinions in i-th realisation over time
% abmconfig = load('abmconfig_N5000T800_5Clusters');
% abmconfig = abmconfig.abmconfig;
% C = abmconfig.C;
% T = abmconfig.T;
% numIter = size(abmconfig.C,2); % Number of realisations
% ms = abmconfig.ms; 
% m = size(abmconfig.Alpha,1); % Number of opinions

endtime = min(400,T); % Endtime used in training and prediction    
indices = 1+T*[0:m-1]+[1:endtime]'; % Rows of matrix C (if endtime < T, some rows are excluded)
C_copy = C;
C = C(indices(:),:);
pmax = 20; % Maximal value of p in SINAR analysis
blocklength =  20; % Length of each block that is reconstructed
opinions_in_analysis = 1:2; % Opinions whose macro-realisations are used in SINAR
phi = @(x) piecewisecrossproducts(x,length(opinions_in_analysis):length(opinions_in_analysis):size(x,1)); % Basis function
% phi has the form as in the paper ((x_{t-i})_1,...(x_{t-i})_m and all
% products of these for all i = 1,...,p

% With lambda = 0:
lambda = 0.0;
outputPred_lambda0 = abmprediction(C,m,numIter,phi,lambda,pmax,blocklength,opinions_in_analysis); % SINAR training and reconstruction
MRSE_lambda0 = outputPred_lambda0{1}; % Mean relative Euclidean prediction error for predictions of each block
MRSE_Onestep_lambda0 = outputPred_lambda0{2}; % Mean realitve Euclidean one-step prediction error
xi_lambda0 = outputPred_lambda0{3};
% With lambda > 0:
lambda = 0.05;
outputPred_lambdapos = abmprediction(C,m,numIter,phi,lambda,pmax,blocklength,opinions_in_analysis);
MRSE_lambdapos = outputPred_lambdapos{1};
MRSE_Onestep_lambdapos = outputPred_lambdapos{2};
xi_lambdapos = outputPred_lambdapos{3};
%% Plot
trajectoryindex = 2; % Index of realisation that should be plotted in main figure
figure(1)

subplot(2,2,1)
imagesc(ms{trajectoryindex}(:,1:endtime)) % Plot of evolution of opinions of all agents
% in one realisation of the ABM
colormap('jet');
xlabel('t')
ylabel('agent')

subplot(2,2,2)
hold off
plot(C(1:endtime,trajectoryindex),'LineWidth',1.5,'Color',[0,0,0.5137]) % Plot of evolution of opinions percentages in one realisation of the ABM
hold on
plot(C(endtime+1:2*endtime,trajectoryindex),'LineWidth',1.5,'Color',[0.5137,1,0.4824])
plot(C(2*endtime+1:3*endtime,trajectoryindex),'LineWidth',1.5,'Color',[0.498,0,0])
xlabel('t')
ylabel('opinion concentrations \xi(X_t)')

subplot(2,2,3)
hold off
plot(MRSE_lambda0,'Linewidth',2,'Marker','*') % Prediction error plot for lambda = 0 and lambda positive
hold on
plot(MRSE_lambdapos,'Linewidth',2,'Marker','*','Color','r')
legend('\lambda = 0', strcat('\lambda = ',num2str(lambda)))
title(strcat(num2str(blocklength),'-step prediction'))
xlabel('p')
ylabel('Mean rel. Error per block')

subplot(2,2,4)
hold off
plot(MRSE_Onestep_lambda0,'Linewidth',2,'Marker','*') % One-Step Prediction error plot for lambda = 0 and lambda positive
hold on
plot(MRSE_Onestep_lambdapos,'Linewidth',2,'Marker','*','Color','r')
legend('\lambda = 0', strcat('\lambda = ',num2str(lambda)))
title('One-step prediction')
xlabel('p')
ylabel('rel. Error')



