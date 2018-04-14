function [ClassMean,SubjectMean,debug,timestamp,classes,TanSpace]=OfflineAlgo(TrainPath,nbrClasses)
%% Load trials of one human subject
% Store all the SSVEP sessions of a person in one location and access all
% of them from there.
% X holds all the extracted EEG data
[X,debug, timestamp,classes]=SubjectEEG(TrainPath,nbrClasses);              % extracts the eeg data from all gdf files in the folder


%% Covariance Matrix
% The covariance matrix is constructed here and then the center of the
% clusters is also computed. The tangent space projection of the matrices
% are also obtained
C=EEGtoCov(X,classes);                                                      % compute covariance matrix of each trail and store in corresponding location
[SubjectMean]=CovMean(C);                                              % returns the Cluster center/mean Covariance matrix of the subject
                                                                            % before outlier removal

%% Outlier Removal
%This is a crude optimisation to remove outliers
Co=OutlierRemoval(C,'riemann','riemann',SubjectMean);
[ClassMean, TanSpace]=CovMean(Co);                                           % returns the Cluster center/mean Covariance matrix
end