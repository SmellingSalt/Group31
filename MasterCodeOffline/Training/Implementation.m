%% Load trials of one human subject
% Store all the SSVEP sessions of a person in one location and access all
% of them from there.
% X holds all the extracted EEG data

filePath='..\..\DataSet\From the Internet\4\subject10\Training GDF\*.gdf';
%C:\Users\Prashanth HC\Desktop\Group31\DataSet\From the Internet\4\subject12
X=SubjectEEG(filePath); % extracts the eeg data from all gdf files in the folder


%% Covariance Matrix
% The covariance matrix is constructed here and then the center of the
% clusters is also computed. The tangent space projection of the matrices
% are also obtained
C=EEGtoCov(X); % compute covariance matrix of each trail and store in corresponding location
[ClassMean, TanSpace]=CovMean(C); % returns the Cluster center/mean Covariance matrix of the subject

