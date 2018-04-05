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
%% Filtered EEG Epoch
% Spit the filtered Epoch so that it can be uploaded onto github. x1-x4 is
% then recombined as Xfiter  again, after loading x1-x4.

%Band pass filtered epoch data. Saved it since it takes really long to compute
load('Variables/x1.mat');                   
load('Variables/x2.mat');                   
load('Variables/x3.mat');                   
load('Variables/x4.mat');        

Xfilter{:,:,1}=x1;
Xfilter{:,:,2}=x2;
Xfilter{:,:,3}=x3;
Xfilter{:,:,4}=x4;
%% Covariances
% Computing Covariance of data and also loading the different class centers
% from offline algorithm, along with the timestamps of original EEG data from offline algorithm.

Cn=EEGtoCov(Xr);                                    %Raw covariance matrix of the entire session
Cf=EEGtoCov(Xfilter);                               %Band Pass Filtered data (Loaded as X)

load('Variables/ClassMean.mat');                    %From Algorithm 1,2
load('Variables/ClassMeanOutlier.mat');             %From Algorithm 1,2
load('Variables/timestamp.mat');                    %From Algorithm 1,2


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

