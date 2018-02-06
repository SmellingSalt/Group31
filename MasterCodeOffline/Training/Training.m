%% Load trials of one human subject
% Store all the SSVEP sessions of a person in one location and access all
% of them from there.
% X holds all the extracted EEG data

filePath='..\..\DataSet\Old BCI Data\fyp2016data\gdf\*.gdf';
X=SubjectEEG(filePath);

