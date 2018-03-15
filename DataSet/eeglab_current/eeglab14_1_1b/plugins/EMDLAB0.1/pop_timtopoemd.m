% pop_timtopoemd() - call the timtopoemd() function for epoched EEG datasets. 
%                 Plots the epoch mean for a specific mode of each channel on a single axis,
%                 plus scalp maps of the data at specified latencies.
% Usage:
%   >> pop_timtopoemd( EEG, Mode,timerange, topotimes, title, 'key', 'val', ...);
%
% Inputs:
%   EEG         - input dataset
%   timerange   - [min max] epoch time range (in ms) to plot 
%   topotimes   - array of times to plot scalp maps {Default: NaN 
%                 = display scalp map at frame of max var()}
%
% Optional inputs:
%   title       - optional plot title
%   'key','val' - optional topoplot() arguments (see >> help topoplot)
%
%  This code is written by Arnaud Delorme, CNL / Salk Institute, 2001 and modified by
%  Karema Al-Subari (Karema.Al-Subari@ur.de) and Saad Al-Baddai (Saad.Al-Baddai@ur.de).
% 
%
% See also: timtopoemd()

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

% 01-25-02 reformated help & license -ad 
% 02-16-02 text interface editing -sm & ad 
% 03-15-02 add all topoplot options -ad
% 03-18-02 added title -ad & sm

function com = pop_timtopoemdemd( EEG,Mode, timerange, topotime, plottitle, varargin);



com = '';

if ~isfield( EEG,'IMFs' )
		errordlg2(strvcat('Error: no data to plot.'), 'Error'); return;
	end;



if nargin < 1
	help pop_timtopoemd;
	return;
end;	

for i=2:size(EEG.IMFs,2)
 names{i-1}=strcat('ERM_',num2str(i-1)); % fil
end

if nargin < 4


geometry = { [1 1] [1 1] [1 1] [1 1] [1 1]};

promptstr    = { { 'style' 'text' 'String' 'Select Mode:'}, ...
                       { 'style' 'popup' 'string' strvcat(names{:}) 'tag' 'params'  }, ...
                       { 'style' 'text' 'string' 'Plotting time range (ms):' }, ...
		       { 'style' 'edit' 'string' [num2str( EEG.xmin*1000) ' ' num2str(EEG.xmax*1000)] }, ...
		       { 'style' 'text' 'string' 'Scalp map latencies (ms, NaN -> max-RMS)'}, ...
		       { 'style' 'edit' 'string' 'NaN' },....
                       { 'style' 'text' 'string' 'Plot title:'}, ...
		       { 'style' 'edit' 'string' ['ERM data and scalp maps' fastif(~isempty(EEG.setname), [' of ' EEG.setname ], '') ] },...
                       { 'style' 'text' 'string' 'Scalp map options (see >> help topoplot):'}, ...
		       { 'style' 'edit' 'string' '' }};
		
   result = inputgui( geometry, promptstr, 'ERM data and scalp maps -- pop_timtopoemd()', 'ERM data and scalp maps -- pop_timtopoemd()');




%{

	promptstr    = { 'Plotting time range (ms):', ...
			         ['Scalp map latencies (ms, NaN -> max-RMS)'], ...
					 'Plot title:' ...
			         'Scalp map options (see >> help topoplot):' };
	inistr       = { [num2str( EEG.xmin*1000) ' ' num2str(EEG.xmax*1000)], ...
			         'NaN', ...
	                 ['ERP data and scalp maps' fastif(~isempty(EEG.setname), [' of ' EEG.setname ], '') ], ...
			         ''  };
	result       = inputdlg2( promptstr, 'ERP data and scalp maps -- pop_timtopoemd()', 1, inistr, 'pop_timtopoemd');
%}
	if size(result,1) == 0 return; end;
	Mode         = result{1};
	timerange    = eval( [ '[' result{2} ']' ] );
	topotime     = eval( [ '[' result{3} ']' ] );
	plottitle    = result{4};
	options      = [ ',' result{5} ];
	

else
	options = [];
	for i=1:length( varargin )
		if isstr( varargin{ i } )
			options = [ options ', ''' varargin{i} '''' ];
		else
			options = [ options ', [' num2str(varargin{i}) ']' ];
		end;
	end;	
end; 

 figure;
 if size(EEG.IMFs,1)==1
       data(1,:,:)=squeeze(EEG.IMFs(:,Mode+1,:,:));
  else
       data=squeeze(EEG.IMFs(:,Mode+1,:,:));
  end
       EEG.data=data;


try, icadefs; set(gcf, 'color', BACKCOLOR, 'Name', [' timtopoemd(),', strcat('ERM_',num2str(Mode)) ]); catch, end;

if exist('plottitle') ~= 1
    plottitle = ['ERP data and scalp maps' fastif(~isempty(EEG.setname), [' of ' EEG.setname ], '') ];
end;
    
if ~isempty(EEG.chanlocs)
    if ~isfield(EEG, 'chaninfo'), EEG.chaninfo = []; end;
	SIGTMP = reshape(EEG.data, size(EEG.data,1), EEG.pnts, EEG.trials);
	posi = round( (timerange(1)/1000-EEG.xmin)/(EEG.xmax-EEG.xmin) * (EEG.pnts-1))+1;
	posf = round( (timerange(2)/1000-EEG.xmin)/(EEG.xmax-EEG.xmin) * (EEG.pnts-1))+1;
	if length( options ) < 2
    	timtopoemd( mean(SIGTMP(:,posi:posf,:),3), EEG.emdchanlocs, [timerange(1) timerange(2) 0 0], topotime, '', 0, 0, 'chaninfo', EEG.chaninfo);
        com = sprintf('figure; pop_timtopoemd(%s, [%s], [%s], ''%s'');', inputname(1), num2str(timerange), num2str(topotime), plottitle);
	else
		com = sprintf('timtopoemd( mean(SIGTMP(:,posi:posf,:),3), EEG.chanlocs, [timerange(1) timerange(2) 0 0], topotime, '''', 0, 0, ''chaninfo'', EEG.chaninfo %s);', options);
		eval(com)
	    com = sprintf('figure; pop_timtopoemd(%s, [%s], [%s], ''%s'' %s);', inputname(1), num2str(timerange), num2str(topotime), plottitle, options);
	end;		
else
	fprintf('Cannot make plot without channel locations\n');
	return;
end;
return;

		
