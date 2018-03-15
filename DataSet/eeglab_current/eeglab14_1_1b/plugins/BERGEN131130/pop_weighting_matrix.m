% pop_weighting_matrix.m is used as part of the Bergen EEG&fMRI Toolbox 
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

function [ EEGOUT, output ] = pop_weighting_matrix( EEG )
%  UNTITLED1 Summary of this function goes here
%  Detailed explanation goes here

EEGOUT = [];
output = '';

%Call Gui
guifig=gui_weighting_matrix();     
