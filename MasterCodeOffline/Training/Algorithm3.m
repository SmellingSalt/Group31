%% Initialising Data
% TrainPath contains 4 GDF files of 4 different sessions.
% 'hand' is the information about the time stamps for the epoched data from
% TrainPath

%ClassMean is the centre of the clusters for each of these sessions
%computed earlier via 'Implementation'

%timestamp is the time the SSVEP phenomena was actually occuring in the EEG
%signal

%Mean0-Session21 is the collection of class centers for 0Hz,13Hz, 17Hz
%and 21Hz respectively
clear;
clc;
p1=genpath('Functions');
p2=genpath('Variables');
addpath(p1);
addpath(p2);

TestPath='..\..\DataSet\From the Internet\4\subject10\Algo3\*.gdf';
w=2.6;                                      %Window Length
dn=0.2;                                   %Window Spacing
D=7;                                      %Number of Epochs
windw=[w, dn, D];                         %The window parameters
thresh=0.6;                               %probability thresholder
[Xr, hand]=SubEEG(TestPath,windw);        %Xr is the raw EEG structure stored as D Epochs, hand is the time stamps of the epochs that are extracted.

%% Covariances
% Computing Covariance of data and also loading the different class centers
% from offline algorithm, along with the timestamps of original EEG data from offline algorithm.
Cr=PlainEEG2Cov(Xr);                       %Raw covariance matrix of the entire session
nbrClasses=[0,13,17,21];
TrainPath='..\..\DataSet\From the Internet\4\subject10\Training GDF\*.gdf';

[ClassMean,SubjectMean,debug,timestamp,classes,TanSpace]=OfflineAlgo(TrainPath,nbrClasses);
%time=timestamp(:,:,3);
%Cr=OutlierRemoval(Cr,'riemann','riemann',ClassMean);

%% Vector of Predictions
%K holds the predictions of each epoch

[Krn,yes]=Prediction(SubjectMean,Cr,classes,'',windw,thresh);              %Predictions, of raw data
%% Accuracies
% Here we attempt to make the confusion matrix
[target, K]=Labeler(timestamp,hand,classes,Krn);                           %Get the labels of the entire EEG session

[t,o]=confuse(K,target,classes);
[c,cm,ind,per] = confusion(t,o);


