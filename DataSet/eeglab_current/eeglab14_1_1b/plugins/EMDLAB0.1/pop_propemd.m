% pop_propemd() - plot the properties of a specific mode for a specific channel.
% Usage:
%   >> pop_propemd( EEG);           % pops up a query window 
%   >> pop_propemd( EEG, chan, Mode, winhandle,spectopo_options);
%
% Inputs:
%   EEG        - EEGLAB dataset structure (see EEGGLOBAL)
%
% Optional inputs:
%  
%   chan - channel number[s] to display {default: 1}
%   Mode - mode number[s] to display {default: 1}

%
%   winhandle  - if this parameter is present or non-NaN, buttons 
%                allowing the rejection of the component are drawn. 
%                If non-zero, this parameter is used to back-propagate
%                the color of the rejection button.
%   spectopo_options - [cell array] optional cell arry of options for 
%                the spectopoemd() function.
%
%  This code is written by Arnaud Delorme, CNL / Salk Institute, 2001 and modified by
%  Karema Al-Subari (Karema.Al-Subari@ur.de) and Saad Al-Baddai (Saad.Al-Baddai@ur.de).
% 
%

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

% hidden parameter winhandle

% 01-25-02 reformated help & license -ad 
% 02-17-02 removed event index option -ad
% 03-17-02 debugging -ad & sm
% 03-18-02 text settings -ad & sm
% 03-18-02 added title -ad & sm

function com = pop_propemd(EEG,typecomp, chan, Mode, winhandle, spec_opt)

typecomp = 1;

com = '';

if ~isfield( EEG,'IMFs' )
		errordlg2(strvcat('Error: no data to plot.'), 'Error'); return;
	end;

if nargin < 1
	help pop_propemd;
	return;   
end;
if nargin < 5
	spec_opt = {};
end;
if nargin == 1
	typecomp = 1;    % defaults
        chan = 1;
        Mode = 1;
end;


for i=2:size(EEG.IMFs,2)
    
    if EEG.trials > 1
        names{i-1}=strcat('ERM_',num2str(i-1)); % fil
        
    else
        names{i-1}=strcat('IMF_',num2str(i-1)); % fil
    end
end

if nargin == 1


geometry = { [1 1] [1 1] [1 1]};

promptstr    = { { 'style' 'text' 'String' 'Select Mode:'}, ...
                                                 { 'style' 'popup' 'string' strvcat(names{:}) 'tag' 'params'  }, ...
                                                 { 'style' 'text' 'string' 'Channel index(ices) to plot:' }, ...
						 { 'style' 'edit' 'string' '1' }, ...
						 { 'style' 'text' 'string' 'Spectral options (see spectopoemd() help):'}, ...
						 { 'style' 'edit' 'string' '''freqrange'', [2 50]' }};
		
		result       = inputgui( geometry, promptstr, 'Modes properties - pop_propemd()', 'Modes properties - pop_propemd');
                if size( result, 1 ) == 0 return; end;

                Mode         = (result{1});
                chan         = eval( [ '[' result{2} ']' ] );
                spec_opt     = eval( [ '{' result{3} '}' ] );
         
             
                


	%5promptstr    = { 
                      
          %            fastif(typecomp,'Channel index(ices) to plot:','Component index(ices) to plot:') ...
            %         'Spectral options (see spectopoemd() help):' };
	%inistr       = { '1' '''freqrange'', [2 50]' };
	%result       = inputdlg2( promptstr, 'Modes properties - pop_propemd()', 1,  inistr, 'pop_propemd');
	%if size( result, 1 ) == 0 return; end;
   
	%chan   = eval( [ '[' result{1} ']' ] );
        %spec_opt     = eval( [ '{' result{2} '}' ] );


end;


                
   if size(EEG.IMFs,1)==1
            data(1,:,:)=squeeze(EEG.IMFs(:,Mode+1,:,:));

          else
            data=squeeze(EEG.IMFs(:,Mode+1,:,:));
    end
            EEG.data=data;              
  
%{ 'style' 'text' 'String' 'Select Mode:'}, ...
 %                        { 'style' 'popup' 'string' strvcat(names{:}) 'tag' 'params'  }, ...

% plotting several component properties
% -------------------------------------
if length(chan) > 1
    for index = chan
        pop_propemd(EEG,typecomp, index,Mode, 0, spec_opt);  % call recursively for each chan
    end;
	com = sprintf('pop_propemd( %s, %d, [%s], NaN, %s);', inputname(1), ...
                  int2str(chan), vararg2str( { spec_opt } ));
    return;
end;

if chan < 1 | chan > EEG.nbchan % should test for > number of components ??? -sm
   error('Component index out of range');
end;   



% assumed input is chan
% -------------------------
try, icadefs; 
catch, 
	BACKCOLOR = [0.8 0.8 0.8];
	GUIBUTTONCOLOR   = [0.8 0.8 0.8]; 
end;
basename = [fastif(typecomp,'Channel ', 'Component ') int2str(chan) ]; 

fh = figure('name', ['pop_propemd() - ' basename  ' Mode '   int2str(Mode) ' properties'], 'color', BACKCOLOR, 'numbertitle', 'off', 'visible', 'off');
pos = get(gcf,'Position');
set(gcf,'Position', [pos(1) pos(2)-500+pos(4) 500 500], 'visible', 'on');
pos = get(gca,'position'); % plot relative to current axes
hh = gca;
q = [pos(1) pos(2) 0 0];
s = [pos(3) pos(4) pos(3) pos(4)]./100;
axis off;

% plotting topoplot
% -----------------
h = axes('Units','Normalized', 'Position',[-10 60 40 42].*s+q);

%topoplot( EEG.icawinv(:,chan), EEG.chanlocs); axis square; 

if isfield(EEG.chanlocs, 'theta')
    
        topoplot( chan, EEG.chanlocs, 'chaninfo', EEG.chaninfo, ...
                 'electrodes','off', 'style', 'blank', 'emarkersize1chan', 12); axis square;
   
else
    axis off;
end;
basename = [fastif(typecomp,'Channel ', 'IC') int2str(chan) ];
% title([ basename fastif(typecomp, ' location', ' map')], 'fontsize', 14); 
title(basename, 'fontsize', 14); 

% plotting ermimageemd
% -----------------
hhh = axes('Units','Normalized', 'Position',[45 62 48 38].*s+q);
eeglab_options; 
if EEG.trials > 1
    % put title at top of ermimageemd
    axis off
    hh = axes('Units','Normalized', 'Position',[45 62 48 38].*s+q);
    EEG.times = linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts);
    if EEG.trials < 6
      ei_smooth = 1;
    else
      ei_smooth = 3;
    end
     % plot channel
         offset = nan_mean(EEG.data(chan,:));         
         erm=nan_mean(squeeze(EEG.data(chan,:,:))')-offset;
         erm_limits=get_era_limits(erm);
         ermimageemd( EEG.data(chan,:)-offset, ones(1,EEG.trials)*10000, EEG.times , ...
                       '', ei_smooth, 1, 'caxis', 2/3, 'cbar','erm','erm_vltg_ticks',erm_limits);   
   
    
    axes(hhh);
    title(sprintf('%s activity \\fontsize{10}(global offset %3.3f)', basename, offset), 'fontsize', 14);

   


else
    % put title at top of ermimageemd
    EI_TITLE = 'Continous data';
    axis off
    hh = axes('Units','Normalized', 'Position',[45 62 48 38].*s+q);
    ERMIMAGELINES = 200; % show 200-line ermimageemd
    while size(EEG.data,2) < ERMIMAGELINES*EEG.srate
       ERMIMAGELINES = 0.9 * ERMIMAGELINES;
    end
    if ERMIMAGELINES > 2   % give up if data too small
        if ERMIMAGELINES < 10
            ei_smooth = 1;
        else
            ei_smooth = 3;
        end
      ermimageframes = floor(size(EEG.data,2)/ERMIMAGELINES);
      ermimageframestot = ermimageframes*ERMIMAGELINES;
      eegtimes = linspace(0, ermimageframes-1, EEG.srate/1000);
      % plot channel
           offset = nan_mean(EEG.data(chan,:));
           % Note: we don't need to worry about ERM limits, since ERMs
           % aren't visualized for continuous data
           ermimageemd( reshape(EEG.data(chan,1:ermimageframestot),ermimageframes,ERMIMAGELINES)-offset, ones(1,ERMIMAGELINES)*10000, eegtimes , ...
                         EI_TITLE, ei_smooth, 1, 'caxis', 2/3, 'cbar');  
      
    else
            axis off;
            text(0.1, 0.3, [ 'No ermimageemd plotted' 10 'for small continuous data']);
    end;
    axes(hhh);
end;	





% plotting spectrum
% -----------------
if ~exist('winhandle')
    winhandle = NaN;
end;
if ~isnan(winhandle)
	h = axes('units','normalized', 'position',[5 10 95 35].*s+q);
else
	h = axes('units','normalized', 'position',[5 0 95 40].*s+q);
end;
%h = axes('units','normalized', 'position',[45 5 60 40].*s+q);
try
	eeglab_options; 
	
		[spectra freqs] = spectopoemd( EEG.data(chan,:), EEG.pnts, EEG.srate, spec_opt{:} );
	
    % set up new limits
    % -----------------
    %freqslim = 50;
	%set(gca, 'xlim', [0 min(freqslim, EEG.srate/2)]);
    %spectra = spectra(find(freqs <= freqslim));
	%set(gca, 'ylim', [min(spectra) max(spectra)]);
    
	%tmpy = get(gca, 'ylim');
    %set(gca, 'ylim', [max(tmpy(1),-1) tmpy(2)]);
	set( get(gca, 'ylabel'), 'string', 'Power 10*log_{10}(\muV^{2}/Hz)', 'fontsize', 14); 
	set( get(gca, 'xlabel'), 'string', 'Frequency (Hz)', 'fontsize', 14); 
	title('Activity power spectrum', 'fontsize', 14); 
catch
	axis off;
    lasterror
	text(0.1, 0.3, [ 'Error: no spectrum plotted' 10 ' make sure you have the ' 10 'signal processing toolbox']);
end;	
	
% display buttons
% ---------------
if ~isnan(winhandle)
	COLREJ = '[1 0.6 0.6]';
	COLACC = '[0.75 1 0.75]';
	% CANCEL button
	% -------------
	h  = uicontrol(gcf, 'Style', 'pushbutton', 'backgroundcolor', GUIBUTTONCOLOR, 'string', 'Cancel', 'Units','Normalized','Position',[-10 -10 15 6].*s+q, 'callback', 'close(gcf);');

	% VALUE button
	% -------------
	hval  = uicontrol(gcf, 'Style', 'pushbutton', 'backgroundcolor', GUIBUTTONCOLOR, 'string', 'Values', 'Units','Normalized', 'Position', [15 -10 15 6].*s+q);

	% REJECT button
	% -------------
    if ~isempty(EEG.reject.gcompreject)
    	status = EEG.reject.gcompreject(chan);
    else
        status = 0;
    end;
	hr = uicontrol(gcf, 'Style', 'pushbutton', 'backgroundcolor', eval(fastif(status,COLREJ,COLACC)), ...
				'string', fastif(status, 'REJECT', 'ACCEPT'), 'Units','Normalized', 'Position', [40 -10 15 6].*s+q, 'userdata', status, 'tag', 'rejstatus');
	command = [ 'set(gcbo, ''userdata'', ~get(gcbo, ''userdata''));' ...
				'if get(gcbo, ''userdata''),' ...
				'     set( gcbo, ''backgroundcolor'',' COLREJ ', ''string'', ''REJECT'');' ...
				'else ' ...
				'     set( gcbo, ''backgroundcolor'',' COLACC ', ''string'', ''ACCEPT'');' ...
				'end;' ];					
	set( hr, 'callback', command); 

	% HELP button
	% -------------
	h  = uicontrol(gcf, 'Style', 'pushbutton', 'backgroundcolor', GUIBUTTONCOLOR, 'string', 'HELP', 'Units','Normalized', 'Position', [65 -10 15 6].*s+q, 'callback', 'pophelp(''pop_propemd'');');

	% OK button
	% ---------
 	command = [ 'global EEG;' ...
 				'tmpstatus = get( findobj(''parent'', gcbf, ''tag'', ''rejstatus''), ''userdata'');' ...
 				'EEG.reject.gcompreject(' num2str(chan) ') = tmpstatus;' ]; 
	if winhandle ~= 0
	 	command = [ command ...
	 				sprintf('if tmpstatus set(%3.15f, ''backgroundcolor'', %s); else set(%3.15f, ''backgroundcolor'', %s); end;', ...
					winhandle, COLREJ, winhandle, COLACC)];
	end;				
	command = [ command 'close(gcf); clear tmpstatus' ];
	h  = uicontrol(gcf, 'Style', 'pushbutton', 'string', 'OK', 'backgroundcolor', GUIBUTTONCOLOR, 'Units','Normalized', 'Position',[90 -10 15 6].*s+q, 'callback', command);

	% draw the figure for statistical values
	% --------------------------------------
	index = num2str( chan );
	command = [ ...
		'figure(''MenuBar'', ''none'', ''name'', ''Statistics of the component'', ''numbertitle'', ''off'');' ...
		'' ...
		'pos = get(gcf,''Position'');' ...
		'set(gcf,''Position'', [pos(1) pos(2) 340 340]);' ...
		'pos = get(gca,''position'');' ...
		'q = [pos(1) pos(2) 0 0];' ...
		's = [pos(3) pos(4) pos(3) pos(4)]./100;' ...
		'axis off;' ...
		''  ...
		'txt1 = sprintf(''(\n' ...
						'Entropy of component activity\t\t%2.2f\n' ...
					    '> Rejection threshold \t\t%2.2f\n\n' ...
					    ' AND                 \t\t\t----\n\n' ...
					    'Kurtosis of component activity\t\t%2.2f\n' ...
					    '> Rejection threshold \t\t%2.2f\n\n' ...
					    ') OR                  \t\t\t----\n\n' ...
					    'Kurtosis distibution \t\t\t%2.2f\n' ...
					    '> Rejection threhold\t\t\t%2.2f\n\n' ...
					    '\n' ...
					    'Current thesholds sujest to %s the component\n\n' ...
					    '(after manually accepting/rejecting the component, you may recalibrate thresholds for future automatic rejection on other datasets)'',' ...
						'EEG.stats.compenta(' index '), EEG.reject.threshentropy, EEG.stats.compkurta(' index '), ' ...
						'EEG.reject.threshkurtact, EEG.stats.compkurtdist(' index '), EEG.reject.threshkurtdist, fastif(EEG.reject.gcompreject(' index '), ''REJECT'', ''ACCEPT''));' ...
		'' ...				
		'uicontrol(gcf, ''Units'',''Normalized'', ''Position'',[-11 4 117 100].*s+q, ''Style'', ''frame'' );' ...
		'uicontrol(gcf, ''Units'',''Normalized'', ''Position'',[-5 5 100 95].*s+q, ''String'', txt1, ''Style'',''text'', ''HorizontalAlignment'', ''left'' );' ...
		'h = uicontrol(gcf, ''Style'', ''pushbutton'', ''string'', ''Close'', ''Units'',''Normalized'', ''Position'', [35 -10 25 10].*s+q, ''callback'', ''close(gcf);'');' ...
		'clear txt1 q s h pos;' ];
	set( hval, 'callback', command); 
	if isempty( EEG.stats.compenta )
		set(hval, 'enable', 'off');
	end;
	
	com = sprintf('pop_propemd( %s, %d, %d, 0, %s);', inputname(1), typecomp, chan, vararg2str( { spec_opt } ) );
else
	com = sprintf('pop_propemd( %s, %d, %d, NaN, %s);', inputname(1), typecomp, chan, vararg2str( { spec_opt } ) );
end;

return;

function out = nan_mean(in)

    nans = find(isnan(in));
    in(nans) = 0;
    sums = sum(in);
    nonnans = ones(size(in));
    nonnans(nans) = 0;
    nonnans = sum(nonnans);
    nononnans = find(nonnans==0);
    nonnans(nononnans) = 1;
    out = sum(in)./nonnans;
    out(nononnans) = NaN;

    
function era_limits=get_era_limits(era)
%function era_limits=get_era_limits(era)
%
% Returns the minimum and maximum value of an event-related
% activation/potential waveform (after rounding according to the order of
% magnitude of the ERA/ERM)
%
% Inputs:
% era - [vector] Event related activation or potential
%
% Output:
% era_limits - [min max] minimum and maximum value of an event-related
% activation/potential waveform (after rounding according to the order of
% magnitude of the ERA/ERM)

mn=min(era);
mx=max(era);
mn=orderofmag(mn)*round(mn/orderofmag(mn));
mx=orderofmag(mx)*round(mx/orderofmag(mx));
era_limits=[mn mx];


function ord=orderofmag(val)
%function ord=orderofmag(val)
%
% Returns the order of magnitude of the value of 'val' in multiples of 10
% (e.g., 10^-1, 10^0, 10^1, 10^2, etc ...)
% used for computing ermimageemd trial axis tick labels as an alternative for
% plotting sorting variable

val=abs(val);
if val>=1
    ord=1;
    val=floor(val/10);
    while val>=1,
        ord=ord*10;
        val=floor(val/10);
    end
    return;
else
    ord=1/10;
    val=val*10;
    while val<1,
        ord=ord/10;
        val=val*10;
    end
    return;
end

