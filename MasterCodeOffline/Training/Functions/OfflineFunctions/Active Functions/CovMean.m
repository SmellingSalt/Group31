%This function computes the means covariance matrices of the input
%covariance matrix cell structute.
%Input is the covariance matrix cell structure.
%Output is the mean covariance matrix cell structure.
%It uses the 'mean' set of functions in the covariance toolbox:
%https://github.com/alexandrebarachant/covariancetoolbox
%
%NOTE that the toolbox requires the input to be in matrix format
%Hence conversion between cell-matrix type is necessary.

function [ meanCov, TanSpace ] = CovMean( C )
%% Data format adjustment and Mean Covariance Computation
%size returns the (ClassLnth , No.ofTrials , No.ofFiles)
[ClassLnth, trials, files]=size(C); 

% i is used to access class
% j is used to acces file
% k is used to access trial

for i=1:ClassLnth %Classes one by one
    % Extract all trials of the class and store in C1
    for j=1:files 
        for k=1:trials %The trials in th file
            C1{:,k,j}=C{i,k,j};%C1 is a (1 x No.ofTrials x No.ofFiles) cell
        end
    end  
    
    %Next convert the 'covariance matrix cell C1' to matrix in the
    %format NxNxTotalNo.oftrials 
    % Where N is the No.of features/channels
    [ClassNo , trialNo, fileNo]=size(C1);
 
    r=1; % r is used to form a NxNxr matrix
    for p=1:fileNo
        for q=1:trialNo
            C2(:,:,r)=C1{:,q,p};
            r=r+1;
        end
    end
    
    
    %% Mean Covariances computation
    % Here the second argument can be any of
    % {riemann, riemanndiag, riemanntrim, median, riemannmed, logeuclid,
    %  opttransp, ld, geodesic, harmonic, geometric}
    % Less than 3 arguments signifies the calculated is the arithmatic mean
    meanCov{:,:,i} = mean_covariances(C2,'riemann');
    TanSpace=Tangent_space(C2);
end
