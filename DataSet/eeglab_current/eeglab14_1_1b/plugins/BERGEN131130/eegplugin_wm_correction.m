% eegplugin_wm_correction.m is used as part of the Bergen EEG&fMRI Toolbox 
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

% eegplugin_pca() - pca plugin
function eegplugin_wm_correction( fig, try_strings, catch_strings); 

% create menu
toolsmenu = findobj(fig, 'tag', 'tools');
submenu = uimenu( toolsmenu, 'label', 'Bergen EEG-fMRI Toolbox');

% % build command for menu callback
% cmd = [ '[tmp1 EEG.icawinv] = runpca(EEG.data(:,:));' ]; 
% cmd = [ cmd 'EEG.icaweights = pinv(EEG.icawinv);' ]; 
% cmd = [ cmd 'EEG.icasphere = eye(EEG.nbchan);' ]; 
% cmd = [ cmd 'clear tmp1;' ];
% 
% finalcmd = [ try_strings.no_check cmd ]; 
% finalcmd = [ finalcmd 'LASTCOM = ''' cmd ''';' ]; 
% finalcmd = [ finalcmd catch_strings.store_and_hist. ]; 


 vers = 'm_rp_info v.1.0';
    
    if nargin < 3
        error('Could not find m_rp_info.m');
    end;
  
    % add folder to path
    % ------------------
% % % Command line string
% % str_cmd = 'clc'
% % 
% % finalcmd = str_cmd
% % % add new submenu
% % uimenu( submenu, 'label', 'Using fMRI realigment info', 'callback', finalcmd);
% % 
% % 

%fastrcmd 
comando = [ try_strings.no_check '[EEG LASTCOM] = pop_weighting_matrix(EEG);' catch_strings.new_and_hist ];

% fmribmenu = uimenu(toolsmenu,'label','FMRIB Tools','separator','on','tag','fmrib tools');
option = uimenu(submenu,'label','Remove fMRI gradient artifacts','tag','fastr menu','callback',comando);

