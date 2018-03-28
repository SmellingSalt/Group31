%This function computes the Covariance matrix from the data X.
%
%Input data X is a CELL (class x trial x gdf file).
%Covariance matrix is a cell (class x trialNo. x gdf).
%Output of this function is the 'covariance matrix' - cell structure of the 
% 'X data matrix' - cell structure.

function [C]= EEGtoCov(X)
%% Identify number of gdf files
% find the number of gdf files in the folder/subject and store in gdfLnth
[~,~,gdfLnth]=size(X);

%% Compute Covariance matrix cell
% k is for accessing gdf file
% i is for accessing classes in the k'th gdf file
% j is for accessing trial of i'th class in k'th gdf file

for k=1:gdfLnth
    X1=X{:,:,k}; % X1 is the (no.ofClass X no.ofTrials) of one gdf file
    ClassLnth=size(X1); % ClassLnth stores the size of data in format (no.ofClasses,no.ofTrials)
    for i=1:ClassLnth(1) % getting the no. of classes by taking the first element of ClassLnth 
        for j=1:ClassLnth(2) % this runs for the no. of trials in the gdf file
             C{i,j,k}=shcov(X1{i,j}); %Compute Covriance matrix of (class,trial) and store in C for all the gdf files in the folder
        end
 %   meanCov(:,:,i)= mean_covariances(C,'riemann');
    end
end


