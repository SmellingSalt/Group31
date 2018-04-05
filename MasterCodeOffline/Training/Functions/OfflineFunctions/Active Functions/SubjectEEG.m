%This function returns a structure that has all the EEG data of different
%sessions stored in a 3D struct

function [X,debug,timestamp]=SubjectEEG(filePath)
%% File Location
% This section gets the names of the gdf EEG files that are stored in a particular location giving the 'name' and 'path' cell structures
% which holds the names of all the gdf files found in that path.
fileHandle=dir(filePath); %This is a structure that has all the file names with the .gdf extention in the path specified above
name={fileHandle.name}; %The name of the file
path={fileHandle.folder};%The folder where the file is stored

%% Collecting
% This part collects all the EEG data from different trials and stores it
% in X
path1=path{1,1}; %Since we are looking at only one folder at a time, this will not change

for i=1:length(name)
    name1=name{1,i};    %Iterates over all the file names
    [s,h]=sload([path1, '\',name1]); %Loads the particular gdf file into s and h
    [temp1, temp2]=ExtEEG(s,h);
    X{:,:,i}=temp1;
    timestamp{:,:,i}=temp2;
end
[len,bred,ht]=size(X);
debug=X{randi(len),randi(bred),randi(ht)};
debug=debug{:,:};
