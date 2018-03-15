% pop_plottopoemd() - plot a specific mode of one or more concatenated multichannel data epochs 
%                  in a topographic array format using plottopoemd()
% Usage:
%   >> pop_plottopoemd( EEG ); % pop-up
%   >> pop_plottopoemd( EEG, channels );
%   >> pop_plottopoemd( EEG, channels, title, singletrials);
%   >> pop_plottopoemd( EEG, channels, title, singletrials, axsize, ...
%                         'color', ydir, vert);
%
% Inputs:
%   EEG          - input dataset
%   channels     - indices of channels to plot
%   title        - plot title. Default is none.
%   singletrials - [0|1], 0 plot average, 1 plot individual
%                  single trials. Default is 0.
%   others...    - additional plottopoemd arguments {'axsize', 'color', 'ydir'
%                  'vert'} (see >> help plottopoemd)
%
%  This code is written by Arnaud Delorme, CNL / Salk Institute, 10 March 2002 and modified by
%  Karema Al-Subari (Karema.Al-Subari@ur.de) and Saad Al-Baddai (Saad.Al-Baddai@ur.de).
%
% See also: plottopoemd()

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
% 03-18-02 added title -ad & sm
% 03-30-02 added single trial capacities -ad

function com = pop_plottopoemd( EEG, Mode, channels, plottitle, singletrials, varargin);





com = '';
if nargin < 1
	help pop_plottopoemd;
	return;
end;	

if isempty(EEG.chanlocs)
	fprintf('Cannot plot without knowing channel locations. Use Edit/Dataset info\n');
	return;
end;

if ~isfield( EEG,'IMFs' )
		errordlg2(strvcat('Error: no data to plot.'), 'Error'); return;
	end;


for i=2:size(EEG.IMFs,2)
 names{i-1}=strcat('ERM_',num2str(i-1)); % fil
end

if nargin < 4
	uilist    = { { 'style' 'text' 'String' 'Select Mode:'}, ...
                  { 'style' 'popup' 'string' strvcat(names{:}) 'tag' 'params'  }, ...
                  { 'style' 'text' 'string' 'Channels to plot' } ...
                  { 'style' 'edit' 'string' [ '1:' num2str(size( EEG.IMFs,1) ) ] 'tag' 'chan' } ...
                  { 'style' 'text' 'string' 'Plot title' } ...
                  { 'style' 'edit' 'string' fastif(isempty(EEG.setname), '',EEG.setname)  'tag' 'title' } ...                  
                  { 'style' 'text' 'string' 'Plot single trials' } ...
                  { 'style' 'checkbox' 'string' '(set=yes)' 'tag' 'cbst' } ...
                  { 'style' 'text' 'string' 'Plot in rect. array' } ...
                  { 'style' 'checkbox' 'string' '(set=yes)' 'tag' 'cbra' } ...
                  { 'style' 'text' 'string' 'Other plot options (see help)' } ...
                  { 'style' 'edit' 'string' '''ydir'', 1' 'tag' 'opt' } };
    geometry = { [1 1] [1 1] [1 1] [1 1] [1 1] [1 1] };
    [result userdata tmphalt restag ] = inputgui( 'uilist', uilist, 'geometry', geometry, 'helpcom', 'pophelp(''pop_plottopoemd'')', 'title', 'Topographic ERM plot - pop_plottopoemd()');
	if length(result) == 0 return; end;
    
        Mode         = result{1};
	channels     = eval( [ '[' restag.chan ']' ] );
	plottitle    = restag.title;
	singletrials = restag.cbst;
        addoptions   = eval( [ '{' restag.opt '}' ] );
        rect         = restag.cbra;
       
              
    figure('name', [' plottopoemd()  ', strcat('ERM_ ',num2str(Mode))]);
    options ={ 'frames' EEG.pnts 'limits' [EEG.xmin EEG.xmax 0 0]*1000 ...
               'title' plottitle 'chans' channels addoptions{:} };
    if ~rect
        options = { options{:} 'chanlocs' EEG.chanlocs };
    end;
else 
	options ={ 'chanlocs' EEG.chanlocs 'frames' EEG.pnts 'limits' [EEG.xmin EEG.xmax 0 0]*1000 ...
               'title' plottitle 'chans' channels varargin{:}};
    addoptions = {};
end;

 if size(EEG.IMFs,1)==1
            data(1,:,:)=squeeze(EEG.IMFs(:,Mode+1,:,:));
            else
            data=squeeze(EEG.IMFs(:,Mode+1,:,:));
           end
            EEG.data=data;

try, icadefs; set(gcf, 'color', BACKCOLOR); catch, end;
	
if exist('plottitle') ~= 1
    plottitle = '';
end;    
if exist('singletrials') ~= 1
    singletrials = 0;
end;    

if singletrials 
    plottopoemd( EEG.data, options{:} );
else
   plottopoemd( mean(EEG.data,3), options{:} );
end;

if ~isempty(addoptions)
	com = sprintf('figure; pop_plottopoemd(%s, %s, ''%s'', %d, %s);', ...
				  inputname(1), vararg2str(channels), plottitle, singletrials, vararg2str(addoptions));
else
	com = sprintf('figure; pop_plottopoemd(%s, %s, ''%s'', %d);', ...
				  inputname(1), vararg2str(channels), plottitle, singletrials);
end;

return;
	
		
