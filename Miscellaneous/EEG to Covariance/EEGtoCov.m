%This function returns the Covariance matrix 
[s,h]=sload('record-[2012.07.06-19.02.16].gdf');
X=ExtEEG(s,h);
for i=1:4
    for j=1:8
        C{i,j}=cov(X{i,j}); %Compute Covriance matrix of each class,trial and store in C
    end
end
