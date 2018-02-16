%This function removes the artifact/outliers in the cluster
%input is C with outliers
%output is C with otliers removed
%outlier is done as described by "Alexandre Barachant, Anton Andreev, 
%Marco Congedo. The Riemannian Potato: an automatic and
%adaptive artifact detection method for online experiments using Riemannian
%geometry. TOBI Workshop lV, Jan 2013, Sion, Switzerland. pp.19-20, 2013.
%<hal-00781701>"
%
%dependency is covariancetoolbox
%NOTE that conversion between cell and matrix structures is performed

function Co = outlierRemoval(Cin, method_mean, method_distance)
%% Data format adjustment and Outlier Removal
%size returns the (ClassLnth , No.ofTrials , No.ofFiles)
[ClassLnth, trials, files]=size(Cin);

% i is used to access class
% j is used to acces file
% k is used to access trial

for i=1:ClassLnth %Classes one by one
%% Extract all trials of the class and store in C1
    for j=1:files 
        for k=1:trials %The trials in th file
            C1{:,k,j}=Cin{i,k,j};%C1 is a (1 x No.ofTrials x No.ofFiles) cell
        end
    end  
    
    %Next convert the 'covariance matrix cell C1' to matrix 'COV' in the
    %format NxNxTotalNo.oftrials 
    % Where N is the No.of features/channels
    [ClassNo, trialNo ,fileNo]=size(C1);

    r=1; % r is used to form a NxNxr matrix
    for p=1:fileNo
        for q=1:trialNo
            COV(:,:,r)=C1{:,q,p};
            r=r+1;
        end
    end
%% Outlier Removal
    I = size(COV,3);
    %Consider the first one as the reference
    C2=COV(:,:,1);
    window = I; 
    % distances
    dist = zeros(I,1);
    % artefact[C th dist art Ci thi]
    art = zeros(I,1);       
    %mean distance
    mu = zeros(I,1);  
    %std of distance
    std = ones(I,1);
    
    m=1;    
    for n=2:I
        dist(n) = distance(COV(:,:,n),C2,method_distance);
        if (dist(n) < mu(n-1)+2.5*std(n-1))||(n<10)
            m=m+1;
            alpha = min([m window]);
            mu(n) = ((alpha-1)/alpha)*mu(n-1)+(1/alpha)*dist(n);
            std(n) = sqrt(((alpha-1)/alpha)*(std(n-1)^2)+(1/alpha)*(dist(n)-mu(n))^2);
            C2 = geodesic(C2,COV(:,:,n),1/alpha,method_mean);
        else
            mu(n) = mu(n-1);
            std(n) = std(n-1);
            art(n) = 1;
        end
        C3(:,:,n) = C2;
        thi(n) = mu(n)+2.5*std(n);
    end
    
    th = mu(n)+2.5*std(n);
    
%%    
%Converting back from matrix to cell structure
    r=1; % r is used to access the NxNxr matrix elements
    for p=1:fileNo
        for q=1:trialNo
            Co{i,q,p}=C3(:,:,r);
            r=r+1;
        end
    end   
end
    
 
    
