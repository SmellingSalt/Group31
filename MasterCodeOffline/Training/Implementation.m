%% INITIALISING MATLAB
% Clears workspace and adds appropriate paths to running directory.
% Also the classes are initialised as well
clear
clc
p1=genpath('Functions');
p2=genpath('Variables');
addpath(p1);
addpath(p2);

%% Algorithm 1
% This part runs algorithm 1. 

%OUTPUTS
%'ClassMean' and 'SubjectMean' are the centers
% with and without outlier removal;
% 'debug' is a random EEG Epoch, 'timestamp' is the time interval the eeg
% data was epoched, 'classes' are the classes extracted from the gdf file,
% 'tanspace' is the rangent space of the covariance matrices of the
% extracted epochs

%INPUTS
%'TrainPath' is the path to the training data, from wherever the this
%MATLAB file is saved
%'nbrClasses' is the vector of classes that we want to classify.

TrainPath='..\..\DataSet\From the Internet\4\subject10\Training GDF\*.gdf';
nbrClasses=[13,17,21];
[ClassMean,SubjectMean,debug,timestamp,classes,TanSpace]=OfflineAlgo(TrainPath,nbrClasses);

%% Testing
% Here, the test path is set and the covariance matrices are formed. The next part tests the obtained covariance matrices. There are with (8*no.of GD files) trails for each class
TestPath='..\..\DataSet\From the Internet\4\subject10\Testing GDF\*.gdf';
test=SubjectEEG(TestPath,nbrClasses);
Ctest=EEGtoCov(test,classes);

%% Plotting
% This section plots the accuracy data calculated above.    
type=["riemann","kullback"];
plotOffline(nbrClasses,SubjectMean,Ctest,type,'Without Outlier Removal');
%figure;
%plotOffline(nbrClasses,ClassMean,Ctest,type,'With Outlier Removal');
