% EMDLAB plug-in is a toolbox ,implemented as EEGLAB plug-in, used for processing and visualization data using EEGLAB data structures. 
% This code allows to process a continuous and event-related EEG, MEG and other electrophysiological data using Empirical Mode 
% Decomposition algorithm (EMD), Ensemble EMD algorithm (EEMD), Multivariate EMD algorithm (MEMD) and Wighted Sliding EMD (wSEMD).
%   - to perform EMD, EEMD, MEMD, wSEMD.
%   - to perform several useful types of visualization of the event related mode (ERM) and single-trial mode.  
%
%
% Acknowledgment: This plugin is basically based on the EEGLAB Toolbox code, publicly available from
%                http://sccn.ucsd.edu/eeglab/downloadtoolbox.html , EMD code prepared by Zhaohua Wu (zhwu@cola.iges.org)
%                ,MEMD prepared by Naveed ur Rehman and Danilo P. Mandic, Oct-2009 and wSEMD prepared by  Angela Zeiler  
%                (angela.zeiler@biologie.uni-regensburg.de). 
%
%
% Authors:Karema Al-Subari and Saad Al-Baddai, CIML group,Regensburg Uni, 2014
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License of EEGLAB as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%




function eegplugin_EMD( fig, try_strings, catch_strings);

 
e_try             = 'try,';
ret               = 'if ~isempty(LASTCOM), if LASTCOM(1) == -1, LASTCOM = ''''; return; end; end;';
checkemd          = ['[EEG LASTCOM] = eeg_checksetemd(EEG, ''data'');' ret ' eegh(LASTCOM);' e_try];
checkemdplot      = ['[EEG LASTCOM] = eeg_checksetemd(EEG, ''emd'');' ret ' eegh(LASTCOM);' e_try];
e_catch           = 'catch, eeglab_error; LASTCOM= ''''; clear EEGTMP ALLEEGTMP STUDYTMP; end;';
ifeegnh           =  'if ~isempty(LASTCOM) & ~isempty(EEG) & ~isempty(findstr(''='',LASTCOM)),';
storecall         = '[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET); eegh(''[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);'');';
e_store           = [e_catch 'EEG = eegh(LASTCOM, EEG);' ifeegnh storecall    'disp(''Done.''); end; eeglab(''redraw'');'];
e_hist            = [e_catch 'EEG = eegh(LASTCOM, EEG);'];
checkepochemd      = ['[EEG LASTCOM] = eeg_checksetemd(EEG, ''emd_epoch'');' ret ' eegh(LASTCOM);' e_try];

% build command for menu callback\\




cb_runemd      = [ checkemd      '[EEG LASTCOM] = pop_runemd(EEG);'   e_store];
cb_eegplot3    = [ checkemdplot      '[LASTCOM] = pop_eegplotemd(EEG,2, 1, 1);' e_hist];
cb_spectopo3   = [ checkemdplot  'LASTCOM = pop_spectopoemd(EEG);'    e_hist];
cb_topoplot3   = [ checkemdplot  'LASTCOM = pop_topoplotemd(EEG);'        e_hist];
cb_headplot3   = [ checkemdplot  '[ LASTCOM] = pop_headplotemd(EEG);'  e_store];
cb_prop3       = [ checkemdplot  'LASTCOM = pop_propemd(EEG);'             e_hist];
cb_erpimage3   = [ checkepochemd 'LASTCOM = pop_ermimageemd(EEG, eegh(''find'',''pop_ermimageemd(EEG,1''));' e_hist];
cb_erpimage4   = [ checkepochemd 'LASTCOM = pop_HilbertFourierSpectrum(EEG);' e_hist];
cb_envtopo3    = [ checkemd      'LASTCOM = pop_envtopo(EEG);'            e_hist];
cb_envtopo2    = [ checkemd      'if length(ALLEEG) == 1, error(''Need at least 2 datasets''); end; LASTCOM = pop_envtopo(ALLEEG);' e_hist];
cb_plottopoemd    = [ checkepochemd   'LASTCOM = pop_plottopoemd(EEG);'           e_hist];
cb_timtopoemd  = [ checkepochemd  'LASTCOM = pop_timtopoemd(EEG);'            e_hist];
cb_comperp3    = [ checkepochemd 'LASTCOM = pop_comperm(ALLEEG);'      e_hist];


 
% menu definition
% --------------- 
if nargin==1
menuEMDLAB = findobj(gcf,'tag','EEGLAB');   % At EEGLAB Main Menu
EMDmenu = menuEMDLAB;
%get(EMDmenu,'position', 6);
else

menuEMDLAB = findobj(fig,'tag','EEGLAB');   % At EEGLAB Main Menu
EMDmenu = uimenu( menuEMDLAB,'Label','EMDLAB','separator','on','tag','erpsets','userdata','startup:on;continuous:on;epoch:on;study:on;erpset:on');
uimenu( EMDmenu,'Label','Run EMD', 'callback', cb_runemd, 'separator','on','tag','erpsets1','userdata','startup:on;continuous:on;epoch:on;study:on;erpset:on');
uimenu( EMDmenu,'Label','Scrolling Modes','CallBack', cb_eegplot3,'separator','on','tag','erpsets2','userdata','startup:off;continuous:off;epoch:off;study:off;erpset:on','enable','off');
uimenu( EMDmenu,'Label','Power Spectra and Maps','CallBack', cb_spectopo3,'separator','off','tag','erpsets3','userdata','startup:off;continuous:off;epoch:off;study:off;erpset:on','enable','off');
temd_m=uimenu( EMDmenu,'Label','ERM Maps','separator','off','tag','erpsets4','userdata','startup:off;continuous:off;epoch:off;study:off;erpset:on','enable','off');
uimenu(temd_m,'Label','In 2-D','CallBack', cb_topoplot3,'separator','off','tag','erpsets5','userdata','startup:off;continuous:off;epoch:off;study:off;erpset:on','enable','off');
uimenu(temd_m,'Label','In 3-D','CallBack', cb_headplot3,'separator','off','tag','erpsets6','userdata','startup:off;continuous:off;epoch:off;study:off;erpset:on','enable','off');
uimenu( EMDmenu,'Label','Mode Properties','CallBack', cb_prop3,'separator','off','tag','erpsets7','userdata','startup:off;continuous:off;epoch:off;study:off;erpset:on','enable','off');
uimenu( EMDmenu,'Label','Hilbert-Huang/Fourier Transform','CallBack', cb_erpimage4,'separator','off','tag','erpsets8','userdata','startup:off;continuous:off;epoch:off;study:off;erpset:on','enable','off');
uimenu( EMDmenu,'Label','IMFs and ERM','CallBack', cb_erpimage3,'separator','off','tag','erpsets9','userdata','startup:off;continuous:off;epoch:off;study:off;erpset:on','enable','off');
ERMC_m=uimenu( EMDmenu,'Label','ERM and Maps','separator','off','tag','erpsets10','userdata','startup:off;continuous:off;epoch:off;study:off;erpset:on','enable','off');
uimenu(ERMC_m,'Label','With modes maps','CallBack', cb_timtopoemd,'separator','off','tag','erpsets11','userdata','startup:off;continuous:off;epoch:off;study:off;erpset:on','enable','off');
uimenu(ERMC_m,'Label','In rectangular array','CallBack', cb_plottopoemd,'separator','off','tag','erpsets12','userdata','startup:off;continuous:off;epoch:off;study:off;erpset:on','enable','off');
uimenu( EMDmenu,'Label','Compare ERMs', 'CallBack', cb_comperp3,'separator','off','tag','erpsets13','userdata','startup:off;continuous:off;epoch:off;study:off;erpset:on','enable','off');
set(EMDmenu,'position', 6); 

end

%% add paths

eeglabpath = which('eegplotemd.m');
eeglabpath = eeglabpath(1:end-length('eegplotemd.m'));      
if strcmpi(eeglabpath, './') || strcmpi(eeglabpath, '.\'), eeglabpath = [ pwd filesep ]; end;
EMDpath  = fullfile(eeglabpath, 'EMD');
MEMDpath = fullfile(eeglabpath, 'MEMD');
SEMDpath = fullfile(eeglabpath, 'SEMD');
addpath( EMDpath );
addpath( MEMDpath );
addpath( SEMDpath );

        end
