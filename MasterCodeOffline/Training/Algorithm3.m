TrainPath='..\..\DataSet\From the Internet\4\subject10\Training GDF\*.gdf';
w=2.3;                              %Window Length
dn=0.2;                             %Window Spacing
D=10;                               %Number of Epochs
window=[w, dn, D];                  %The window parameters
[X, hand]=SubEEG(TrainPath,window); %X is the EEG structure stored as D Epochs, hand is the time stamps of the epochs that are extracted.
C=EEGtoCov(X);
load('Variables/ClassMean.mat');
