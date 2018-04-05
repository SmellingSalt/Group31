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
TrainPath='..\..\DataSet\From the Internet\4\subject10\Training GDF\*.gdf';
w=2.6;                                      %Window Length
dn=0.2;                                     %Window Spacing
D=5;                                        %Number of Epochs
window=[w, dn, D];                          %The window parameters

[Xr, hand]=SubEEG(TrainPath,window);        %Xr is the raw EEG structure stored as D Epochs, hand is the time stamps of the epochs that are extracted.
load('Variables/Xepochfilt.mat');           %Band pass filtered epoch data. Saved it since it takes really long to compute

Cn=EEGtoCov(Xr);                             %Raw covariance matrix of the entire session
Cf=EEGtoCov(X);                              %Band Pass Filtered data (Loaded as X)

load('Variables/ClassMean.mat');            %From Algorithm 1,2
load('Variables/ClassMeanOutlier.mat');            %From Algorithm 1,2
load('Variables/timestamp.mat');            %From Algorithm 1,2


%% Vector of Predictions
%K holds the predictions of each epoch
Krn=Prediction(ClassMean,Cn,'riemann');             %Predictions, of raw data
Kfn=Prediction(ClassMean,Cf,'riemann');             %Predictions, of filtered data
Kro=Prediction(ClassMeanOutlier,Cf,'riemann');      %Predictions, of filtered data using outlier removed mean
Kno=Prediction(ClassMeanOutlier,Cf,'riemann');      %Predictions, of filtered data using outlier removed mean

krn=Krn(:,:,3);
kfn=Kfn(:,:,3);
kro=Kro(:,:,3);
kno=Kno(:,:,3);

time=timestamp(1,1,3);

