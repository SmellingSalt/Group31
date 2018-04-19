%This function returns a structure that has all the EEG data of different
%sessions stored in a 3D struct
%window is a variable that holds [window length ; window gap] 
function [X,hand]=SubEEG(filePath,window)
%% File Location
% This section gets the names of the gdf EEG files that are stored in a particular location giving the 'name' and 'path' cell structures
% which holds the names of all the gdf files found in that path.
fileHandle=dir(filePath);                                                   %This is a structure that has all the file names with the .gdf extention in the path specified above
name={fileHandle.name};                                                     %The name of the file
path={fileHandle.folder};                                                   %The folder where the file is stored

%% Collecting
% This part collects all the EEG data from different trials and stores it
% in X
path1=path{1,1};                                                            %Since we are looking at only one folder at a time, this will not change


name1=name{1,1};                                                        %Iterates over all the file names
[s,h]=sload([path1, '\',name1]);                                        %Loads the particular gdf file into s and h
[tempx,hand]=ExEEG(s,h,window);
X{:,:,1}=tempx;



