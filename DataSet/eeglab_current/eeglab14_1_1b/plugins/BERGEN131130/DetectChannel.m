% Detectchannel.m is a sub function used by Bergen EEG&fMRI Toolbox for 
% EEGLAB in order to detect the channel with the lowest gradient among the
% channels of the dataset. This function is used internaly by
% DetectMarkers.m.
% 
% USAGE: 
%       [ ch ] = DetectChannel(EEG);
% 
% INPUTS:
%        EEG - is the structure loaded by the EEGLAB. This structure must
%              have a loaded dataset. This function uses internaly the 
%              dataset refered as the CURRENTSET.
% 
% OUTPUTS:
%         ch - is the choosen channel with the lowest variance among the
%         EEG dataset channels.
% 
% See also var

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

function [ch] = DetectChannel(EEG);
    total_ch = EEG.nbchan;
    for i=1 : total_ch
        channel_filter(i) = var(EEG.data(i,:)); % Filter based on variance
    end
    [val, ch] = min(channel_filter);
end