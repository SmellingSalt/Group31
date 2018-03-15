% UseMarker.m is used as part of the Bergen EEG&fMRI Toolbox 
% plugin for EEGLAB.
% 
% Copyright (C) 2009 The Bergen fMRI Group
% 
% Bergen fMRI Group, Department of Biological and Medical Psychology,
% University of Bergen, Norway
% 
% Written by Emanuel Neto, 2009
% netoemanuel@gmail.com
% 
% Last Modified on 18-Jun-2009 08:07:11
% 
function [ Peak_references ] = UseMarker( EEG, Marquer )
%UNTITLED1 Summary of this function goes here
%  Detailed explanation goes here
k=1;
for a=1:length(EEG.event)
    if strcmp(EEG.event(a).type, Marquer)
        Peak_references(k)=EEG.event(a).latency;
        k=k+1;
    end
end