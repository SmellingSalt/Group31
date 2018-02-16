%% Load trials of one human subject
% Store all the SSVEP sessions of a person in one location and access all
% of them from there.
% X holds all the extracted EEG data

filePath='..\..\DataSet\From the Internet\4\subject12\record-[2014.03.10-19.17.37].gdf';
[s,h]=sload(filePath);
Xtest{:,:}=ExtEEG(s,h);
Ctest=EEGtoCov(Xtest); % compute covariance matrix of each trail and store in corresponding location

for i=1:4
    a=distance(Ct

%function [Ytest d C] = mdm(Ctest,COVtrain,Ytrain,varargin)

