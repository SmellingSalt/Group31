% pop_spectopoemd() - Plot spectra of specified mode of channels .
%                  Show scalp maps of power at specified frequencies. 
%                  Calls spectopoemd(). 
% Usage:
%   >> pop_spectopoemd( EEG); % pops-up interactive window
%  OR
%   >> [spectopoemd_outputs] = pop_spectopoemd( EEG, timerange, ...
%                        process, 'key', 'val',...); % returns spectopoemd() outputs
%
% Graphic interface for EEG data ):
%   "Select Mode" -      [popup menu]  select the mode you want to plot.
%   "Epoch time range" - [edit box]  [min max] Epoch time range (in ms) to use 
%                      in computing the spectra (by default the whole epoch or data).
%                      Command line equivalent: 'timerange'
%   "Percent data to sample" - [edit box] Percentage of data to use in
%                      computing the spectra (low % speeds up the computation).
%                      spectopoemd() equivalent: 'percent'
%   "Frequencies to plot as scalp maps" - [edit box] Vector of 1-7 frequencies to 
%                      plot topoplot() scalp maps of power at all channels.
%                      spectopoemd() equivalent: 'freqs'
%   "Apply to EEG|ERM|BOTH" - [edit box] Plot spectra of the 'EEG', 'ERM' or of 'BOTH'.
%                      NOTE: This edit box does not appear for continuous data.
%                      Command line equivalent: 'process'
%   "Plotting frequency range" - [edit box] [min max] Frequency range (in Hz) to plot.
%                      spectopoemd() equivalent: 'freqrange'
%   "Spectral and scalp map options (see topoplot)" - [edit box] 'key','val','key',... 
%                      sequence of arguments passed to spectopoemd() for details of the 
%                      spectral decomposition or to topoplot() to adjust details of 
%                      the scalp maps. For details see  >> help topoplot
%
% 
% Inputs:
%   EEG         - Input EEGLAB dataset

%   timerange   - [min_ms max_ms] Epoch time range to use in computing the spectra
%                   {Default: whole input epochs}
%   process     - 'EEG'|ERM'|'BOTH' If processing data epochs, work on either the
%                   mean single-trial 'EEG' spectra, the spectrum of the trial-average 
%                   'ERM', or plot 'BOTH' the EEG and ERM spectra. {Default: 'EEG'}
%
% Optional inputs:
%   'key','val'  - Optional topoplot() and/or spectopoemd() plotting arguments 
%                  {Default, 'electrodes','off'}
%
% Outputs: As from spectopoemd(). When nargin<2, a query window pops-up 
%          to ask for additional arguments and NO outputs are returned.
%          Note: Only the outputs of the 'ERM' spectral analysis 
%          are returned when plotting 'BOTH' ERM and EEG spectra.
%
%   This code is written by Arnaud Delorme & Scott Makeig, CNL / Salk Institute, 10 March 2002 and modified by
%   Karema Al-Subari (Karema.Al-Subari@ur.de) and Saad Al-Baddai (Saad.Al-Baddai@ur.de).
% 
% Author: 
%
% See also: spectopoemd(), topoplotemd()

%
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

% 03-15-02 debugging -ad
% 03-16-02 add all topoplot options -ad
% 04-04-02 added outputs -ad & sm

function varargout = pop_spectopoemd( EEG, timerange, processflag, varargin);


dataflag = 1;
varargout{1} = '';
if nargin < 1
	help pop_spectopoemd;
	return;
end;	

if nargin < 2
	dataflag = 1;
end;
if nargin < 3
	processflag = 'EEG';
end;

if ~isfield( EEG,'IMFs' )
		errordlg2(strvcat('Error: no data to plot.'), 'Error'); return;
	end;

    
    
for i=2:size(EEG.IMFs,2)
    
    if EEG.trials > 1
        names{i-1}=strcat('ERM_',num2str(i-1)); % fil
        
    else
        names{i-1}=strcat('IMF_',num2str(i-1)); % fil
    end
end

emdchanlocs_present = 0;
if ~isempty(EEG.emdchanlocs)
    if isfield(EEG.emdchanlocs, 'theta')
        emdchanlocs_present = 1;
    end;
end;

if nargin < 3




	
		geometry = { [2 1] [2 1] [2 1] [2 1] [2 1] [2 1] [2 1]};

        scalp_freq = fastif(emdchanlocs_present, { '6 10 22' }, { '' 'enable' 'off' });
		promptstr    = { { 'style' 'text' 'String' 'Select Mode:'}, ...
                                                 { 'style' 'popup' 'string' strvcat(names{:}) 'tag' 'params'  }, ...
                                                 { 'style' 'text' 'string' 'Epoch time range to analyze [min_ms max_ms]:' }, ...
						 { 'style' 'edit' 'string' [num2str( EEG.xmin*1000) ' ' num2str(EEG.xmax*1000)] }, ...
						 { 'style' 'text' 'string' 'Percent data to sample (1 to 100):'}, ...
						 { 'style' 'edit' 'string' '15' }, ...
						 { 'style' 'text' 'string' 'Frequencies to plot as scalp maps (Hz):'}, ...
						 { 'style' 'edit' 'string'  scalp_freq{:} }, ...
						 { 'style' 'text' 'string' 'Apply to EEG|ERM|BOTH:'}, ...
						 { 'style' 'edit' 'string' 'EEG' }, ...
						 { 'style' 'text' 'string' 'Plotting frequency range [lo_Hz hi_Hz]:'}, ...
						 { 'style' 'edit' 'string' '2 25' }, ...
						 { 'style' 'text' 'string' 'Spectral and scalp map options (see topoplotemd):' } ...
						 { 'style' 'edit' 'string' '''electrodes'',''off''' } };
		if EEG.trials == 1
			geometry(5) = [];
			promptstr(9:10) = [];
		end;
		result       = inputgui( geometry, promptstr, 'pophelp(''pop_spectopoemd'')', 'Channel spectra and maps -- pop_spectopoemd()');
		if size(result,1) == 0 return; end;
		timerange    = eval( [ '[' result{2} ']' ] );
		options = [];
                
            if size(EEG.IMFs,1)==1
            data(1,:,:)=squeeze(EEG.IMFs(:,result{1}+1,:,:));
            else
            data=squeeze(EEG.IMFs(:,result{1}+1,:,:));
            end
            EEG.data=data;

        if isempty(EEG.emdchanlocs)
            disp('Topographic plot options ignored. First import a channel location file');  
            disp('To plot a single channel, use channel property menu or the following call');
            disp('  >> figure; chan = 1; spectopoemd(EEG.data(chan,:,:), EEG.pnts, EEG.srate);');
        end;
		if eval(result{3}) ~= 100, options = [ options ', ''percent'', '  result{3} ]; end;
		if ~isempty(result{4}) & ~isempty(EEG.emdchanlocs), options = [ options ', ''freq'', ['  result{4} ']' ]; end;
		if EEG.trials ~= 1
			processflag = result{5};
			if ~isempty(result{6}),    options = [ options ', ''freqrange'',[' result{6} ']' ]; end;
			if ~isempty(result{7}),    options = [ options ',' result{7} ]; end;
		else 
			if ~isempty(result{5}),    options = [ options ', ''freqrange'',[' result{5} ']' ]; end;
			if ~isempty(result{6}),    options = [ options ',' result{6} ]; end;
		end;
	
        
        stt = char(names(result{1}));
	    figure('tag', 'spectopoemd');
        set(gcf,'Name',['spectopoemd() Mode '  stt(5:end)   ]);
        
else
    if ~isempty(varargin)
        options = [',' vararg2str(varargin)];
    else
        options = '';
    end;
	if isempty(timerange)
		timerange = [ EEG.xmin*1000 EEG.xmax*1000 ];
	end;
	if nargin < 3 
		percent = 100;
	end;
	if nargin < 4 
		topofreqs = [];
	end;
end;

% set the background color of the figure
try, tmpopt = struct(varargin{:}); if ~isfield(tmpopt, 'plot') || strcmpi(tmpopt, 'on'), icadefs; set(gcf, 'color', BACKCOLOR); end; catch, end;

switch processflag,
 case {'EEG' 'eeg' 'ERM' 'erm' 'BOTH' 'both'},;
 otherwise, if nargin <3, close; end; 
  error('Pop_spectopoemd: processflag must be ''EEG'', ''ERM'' or ''BOTH''');
end;
if EEG.trials == 1 & ~strcmp(processflag,'EEG')
	 if nargin <3, close; end;
	 error('pop_spectopoemd(): must use ''EEG'' mode when processing continuous data');
end;

if ~isempty(EEG.emdchanlocs)
    if ~isfield(EEG, 'chaninfo'), EEG.chaninfo = []; end;

	spectopooptions = [ options ', ''verbose'', ''off'', ''emdchanlocs'', EEG.emdchanlocs, ''chaninfo'', EEG.chaninfo' ];
	
else
	spectopooptions = options;
end;


% The programming here is a bit redundant but it tries to optimize 
% memory usage.
% ----------------------------------------------------------------
if timerange(1)/1000~=EEG.xmin | timerange(2)/1000~=EEG.xmax
	posi = round( (timerange(1)/1000-EEG.xmin)*EEG.srate )+1;
	posf = min(round( (timerange(2)/1000-EEG.xmin)*EEG.srate )+1, EEG.pnts );
	pointrange = posi:posf;
	if posi == posf, error('pop_spectopoemd(): empty time range'); end;
	fprintf('pop_spectopoemd(): selecting time range %6.2f ms to %6.2f ms (points %d to %d)\n', ...
			timerange(1), timerange(2), posi, posf);
end;

if isempty(EEG.emdchansind) || dataflag == 1, chaninds = 1:EEG.emdnbchan;
else      chaninds = EEG.emdchansind;
end;

if exist('pointrange') == 1, SIGTMP = EEG.data(chaninds,pointrange,:); totsiz = length( pointrange);
else                         SIGTMP = EEG.data(chaninds,:,:); totsiz = EEG.pnts;
end;

% add boundaries if continuous data
% ----------------------------------
if EEG.trials == 1 & ~isempty(EEG.event) & isfield(EEG.event, 'type') & isstr(EEG.event(1).type)
	tmpevent = EEG.event;
    boundaries = strmatch('boundary', {tmpevent.type});
	if ~isempty(boundaries)
		if exist('pointrange')
			boundaries = [ tmpevent(boundaries).latency ] - 0.5-pointrange(1)+1;
			boundaries(find(boundaries>=pointrange(end)-pointrange(1))) = [];
			boundaries(find(boundaries<1)) = [];
			boundaries = [0 boundaries pointrange(end)-pointrange(1)];
		else
			boundaries = [0 [ tmpevent(boundaries).latency ]-0.5 EEG.pnts ];
		end;
		spectopooptions = [ spectopooptions ',''boundaries'',[' int2str(round(boundaries)) ']']; 
	end;		
	fprintf('Pop_spectopoemd: finding data discontinuities\n');
end;

% outputs
% -------
outstr = '';
if nargin >= 2
	for io = 1:nargout, outstr = [outstr 'varargout{' int2str(io) '},' ]; end;
	if ~isempty(outstr), outstr = [ '[' outstr(1:end-1) '] =' ]; end;
end;

% plot the data and generate output and history commands
% ------------------------------------------------------
popcom = sprintf('figure; pop_spectopoemd(%s, %d, [%s], ''%s'' %s);', inputname(1), dataflag, num2str(timerange), processflag, options);
switch processflag
	case { 'EEG' 'eeg' }, SIGTMP = reshape(SIGTMP, size(SIGTMP,1), size(SIGTMP,2)*size(SIGTMP,3));
	            com = sprintf('%s spectopoemd( SIGTMP, totsiz, EEG.srate %s);', outstr, spectopooptions); 
                eval(com)
				
    case { 'ERM' 'erm' }, com = sprintf('%s spectopoemd( mean(SIGTMP,3), totsiz, EEG.srate %s);', outstr, spectopooptions); eval(com)
	case { 'BOTH' 'both' }, sbplot(2,1,1); com = sprintf('%s spectopoemd( mean(SIGTMP,3), totsiz, EEG.srate, ''title'', ''ERM'' %s);', outstr, spectopooptions); eval(com)
       
	             SIGTMP = reshape(SIGTMP, size(SIGTMP,1), size(SIGTMP,2)*size(SIGTMP,3));
				 sbplot(2,1,2); com = sprintf('%s spectopoemd( SIGTMP, totsiz, EEG.srate, ''title'', ''EEG'' %s);', outstr, spectopooptions); eval(com)
end;

if nargout < 2 & nargin < 3
	varargout{1} = popcom;
end;

return;

		
