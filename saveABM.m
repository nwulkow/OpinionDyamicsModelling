function saveABM(N,T,Alpha,pinside,pbetween,noClusters,A,C,ms,name)
% Copyright 2020, All Rights Reserved
% Code by Niklas Wulkow
% For Paper, "Memory-based reduced modeling and data-based estimation of opinion spreading"
% by Niklas Wulkow, Peter Koltai and Christof Schuette

% Save ABM settings and output in .mat-File

abmconfig.N = N;
abmconfig.T = T;
abmconfig.Alpha = Alpha;
abmconfig.pinside = pinside;
abmconfig.pbetween = pbetween;
abmconfig.noClusters = noClusters;
abmconfig.A = A;
abmconfig.C = C;
abmconfig.ms = ms;
if(strcmp(name,'auto'))
    name = strcat('N' ,num2str(N), 'T', num2str(T) , 'noClu' , num2str(noClusters));
end
save(strcat('abmconfig_',name),'abmconfig')