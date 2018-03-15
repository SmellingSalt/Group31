% pop_ermimageemd() - draw an  ERM-image (event related mode) plot of a given mode of EEG channel .
%                  Uses a pop-up window if less than three (or four 
%                  in one condition) input arguments are supplied. Calls ermimageemd(). 
%                  For futher details see >> help ermimageemd
% Usage:
%   >> pop_ermimageemd(EEG);          % pop-up a data entry window
%   >> pop_ermimageemd(EEG, lastcom); % pop-up a data entry window
%   >> pop_ermimageemd(EEG, channel); % no pop-up window
%   >> pop_ermimageemd(EEG, channel, projchan, title, ...
%                  smooth, decimate, sortingtype, sortingwin, ...
%                            sortingeventfield, renorm, options...);
% Graphic interface:
%   "mode"     - [popup menu] select number of the mode.
%   "Channel " - [edit box] Enter channel number 
%                to plot. ermimageemd() equivalent: 'channel' 
%   "Smoothing" - [text box] Smoothing parameter in number of trials.
%                 ermimageemd() equivalent: 'smooth' 
%   "Downsampling" - [edit box] Decimate parameter. 
%                 ermimageemd() equivalent: 'decimate' 
%   "Time limits" - [edit box] Enter the time limits in milliseconds. 
%                 ermimageemd() equivalent: the 1st and 2nd parameters of the 'limit' array
%   "Figure title" - [edit box] Enter the figure title here.  If empty, a title
%                 is automatically generated. ermimageemd() equivalent: 'title' 
%   "Plot scalp map" - [checkbox] Setting this option plot a scalp map of the 
%                 channel location (or component topography) next to the 
%                 ermimageemd. ermimageemd() equivalent: 'topo' 
%   "plot ERM" - [checkbox] Setting this option plot the channel or component 
%                 ERM below the ERM image. ermimageemd() equivalent: 'erm' 
%   "Plot colorbar" - [checkbox] Plot the colorbar on the right of the ermimageemd. 
%                 ermimageemd() equivalent: 'cbar' 
%   "ERM limits" - [edit box] Set the minimum and maximum value for the ERM plot
%                 ermimageemd() equivalent: 3rd and 4th parameters of the 'limit' array 
%   "Color limits" - [edit box] Set the color limits for the ERM image. 
%                 ermimageemd() equivalent: 'caxis' 
%   "Epoch sorting field" - [button and edit box] Specify the event field which
%                 values will be used to sort the trials. For instance, if you
%                 select the 'latency' fields, trials will be sorted by the 
%                 latency of the selected events.
%                 ermimageemd() equivalent: 'sortingeventfield'
%   "Event type(s)" - [button and edit box] Specify which event subset to select,
%                 based on the event 'type' field values (to scan for event types, use 
%                 menu Edit > Events values and look at the values of the 'type'
%                 field). For instance, entering type 'rt' (if defined) and field 
%                 'latency' in option aboce will sort trials on reaction time latencies. 
%                 When several selected events are present in individual trials, 
%                 the first event values are used for sorting and a warning is issued. 
%                 ermimageemd() equivalent: 'sortingtype'
%   "Event time range" - [edit box] Specify which event subset to select based on 
%                 event latency values. As the option above, this further restrains 
%                 the selection of events. For example, entering [200 300] in this 
%                 box, 'rt' for the event type (above), and 'latency' for the 
%                 epoch sorting field will select trials with reaction-time latencies
%                 in between 200 and 300 ms. Trials with no such event will not be
%                 included in the ERM-image plot. ermimageemd() equivalent: 'sortingwin'  
%   "rescale" - [edit box] 'yes', 'no', or a Matlab formula. 
%                 ermimageemd() equivalent: 'renorm' 
%   "align" - [edit box] Set this to 'Inf' to re-align the individual trials 
%                 on the median latency of the selected events. Else, enter an epoch time 
%                 (in ms) to align the events to (Ex: 0). ermimageemd() equivalent: 'align' 
%   "Don't sort by value" - [checkbox] Check this box if you do not want to 
%                 sort the trials but do want to plot the selected event values. 
%                 ermimageemd() equivalent: 'nosort' 
%   "Don't plot value" - [checkbox] Check this box if you do not want to 
%                 plot the selected event values, but still want to sort 
%                 the data trials according to these values. 
%                 ermimageemd() eqivalent: 'noplot' 
%   "Sort by phase > Frequency" - [edit box] Specify the frequency or frequency 
%                 range for sorting trials by phase. ermimageemd() equivalent: 
%                 3rd and 4th inputs to 'phasesort' 
%   "Window center (ms)" - [edit box] ermimageemd() equivalent: 1st 'phasesort' input
%   "Percent low-amp. trials to ignore" - [edit box] ermimageemd() equivalent: 
%                 2nd 'phasesort' input 
%   "Wavelet cycles" - [text] Number of wavelet cycles used for spectral decomposition 
%                 at the specified latency. To change this, see "More options" {default: 3}
%   "Inter-trial coherence options > Frequency" - [edit box] Frequency at which  
%                 to compute coherence. Constrained to be the same as the 
%                 "Sort by phase > Frequency" edit box. ermimageemd() equivalent: 'coher' 
%   "Signif. level" - [edit box] Coherence significance cutoff, as a proability
%                  (Ex: .05). ermimageemd() equivalent: 'signif' 
%   "Amplitude limit" - [edit box] Amplitude limits [min max] for the data power 
%                 plot at the selected frequency. ermimageemd() equivalent:
%                 5th and 6th inputs to 'limit' 
%   "Coher limits" - [edit box] Upper limit (<=1) for the coherence 
%                 plot. ermimageemd() equivalent: 7th and 8th inputs of 'limit' 
%   "Image amps" - [checkbox] Check this box for plotting the spectral amplitude
%                 image at the selected frequency (instead of plotting EEG potential). 
%                 ermimageemd() equivalent: 'plotamp'
%   "Plot spectrum" - [edit box] Plot the channel or component data spectrum in 
%                 the top right corner of the ERM image. ermimageemd() equivalent: 'spec' 
%   "Baseline ampl." - [edit box] Baseline amplitude for data power plot at the 
%                 selected frequency. ermimageemd() equivalent: 7th inputs of 'limit'
%   "Mark times" - [edit box] Time(s) in ms to plot vertical lines.
%                 ermimageemd() equivalent: 'vert' 
%   "More options" - [edit box] Enter 'key', 'value' sequences. Other ermimageemd()
%                 options not handled by this interface, including: 'ermstd' to 
%                 plot the ERM standard deviation; 'auxvar' to plot auxilary 
%                 variables; 'ampsort' to sort trials based on amplitude at 
%                 the selected frequency, etc.  For further information see  
%                 >> help ermimageemd() 
% Inputs:
%   EEG        - dataset structure
%   lastcom    - string containing previous pop_ermimageemd command (from LASTCOM) 
%                or from the previous function call output.  The values from this 
%                function call are used as default in the graphic interface.
%
% Commandline options:
%   channel    - Index of channel or component(s) to plot {default: 1}
%   projchan   - Channel to back-project the selected component(s) to. 
%                If plotting channel activity, this argument is ignored. 
%                If [], the ICA component activation is plotted {default []}.
%   title      - ['string'] Plot title {default: []}
%   smooth     - Smoothing parameter (number of trials). {Default: 5} 
%                ermimageemd() equivalent: 'avewidth' 
%   decimate   - Decimate parameter (i.e. ratio of trials_in/trials_out).
%                ermaimge() equivalent: 'decimate' {Default: 0}
%   sortingtype - Sorting event type(s) ([int vector]; []=all). See Notes below.
%                Either a string or an integer.
%   sortingwin - Sorting event window [start, end] in seconds ([]=whole epoch)
%   sortingeventfield - Sorting field name. {default: none}. See Notes below.
%   options    - ermimageemd() options, separated by commas (Ex: 'erm', 'cbar'). 
%                {Default: none}. For further details see >> ermimageemd help   
%
% Outputs from pop-up: 
%   String containing the command used to evaluate this plotting function
%   (saved by eeglab() as LASTCOM). Enter it as the 'lastcom' input to restore
%   the previous parameters as defaults in a new pop_ermimageemd() pop-up window
%
% Outputs from commandline:
%   Same as ermimageemd(). Note: No outputs are returned when a window pops-up 
%   to ask for additional arguments
%   
% Notes:
%   1) A new figure is created only when the pop-up window is called, 
%      so you may call this command with >3 args to draw in sbplot() axes.
%   2) To sort epochs, first define the event field to be used with
%      the argument 'sortingeventfield' (for instance 'latency'). Then,
%      because there may be several events with different latencies in a
%      given epoch, it is possible to consider only a subsets of events
%      using the 'sortingtype' and 'sortingwin' arguments. The 
%      'sortingtype' argument selects events with definite types. The 
%      'sortingwin' argument helps to define a specific time window in the 
%      epoch to select events. For instance the epoch time range may be -1 
%      to 2 seconds but one may want to select events only in the range 0 
%      to 1 second. These three parameters are forwarded to the function
%      eeg_getepochevent(), whose help message contains more details.
%
%  This code is written by Arnaud Delorme, CNL / Salk Institute, 2001 and modified by
%  Karema Al-Subari (Karema.Al-Subari@ur.de) and Saad Al-Baddai (Saad.Al-Baddai@ur.de).
%
%
% See also: ermimageemd(), eeg_getepochevent()


% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

% 01-25-02 reformated help & license -ad 
% 02-12-02 added new event format compatibility -ad 
% 02-15-02 text interface editing -sm & ad 
% 03-07-02 add the eeglab computeica options -ad
% 02-15-02 modified the function accoring to the new event/epoch structure -ad
% 03-18-02 added title -ad & sm
% 04-04-02 added outputs -ad & sm

function varargout = pop_ermimageemd( EEG, channel, projchan, titleplot, smooth, decimate, sortingtype, ...
            sortingwin, sortingeventfield, varargin)



typeplot = 1;
varargout{1} = '';
if ~isfield( EEG,'IMFs' )
		errordlg2(strvcat('Error: no data to plot.'), 'Error'); return;
	end;
if nargin < 1
   help pop_ermimageemd;
   return;
end;

for i=2:size(EEG.IMFs,2)
 names{i-1}=strcat('ERM_',num2str(i-1)); % fil
end


if EEG.trials == 1
   error('ermimageemd of one trial cannot be plotted');
end;   

if nargin < 2	
	typeplot = 1; %1=signal; 0=component
end;
lastcom = [];
if nargin < 3
	popup = 1;
else
	popup = isstr(channel) | isempty(channel);
	if isstr(channel)
		lastcom = channel;
	end;
end;

if popup
	% get contextual help
	% -------------------
    clear functions;
    ermimagefile = which('ermimageemd.m');
	[txt2 vars2] = gethelpvar(ermimagefile);
	txt  = { txt2{:}};
	vars = { vars2{:}};
	% [txt vars] = gethelpvar('ermimopt.m');
	% txt  = { txt{:} txt2{:}};
	% vars = { vars{:} vars2{:}};
    
    opt.topo         = getkeyval(lastcom, 'topo', 'present', 1);
    opt.fieldname    = getkeyval(lastcom, 10);
    opt.type         = getkeyval(lastcom, 8);
    opt.renorm       = getkeyval(lastcom, 'renorm','', 'no');
    opt.erm          = fastif(getkeyval(lastcom, '''erm''', 'present', 1), 'on', 'off');
    opt.cbar         = fastif(getkeyval(lastcom, 'cbar', 'present', 1), 'on', 'off');
    opt.nosort       = fastif(getkeyval(lastcom, 'nosort', 'present', 0), 'on', 'off');
    opt.noplot       = fastif(getkeyval(lastcom, 'noplot', 'present', 0), 'on', 'off');
    opt.plotamps     = fastif(getkeyval(lastcom, 'plotamps', 'present', 0), 'on', 'off');
    opt.index        = str2num(getkeyval(lastcom,3,[],'1'));
    opt.smoothing    = str2num(getkeyval(lastcom, 6, [], int2str(min(max(EEG.trials-5,0), 10))));
    opt.downsampling = str2num(getkeyval(lastcom, 7, [], '1'));
    opt.caxis        = str2num(getkeyval(lastcom, 'caxis'));
    opt.eventrange   = str2num(getkeyval(lastcom, 9));
    opt.align        = str2num(getkeyval(lastcom, 'align'));
    opt.phasesort    = str2num(getkeyval(lastcom, 'phasesort'));
    opt.coher        = str2num(getkeyval(lastcom, 'coher'));
    opt.spec         = str2num(getkeyval(lastcom, 'spec'));
    opt.vert         = str2num(getkeyval(lastcom, 'vert'));
    opt.limits       = str2num(getkeyval(lastcom, 'limits'));
    opt.limits       = [ opt.limits NaN NaN NaN NaN NaN NaN NaN NaN NaN ]; opt.limits = opt.limits(1:9);
    opt.coher        = [ opt.coher NaN NaN NaN NaN NaN NaN NaN NaN NaN ];  opt.coher  = opt.coher(1:3);
    opt.phasesort    = [ opt.phasesort NaN NaN NaN NaN NaN NaN NaN NaN NaN ]; opt.phasesort = opt.phasesort(1:4);
    if isnan(opt.limits(1)), opt.limits(1:2) = 1000*[EEG.xmin EEG.xmax]; end;
    
	commandphase = [ 'if ~isempty(get(findobj(''parent'', gcbf, ''tag'', ''phase''),''string'')),' ...
					 '   if ~isempty(get(findobj(''parent'', gcbf, ''tag'', ''coher''),''string'')), ' ...
					 '      set(findobj(''parent'', gcbf, ''tag'', ''coher''), ''string'', get(findobj(''parent'', gcbf, ''tag'', ''phase''),''string''));' ...
					 'end; end;' ];
	commandcoher = [ 'if ~isempty(get(findobj(''parent'', gcbf, ''tag'', ''coher''),''string'')),' ...
					 '   if ~isempty(get(findobj(''parent'', gcbf, ''tag'', ''phase''),''string'')), ' ...
					 '      set(findobj(''parent'', gcbf, ''tag'', ''phase''), ''string'', get(findobj(''parent'', gcbf, ''tag'', ''coher''),''string''));' ...
					 'end; end;' ];
	
	commandfield = ['if isempty(EEG.event)' ...
				   '   errordlg2(''No events'');' ...
				   'else' ...
				   '   tmpfieldnames = fieldnames(EEG.event);' ...
				   '   [tmps,tmpv] = listdlg2(''PromptString'', ''Select fields'', ''SelectionMode'',''single'',''ListString'', tmpfieldnames);' ...
				   '   if tmpv' ...
				   '       set(findobj(''parent'', gcbf, ''tag'', ''field''), ''string'', tmpfieldnames{tmps});' ...
				   '   end;' ...
				   'end;' ...
                   'if isempty(get(findobj(''parent'', gcbf, ''tag'', ''type''), ''string'')),' ...
                   '   warndlg2(''Do not forget to select an event type in the next edit box'');' ...
                   'end;' ...
				   'clear tmps tmpv tmpfieldnames;' ];
	commandtype = [ 'if ~isfield(EEG.event, ''type'')' ...
				   '   errordlg2(''No type field'');' ...
				   'else' ...
                   '   tmpevent = EEG.event;' ...
                   '   if isnumeric(EEG.event(1).type),' ...
				   '        [tmps,tmpstr] = pop_chansel(unique([ tmpevent.type ]));' ...
				   '   else,' ...
                   '        [tmps,tmpstr] = pop_chansel(unique({ tmpevent.type }));' ...
                   '   end;' ...
				   '   if ~isempty(tmps)' ...
				   '       set(findobj(''parent'', gcbf, ''tag'', ''type''), ''string'', tmpstr);' ...
				   '   end;' ...
				   'end;' ...
                   'if isempty(get(findobj(''parent'', gcbf, ''tag'', ''field''), ''string'')),' ...
                   '   warndlg2(''Do not forget to select an event type in the previous edit box'');' ...
                   'end;' ...
				   'clear tmps tmpv tmpstr tmpevent tmpfieldnames;' ];
	
	geometry = { [1 1 1 1 1] [1 1 0.1 0.8 2.1] [1 1 1 1 1] [1 1 1 1 1] [1 1 1 1 1] [1] [1] [1 1 1 0.8 0.8 1.2] [1 1 1 0.8 0.8 1.2] [1] [1] ...
				 [1.6 1.7 1.2 1 .5] [1.6 1.7 1.2 1 .5] [1] [1] [1.5 1 1 1 1] [1.5 1 1 1 1] [1] [1] [1.5 1 1 2.2] [1.5 1 1 2.2]};
    uilist = { { 'style' 'text' 'String' 'Select Mode' 'fontweight', 'bold'}, ...
                          { 'style' 'popup' 'string' strvcat(names{:}) 'tag' 'params'  },{ },{ },{ },...
                           { 'Style', 'text', 'string', fastif(typeplot, 'Channel', 'Component(s)'), 'fontweight', 'bold'  } ...
			   { 'Style', 'edit', 'string', num2str(opt.index), 'tag', 'chan' } { } ...
			   { 'Style', 'text', 'string', 'Figure title', 'fontweight', 'bold'  } ...
			   { 'Style', 'edit', 'string', '', 'tag', 'title'  } ...
			   ...
			   { 'Style', 'text', 'string', 'Smoothing', 'fontweight', 'bold', 'tooltipstring', context('avewidth',vars,txt) } ...
			   { 'Style', 'edit', 'string', num2str(opt.smoothing), 'tag', 'smooth' } ...
			   { 'Style', 'checkbox', 'string', 'Plot scalp map', 'tooltipstring', 'plot a 2-d head map (vector) at upper left', ...
				 'value', opt.topo, 'tag', 'plotmap'  } { } { } ...
			   { 'Style', 'text', 'string', 'Downsampling', 'fontweight', 'bold', 'tooltipstring', context('decimate',vars,txt) } ...
			   { 'Style', 'edit', 'string', num2str(opt.downsampling), 'tag', 'decimate' } ...
			   { 'Style', 'checkbox', 'string', 'Plot ERM', 'tooltipstring', context('erm',vars,txt), 'value', fastif(strcmpi(opt.erm, 'on'), 1,0), 'tag', 'erm' } ...
			   { 'Style', 'text', 'string', fastif(typeplot, 'ERM limits (uV)','ERM limits'), 'tooltipstring', [ 'Plotting limits for ERM trace [min_uV max_uV]' 10 '{Default: ERM data limits}']  } ...
			   { 'Style', 'edit', 'string', fastif(~isnan(opt.limits(3)), num2str(opt.limits(3:4)), ''), 'tag', 'limerm'  } ...
			   { 'Style', 'text', 'string', 'Time limits (ms)', 'fontweight', 'bold', 'tooltipstring',  'Select time subset in ms' } ...
			   { 'Style', 'edit', 'string', fastif(~isnan(opt.limits(1)), num2str(opt.limits(1:2)), ''), 'tag', 'limtime' } ...
			   { 'Style', 'checkbox', 'string', 'Plot colorbar','tooltipstring', context('caxis',vars,txt), 'value', fastif(strcmpi(opt.cbar, 'on'), 1,0), 'tag', 'cbar' } ...
			   { 'Style', 'text', 'string', 'Color limits (see Help)','tooltipstring', context('caxis',vars,txt) } ...
			   { 'Style', 'edit', 'string', num2str(opt.caxis), 'tag', 'caxis' } ...
			   {} ...
			   { 'Style', 'text', 'string', 'Sort/align trials by epoch event values', 'fontweight', 'bold'} ...
			   { 'Style', 'pushbutton', 'string', 'Epoch-sorting field', 'callback', commandfield, ...
				 'tooltipstring', 'Epoch-sorting event field name (Ex: latency; default: no sorting):' } ...
			   { 'Style', 'pushbutton', 'string', 'Event type(s)', 'callback', commandtype, 'tooltipstring', ['Event type(s) subset (default: all):' 10 ...
                '(See ''/Edit/Edit event values'' for event types)']  } ...
			   { 'Style', 'text', 'string', 'Event time range', 'tooltipstring', [ 'Sorting event window [start, end] in milliseconds (default: whole epoch):' 10 ...
												  'events are only selected within this time window (can be usefull if several' 10 ...
												  'events of the same type are in the same epoch, or for selecting trials with given response time)']} ...
			   { 'Style', 'text', 'string', 'Rescale', 'tooltipstring', 'Rescale sorting variable to plot window (yes|no|a*x+b)(Ex:3*x+2):' } ...
			   { 'Style', 'text', 'string', 'Align', 'tooltipstring',  context('align',vars,txt) } ...
			   { 'Style', 'checkbox', 'string', 'Don''t sort by value', 'tooltipstring', context('nosort',vars,txt), 'value', fastif(strcmpi(opt.nosort, 'on'), 1,0), 'tag', 'nosort' } ...
			   { 'Style', 'edit', 'string', opt.fieldname, 'tag', 'field' } ...
			   { 'Style', 'edit', 'string', opt.type, 'tag', 'type' } ...
			   { 'Style', 'edit', 'string', num2str(opt.eventrange), 'tag', 'eventrange' } ...
			   { 'Style', 'edit', 'string', opt.renorm, 'tag', 'renorm' } ...
			   { 'Style', 'edit', 'string', num2str(opt.align),  'tag', 'align' } ...
			   { 'Style', 'checkbox', 'string', 'Don''t plot values', 'tooltipstring', context('noplot',vars,txt), 'value', fastif(strcmpi(opt.noplot, 'on'), 1,0), 'tag', 'noplot' } ...
			   {} ...
			   { 'Style', 'text', 'string', 'Sort trials by phase', 'fontweight', 'bold'} ...
			   { 'Style', 'text', 'string', 'Frequency (Hz | minHz maxHz)', 'tooltipstring', ['sort by phase at maximum-power frequency' 10 ...
               'in the data within the range [minHz,maxHz]' 10 '(overrides frequency specified in ''coher'' flag)']  } ...
			   { 'Style', 'text', 'string', 'Percent low-amp. trials to ignore', 'tooltipstring', ['percent of trials to reject for low' ...
			    'amplitude. Else,' 10 'if prct is in the range [-100,0] -> percent to reject for high amplitude'] } ...
			   { 'Style', 'text', 'string', 'Window center (ms)', 'tooltipstring', 'Center time of the n-cycle window'  } ...
			   { 'Style', 'text', 'string', 'Wavelet cycles', 'tooltipstring', 'cycles per wavelet window'  } {}...
			   { 'Style', 'edit', 'string', fastif(~isnan(opt.phasesort(3)),num2str(opt.phasesort(3:4)),'') 'tag', 'phase', 'callback', commandphase } ...
			   { 'Style', 'edit', 'string', fastif(~isnan(opt.phasesort(2)),num2str(opt.phasesort(2)),''), 'tag', 'phase2' } ...
			   { 'Style', 'edit', 'string', fastif(~isnan(opt.phasesort(1)),num2str(opt.phasesort(1)),''), 'tag', 'phase3' } ...
			   { 'Style', 'text', 'string', '        3'  } {}...
			   {} ...
			   { 'Style', 'text', 'string', 'Inter-trial coherence options', 'fontweight', 'bold'} ...
			   { 'Style', 'text', 'string', 'Frequency (Hz | minHz maxHz)', 'tooltipstring', [ '[freq] -> plot erm plus amp & coher at freq (Hz)' 10 ...
               '[minHz maxHz] -> find max in frequency range' 10 '(or at phase freq above, if specified)']} ...
			   { 'Style', 'text', 'string', 'Signif. level (<0.20)', 'tooltipstring', 'add coher. signif. level line at alpha (alpha range: (0,0.1])' } ...
			   { 'Style', 'text', 'string', 'Amplitude limits (dB)'  } ...
			   { 'Style', 'text', 'string', 'Coher limits (<=1)'  } ...
			   { 'Style', 'checkbox', 'string', 'Image amps', 'tooltipstring',  context('plotamps',vars,txt), 'value', fastif(strcmpi(opt.plotamps, 'on'), 1,0), 'tag', 'plotamps' } ...
			   { 'Style', 'edit', 'string', fastif(~isnan(opt.coher(1)), num2str(opt.coher(1:2)), ''), 'tag', 'coher', 'callback', commandcoher } ...
			   { 'Style', 'edit', 'string', fastif(~isnan(opt.coher(3)), num2str(opt.coher(3)),   ''), 'tag', 'coher2'  } ...
			   { 'Style', 'edit', 'string', fastif(~isnan(opt.limits(5)), num2str(opt.limits(5:6)), ''), 'tag', 'limamp' } ...
			   { 'Style', 'edit', 'string', fastif(~isnan(opt.limits(7)), num2str(opt.limits(7:8)), ''), 'tag', 'limcoher' } ...
               {'style', 'text', 'string', '   (Requires signif.)' } ... 
			   {} ...
			   { 'Style', 'text', 'string', 'Other options', 'fontweight', 'bold'} ...
			   { 'Style', 'text', 'string', 'Plot spectrum (minHz maxHz)','tooltipstring',  context('spec',vars,txt)} ...
			   { 'Style', 'text', 'string', 'Baseline ampl. (dB)', 'tooltipstring', 'Use it to fix baseline amplitude' } ...
			   { 'Style', 'text', 'string', 'Mark times (ms)','tooltipstring',  context('vert',vars,txt)} ...
			   { 'Style', 'text', 'string', 'More options (see >> help ermimageemd)' } ...
			   { 'Style', 'edit', 'string', num2str(opt.spec), 'tag', 'spec' } ...
			   { 'Style', 'edit', 'string', fastif(~isnan(opt.limits(9)), num2str(opt.limits(9)), ''), 'tag', 'limbaseamp' } ...
			   { 'Style', 'edit', 'string', num2str(opt.vert), 'tag', 'vert' } ...
			   { 'Style', 'edit', 'string', '', 'tag', 'others' } ...
			};
	
    [oldres a b res] = inputgui( geometry, uilist, 'pophelp(''pop_ermimageemd'');', ...
							 fastif( typeplot, 'Channel ERM image -- pop_ermimageemd()', 'Modes ERM image -- pop_ermimageemd()'));
        
            

	if isempty(oldres), return; end;


        if size(EEG.IMFs,1)==1
            data(1,:,:)=squeeze(EEG.IMFs(:,res.params+1,:,:));
          else
            data=squeeze(EEG.IMFs(:,res.params+1,:,:));
        end
            EEG.data=data;

	% first rows
	% ---------
	channel   	 = eval( [ '[' res.chan ']' ]);
	titleplot    = res.title;
	if isfield(res, 'projchan'), projchan = str2num(res.projchan); else, projchan = []; end;
    opt = [];
	if ~isempty(res.others)
        try,
            tmpcell = eval( [ '{' res.others '}' ] );
            opt = struct( tmpcell{:} );
        catch, error('Additional options ("More options") requires ''key'', ''val'' arguments');
        end;
	end;
	if ~typeplot & isempty(projchan)
        opt.yermlabel = '';
    else
        opt.yermlabel = '\muV' ;
	end;
	
	smooth       = eval(res.smooth);
    if res.plotmap
		if isfield(EEG.chanlocs, 'theta')
            if ~isfield(EEG, 'chaninfo'), EEG.chaninfo = []; end;
			
	
		end;
	end;
	
	decimate     = eval( res.decimate );
	if res.erm
		opt.erm = 'on';
	end;
	
	% finding limits
	% --------------
	limits(1:8)  = NaN;
	if ~isempty(res.limerm)
		limits(3:4) = eval( [ '[' res.limerm ']' ]); 
	end;
	if ~isempty(res.limtime) % time limits
		if ~strcmp(res.limtime, num2str(1000*[EEG.xmin EEG.xmax]))
			limits(1:2) = eval( [ '[' res.limtime ']' ]);
		end;
	end;
	if ~isempty(res.limamp)
		limits(5:6) = eval( [ '[' res.limamp ']' ]);
	end;
	if ~isempty(res.limcoher)
		limits(7:8) = eval( [ '[' res.limcoher ']' ]);
	end;
	if ~isempty(res.limbaseamp)
		limits(9) = eval( res.limbaseamp ); %bamp
	end;
	if ~all(isnan(limits))
        opt.limits = limits;
	end;
	
	% color limits
	% --------------
	if res.cbar
		opt.cbar = 'on';
	end;
	if res.caxis
		opt.caxis = str2num(res.caxis);
	end;
	
	% event rows
	% ----------
	if res.nosort
		opt.nosort = 'on';
	end;
	try, sortingeventfield = eval( res.field ); catch, sortingeventfield = res.field; end;
    if ~isempty(res.type)
       if strcmpi(res.type(1),'''')
            sortingtype = eval( [ '{' res.type '}' ] );
       else sortingtype = parsetxt( res.type );
       end;
    end
	sortingwin   = eval( [ '[' res.eventrange ']' ] );
	if ~isempty(res.field) & ~strcmp(res.renorm, 'no')
		opt.renorm = res.renorm;
	end;
	if ~isempty(res.align)
		opt.align = str2num(res.align);
	end;
	if res.noplot
		opt.noplot = 'on';
	end;

	% phase rows
	% ----------
	tmpphase = [];
	if ~isempty(res.phase)
		tmpphase = eval( [ '[ 0 0 ' res.phase ']' ]);
	end;
	if ~isempty(res.phase2)
		tmpphase(2) = eval( res.phase2 );
	end;
	if ~isempty(res.phase3)
		tmpphase(1) = eval( res.phase3 );
	end;
	if ~isempty(tmpphase)
		opt.phasesort = tmpphase;
	end;
	
	% coher row
	% ----------
	tmpcoher = [];
	if res.plotamps
		opt.plotamps = 'on';
	end;
	if ~isempty(res.coher)
		tmpcoher = eval( [ '[' res.coher ']' ]);
	end;
	if ~isempty(res.coher2)
		if length(tmpcoher) == 1
			tmpcoher(2) = tmpcoher(1);
		end;
		tmpcoher(3) = eval( res.coher2 );
	end;
	if ~isempty(tmpcoher)
		opt.coher = tmpcoher;
	end;

	% options row
	% ------------
	if ~isempty(res.spec)
		opt.spec = eval( [ '[' res.spec ']' ]);
	end;
	if ~isempty(res.vert)
		opt.vert = eval( [ '[' res.vert ']' ]);
	end;
	figure;
    options = '';
else
	options = '';
	if nargin < 4
		projchan = [];
	end;
	if nargin < 5
		titleplot = ' ';
	end;
	if nargin < 6
		smooth = 5;
	end;
	if nargin < 7
		decimate = 0;
	end;
	if nargin < 8
		sortingtype = [];
	end;
	if nargin < 9
		sortingwin = [];
	end;
	if nargin < 10
		sortingeventfield = [];
	end;
    %options = vararg2str(varargin); % NO BECAUSE OF THE CHANNEL LOCATION
    %                                  PROBLEM BELOW
	for i=1:length( varargin )
		if isstr( varargin{ i } )
			options = [ options ', ''' varargin{i} '''' ];
		else  
		  if ~iscell( varargin{ i } )
		      options = [ options ',' vararg2str({varargin{i}}) ];
		  else
		      options = [ options ', { [' num2str(varargin{ i }{1}') ']'' EEG.chanlocs EEG.chaninfo }' ];
		  end;    
		end;
	end;	
end;
try, icadefs; set(gcf, 'color', BACKCOLOR,'Name',['ermimageemd() '  strcat('Channel ',res.chan,',') char(names(res.params))  ]); catch,end;

% testing inputs
% --------------


% find sorting latencies
% ---------------------
typetxt = '';
if ~isempty(sortingeventfield)
    %events = eeg_getepochevent( EEG, sortingtype, sortingwin, sortingeventfield);
	events = sprintf('eeg_getepochevent( EEG, %s)', vararg2str({sortingtype, sortingwin, sortingeventfield}));
	
    % generate text for the command
    % -----------------------------
    for index = 1:length(sortingtype)
        if isstr(sortingtype{index})
            typetxt = [typetxt ' ''' sortingtype{index} '''' ];
        else
            typetxt = [typetxt ' ' num2str(sortingtype{index}) ];
        end;
    end;    
% $$$ 	% renormalize latencies if necessary
% $$$ 	% ----------------------------------
% $$$ 	switch lower(renorm)
% $$$ 	    case 'yes',
% $$$ 	         disp('Pop_ermimageemd warning: *** sorting variable renormalized ***');
% $$$ 	         events = (events-min(events)) / (max(events) - min(events)) * ...
% $$$ 	                        0.5 * (EEG.xmax*1000 - EEG.xmin*1000) + EEG.xmin*1000 + 0.4*(EEG.xmax*1000 - EEG.xmin*1000);
% $$$ 	    case 'no',;
% $$$ 	    otherwise,
% $$$ 	        locx = findstr('x', lower(renorm))
% $$$ 	        if length(locx) ~= 1, error('Pop_ermimageemd error: unrecognize renormalazing formula'); end;
% $$$ 	        eval( [ 'events =' renorm(1:locx-1) 'events' renorm(locx+1:end) ';'] );
% $$$ 	end;
else
	events = 'ones(1, EEG.trials)*EEG.xmax*1000';
    %events = ones(1, EEG.trials)*EEG.xmax*1000;
    sortingeventfield = '';
end;           

if typeplot == 1
	tmpsig = ['mean(EEG.data([' int2str(channel) '], :),1)'];
else
    % test if ICA was computed or if one has to compute on line
    % ---------------------------------------------------------
    tmpsig = [ 'eeg_getdatact(EEG, ''component'', [' int2str(channel) '])' ];
end;

% outputs
% -------
outstr = '';
if ~popup
    for io = 1:nargout, outstr = [outstr 'varargout{' int2str(io) '},' ]; end;
    if ~isempty(outstr), outstr = [ '[' outstr(1:end-1) '] =' ]; end;
end;

% plot the data and generate output command
% --------------------------------------------
if isempty( options )
    if isfield(opt, 'topo')
        tmptopo = opt.topo;
        opt = rmfield(opt, 'topo');
    else
        tmptopo = '';
    end;
    fields = fieldnames(opt);
    values = struct2cell(opt);
    params = { fields{:}; values{:} };
    options = [ ',' vararg2str( { params{:} } ) ];
    tmpind = find( options == '\' ); options(tmpind(1:2:end)) = [];
    if ~isempty(tmptopo), options = [ options ',''topo'',' tmptopo ]; end;
end;

% varargout{1} = sprintf('figure; pop_ermimageemd(%s,%d,%d,''%s'',%d,%d,{%s},[%s],''%s'',''%s''%s);', inputname(1), typeplot, channel, titleplot, smooth, decimate, typetxt, int2str(sortingwin), sortingeventfield, renorm, options);
popcom = sprintf('figure; pop_ermimageemd(%s,%d, [%s],[%s],''%s'',%d,%d,{%s},[%s],''%s'' %s);', inputname(1), typeplot, int2str(channel), int2str(projchan), titleplot, smooth, decimate, typetxt, int2str(sortingwin), sortingeventfield, options);

com = sprintf('%s ermimageemd( %s, %s, linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), ''%s'', %d, %d %s);', outstr, tmpsig, events, titleplot, smooth, decimate, options);
disp('Command executed by pop_ermimageemd:');
disp(' '); disp(com); disp(' ');
eval(com)

if popup
	varargout{1} = popcom; % [10 '% Call: ' com];
end;

return;

% get contextual help
% -------------------
function txt = context(var, allvars, alltext);
	loc = strmatch( var, allvars);
	if ~isempty(loc)
		txt= alltext{loc(1)};
	else
		disp([ 'warning: variable ''' var ''' not found']);
		txt = '';
	end;

