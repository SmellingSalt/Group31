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
p1=genpath('Functions');
p2=genpath('Variables');
addpath(p1);
addpath(p2);

TrainPath='..\..\DataSet\From the Internet\4\subject10\Algo3\*.gdf';
w=2.6;                                      %Window Length
dn=0.15;                                     %Window Spacing
D=5;                                        %Number of Epochs
windw=[w, dn, D];                          %The window parameters
[Xr, hand]=SubEEG(TrainPath,windw);        %Xr is the raw EEG structure stored as D Epochs, hand is the time stamps of the epochs that are extracted.

%% Covariances
% Computing Covariance of data and also loading the different class centers
% from offline algorithm, along with the timestamps of original EEG data from offline algorithm.
Cr=PlainEEG2Cov(Xr);                                    %Raw covariance matrix of the entire session
nbrClasses=[0,13,7,21];
[ClassMean,SubjectMean,debug,timestamp,classes,TanSpace]=OfflineAlgo(TrainPath,nbrClasses);
%time=timestamp(:,:,3);
%Cr=OutlierRemoval(Cr,'riemann','riemann',ClassMean);

%% Vector of Predictions
%K holds the predictions of each epoch
[Krn,yes]=Prediction(SubjectMean,Cr,classes,'',windw);              %Predictions, of raw data

%% Visualising Predictions
% Just for visualising the predictions of the algorithm, not needed 




