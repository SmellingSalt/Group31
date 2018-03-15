function [w,mean_rsquared,rsquared]=m_best_rsquare_artifact(a,n_best_rsquared)
% A=rand(11701,284); % 200 Artifact which are 10000 data points long
A=A';
%n_best_rsquared: Take the best n correlating artifacts for the template
rsquared=(corrcoef(A')).^2;
[y,i]=sort(rsquared); % sort the rsquared values -> i is the index variable
w=zeros(size(rsquared)); % initialize weighting matrix

index_best_rsquared=i(end-n_best_rsquared+1:end,:); % these are the indexes of the best rsquare values

rsquared_best_rsquared=y(end-n_best_rsquared+1:end,:); % these are the rsquared values of these 
mean_rsquared=mean(rsquared_best_rsquared);

for m=1:length(w)
    w(m,index_best_rsquared(:,m))=1; % set the weighting matrix of those values 1
end


figure;imagesc(w)
figure;imagesc(rsquared)