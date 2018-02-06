%This function computes the Covariance matrix from the data X and
%Mean covariance matrix is computed using covariance toolbox's
%"mean_covariance" function
%
%Input data X is a CELL (class x trial)
%Covariance matrix is a 3D matrix (8x8xTrialNo.)
%mean covariance matrix are 3D matrix (8x8xClass)

function [meanCov]= EEGtoCov(X)

% get the organised EEG cell X
ClassLnth=size(X);

%% 
% i is for accessing classes
% j is for accessing trial
for i=1:ClassLnth
    for j=1:length(X)
        C(:,:,j)=cov(X{i,j}); %Compute Covriance matrix of (class,trial) and store in C
    end
    meanCov(:,:,i)= mean_covariances(C,'riemann');
end