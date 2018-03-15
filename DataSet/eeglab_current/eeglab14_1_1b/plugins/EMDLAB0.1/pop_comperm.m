% pop_comperm() - Compute the grand average waveforms of a specific mode  (ERM) of multiple datasets
%                 currently loaded into EEGLAB, with optional ERM difference-wave 
%                 plotting and t-tests. Creates a plotting figure.
% Usage:
%       >> pop_comperm( ALLEEG, Mode );  % pop-up window, interactive mode
%       >> [erm1 erm2 ermsub time sig] = pop_comperm( ALLEEG,Mode, ...
%                                         datadd,datsub, 'key', 'val', ...);
% Inputs:
%   ALLEEG  - Array of loaded EEGLAB EEG structure datasets
%   Mode    - mode number which you want to compare {default: 1}
%   datadd  - [integer array] List of ALLEEG dataset indices to average to make 
%             an ERM grand average and optionally to compare with 'datsub' datasets.
% Optional inputs:
%   datsub  - [integer array] List of ALLEEG dataset indices to average and then 
%             subtract from the 'datadd' result to make an ERM grand mean difference. 
%             Together, 'datadd' and 'datsub' may be used to plot and compare grand mean 
%             responses across subjects or conditions. Both arrays must contain the same 
%             number of dataset indices and entries must be matched pairwise (Ex:
%             'datadd' indexes condition A datasets from subjects 1:n, and 'datsub',
%             condition B datasets from the same subjects 1:n). {default: []}
%   'alpha'    - [0 < float < 1] Apply two-tailed t-tests for p < alpha. If 'datsub' is
%                not empty, perform t-tests at each latency. If 'datasub' is empty, 
%                perform two-tailed t-tests against a 0 mean dataset with same variance. 
%                Significant time regions are highlighted in the plotted data. 
%   'chans'    - [integer array] Vector of chans. or comps. to use {default: all}
%   'geom'     - ['scalp'|'array'] Plot erms in a scalp array (plottopo())
%                or as a rectangular array (plotdata()). Note: Only channels
%                (see 'chans' above) can be plotted in a 'scalp' array.
%   'tlim'     - [min max] Time window (ms) to plot data {default: whole time range}
%   'title'    - [string] Plot title {default: none}
%   'ylim'     - [min max] y-axis limits {default: auto from data limits}
%   'mode'     - ['ave'|'rms'] Plotting mode. Plot  either grand average or RMS 
%                (root mean square) time course(s) {default: 'ave' -> grand average}.
%   'std'      - ['on'|'off'|'none'] 'on' -> plot std. devs.; 'none' -> do not 
%                interact with other options {default:'none'}
%
% Vizualisation options:
%   'addavg'   - ['on'|'off'] Plot grand average (or RMS) of 'datadd' datasets
%                {default: 'on' if 'datsub' empty, otherwise 'off'}
%   'subavg'   - ['on'|'off'] Plot grand average (or RMS) of 'datsub' datasets 
%                {default:'off'}
%   'diffavg'  - ['on'|'off'] Plot grand average (or RMS) difference 
%   'addall'   - ['on'|'off'] Plot the ERMs for all 'dataadd' datasets only {default:'off'}
%   'suball'   - ['on'|'off'] Plot the ERMs for all 'datasub datasets only {default:'off'}
%   'diffall'  - ['on'|'off'] Plot all the 'datadd'-'datsub' ERM differences {default:'off'}
%   'addstd'   - ['on'|'off'] Plot std. dev. for 'datadd' datasets only 
%                {default: 'on' if 'datsub' empty, otherwise 'off'}
%   'substd'   - ['on'|'off'] Plot std. dev. of 'datsub' datasets only {default:'off'}
%   'diffstd'  - ['on'|'off'] Plot std. dev. of 'datadd'-'datsub' differences {default:'on'}
%   'diffonly' - ['on'|'off'|'none'] 'on' -> plot difference only; 'none' -> do not affect 
%                other options {default:'none'}
%   'allerms'  - ['on'|'off'|'none'] 'on' -> show ERMs for all conditions; 
%                'none' -> do not affect other options {default:'none'}
%   'tplotopt' - [cell array] Pass 'key', val' plotting options to plottopoemd()
%
% Output:
%   erm1   - Grand average (or rms) of the 'datadd' datasets
%   erm2   - Grand average (or rms) of the 'datsub' datasets
%   ermsub - Grand average (or rms) 'datadd' minus 'datsub' difference
%   times  - Vector of epoch time indices
%   sig    - T-test significance values (chans,times). 
%
%  This code is written by Arnaud Delorme, CNL / Salk Institute, 2003 and modified by
%  Karema Al-Subari (Karema.Al-Subari@ur.de) and Saad Al-Baddai (Saad.Al-Baddai@ur.de).
% 
%
% Note: t-test functions were adapted for matrix preprocessing from C functions 
%       by Press et al. See the description in the pttest() code below 
%       for more information.
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

function [erm1, erm2, ermsub, times, pvalues,ALL] = pop_comperm( ALLEEG, Mode, datadd, datsub, varargin);



if nargin < 1
   help pop_comperm;
   return;
end;


erm1 = '';
flag = 1;

if isempty(ALLEEG)
    error('pop_comperm: cannot process empty sets of data');
end;

if nargin < 2
   Mode=1;
end;

allcolors = { 'b' 'r' 'g' 'c' 'm' 'r' 'b' 'g' 'c' 'm' 'r' 'b' 'g' 'c' 'm' 'r' 'b' ...
              'g' 'c' 'm' 'r' 'b' 'g' 'c' 'm' 'r' 'b' 'g' 'c' 'm' 'r' 'b' 'g' 'c' 'm'};
erm1 = '';
if nargin < 3

   EEG= evalin('base','EEG');  
   for i=2:size(EEG.IMFs,2)
     namesERM{i-1}=strcat('ERM_',num2str(i-1)); % fil
   end

    gtmp = [1.1 0.8 .21 .21 .21 0.1]; gtmp2 = [1.48 1.03 1];
    uigeom = { [1 0.42 1 0.95] gtmp gtmp gtmp [1] gtmp2 gtmp2 [1.48 0.25 1.75] gtmp2 gtmp2 };
    commulcomp= ['if get(gcbo, ''value''),' ...
                 '    set(findobj(gcbf, ''tag'', ''multcomp''), ''enable'', ''on'');' ...
                 'else,' ...
                 '    set(findobj(gcbf, ''tag'', ''multcomp''), ''enable'', ''off'');' ...
                 'end;'];
	uilist = { { 'style' 'text' 'String' 'Select Mode:'}, {},...
               { 'style' 'popup' 'string' strvcat(namesERM{:}) 'tag' 'params'  }, ...
               { 'style' 'text' 'string' 'avg.        std.      all ERMs' } ...
               { 'style' 'text' 'string' 'Datasets to average (ex: 1 3 4):' } ...
               { 'style' 'edit' 'string' '' } ...
               { 'style' 'checkbox' 'string' '' 'value' 1 } ...
               { 'style' 'checkbox' 'string' '' } ...
               { 'style' 'checkbox' 'string' '' } { } ...
	           { 'style' 'text' 'string' 'Datasets to average and subtract (ex: 5 6 7):' } ...
               { 'style' 'edit' 'string' '' } ...
               { 'style' 'checkbox' 'string' '' 'value' 1 } ...
               { 'style' 'checkbox' 'string' '' } ...
               { 'style' 'checkbox' 'string' '' } { } ...
	           { 'style' 'text' 'string' 'Plot difference' } { } ...
               { 'style' 'checkbox' 'string' '' 'value' 1 } ...
               { 'style' 'checkbox' 'string' '' } ...
               { 'style' 'checkbox' 'string' '' } { } ...
               { } ...
	           { 'style' 'text' 'string' fastif(flag, 'Channels subset ([]=all):', ...
                                                  'Components subset ([]=all):') } ...
               { 'style' 'edit' 'string' '' } { } ...
	           { 'style' 'text' 'string' 'Highlight significant regions (.01 -> p=.01)' } ...
               { 'style' 'edit' 'string' '' } { } ...
	           { 'style' 'text' 'string' 'Use RMS instead of average (check):' } { 'style' 'checkbox' 'string' '' } { } ...
	           { 'style' 'text' 'string' 'Low pass (Hz) (for display only)' } ...
               { 'style' 'edit' 'string' '' } { } ...
               { 'style' 'text' 'string' 'Plottopo options (''key'', ''val''):' } ...
               { 'style' 'edit' 'string' '''ydir'', -1' } ...
               { 'style' 'pushbutton' 'string' 'Help' 'callback', 'pophelp(''plottopoemd'')' } ...
               };
    
    % remove geometry textbox for ICA components
    result = inputgui( uigeom, uilist, 'pophelp(''pop_comperm'')', 'ERM grand average/RMS - pop_comperm()');

    if length(result) == 0, return; end;
      

    %decode parameters list
    options = {};
    Mode   =  result{1};
    datadd = eval( [ '[' result{2} ']' ]);
    datsub = eval( [ '[' result{6} ']' ]);
      
ALL=ALLEEG;
    if result{3},  options = { options{:} 'addavg'  'on' }; else, options = { options{:} 'addavg'  'off' }; end;
    if result{4},  options = { options{:} 'addstd'  'on' }; else, options = { options{:} 'addstd'  'off' }; end;
    if result{5},  options = { options{:} 'addall'  'on' }; end;
    datsub = eval( [ '[' result{6} ']' ]);
    if result{7},  options = { options{:} 'subavg'  'on' }; end;
    if result{8},  options = { options{:} 'substd'  'on' }; end;
    if result{9},  options = { options{:} 'suball'  'on' }; end;
    if result{10},  options = { options{:} 'diffavg' 'on' }; else, options = { options{:} 'diffavg' 'off' }; end;
    if result{11}, options = { options{:} 'diffstd' 'on' }; else, options = { options{:} 'diffstd' 'off' }; end;
    if result{12}, options = { options{:} 'diffall' 'on' }; end;
    
    if result{13},           options = { options{:} 'chans' eval( [ '[' result{13} ']' ]) }; end;
    if ~isempty(result{14}), options = { options{:} 'alpha' str2num(result{14}) }; end;
    if result{15},           options = { options{:} 'mode' 'rms' }; end;
    if ~isempty(result{16}), options = { options{:} 'lowpass' str2num(result{16}) }; end;
    if ~isempty(result{17}), options = { options{:} 'tplotopt' eval([ '{ ' result{17} ' }' ]) }; end; 

  
else 
    options = varargin;
end;

if nargin == 3
  datsub = []; % default 
end

% decode inputs
% -------------
if isempty(datadd), error('First edit box (datasets to add) can not be empty'); end;
g = finputcheck( options, ... 
                 { 'chans'    'integer'  [1:ALLEEG(datadd(1)).emdnbchan] 0;
                   'title'    'string'   []               '';
                   'alpha'    'float'    []               [];
                   'geom'     'string'  {'scalp';'array'} fastif(flag, 'scalp', 'array');
                   'addstd'   'string'  {'on';'off'}      fastif(isempty(datsub), 'on', 'off');
                   'substd'   'string'  {'on';'off'}     'off';
                   'diffstd'  'string'  {'on';'off'}     'on';
                   'addavg'   'string'  {'on';'off'}     fastif(isempty(datsub), 'on', 'off');
                   'subavg'   'string'  {'on';'off'}     'off';
                   'diffavg'  'string'  {'on';'off'}     'on';
                   'addall'   'string'  {'on';'off'}     'off';
                   'suball'   'string'  {'on';'off'}     'off';
                   'diffall'  'string'  {'on';'off'}     'off';
                   'std'      'string'  {'on';'off';'none'}     'none';
                   'diffonly' 'string'  {'on';'off';'none'}     'none';
                   'allerms'  'string'  {'on';'off';'none'}     'none';
                   'lowpass'  'float'    [0 Inf]         [];
                   'tlim'     'float'    []              [];
                   'ylim'     'float'    []              [];
                   'tplotopt' 'cell'     []              {};
                   'mode'     'string'  {'ave';'rms'}    'ave';
                   'multcmp'  'integer'  [0 Inf]         [] });
if isstr(g), error(g); end;
if length(datadd) == 1
    disp('Cannot perform statistics using only 1 dataset');
    g.alpha = [];
end;

figure; axcopy

try, icadefs; set(gcf, 'color', BACKCOLOR); axis off; catch, end;

% backward compatibility of param
% -------------------------------
if ~strcmpi(g.diffonly, 'none')
    if strcmpi(g.diffonly, 'off'), g.addavg = 'on'; g.subavg = 'on'; end;
end;
if ~strcmpi(g.allerms, 'none')
    if isempty(datsub)
         g.addall  = g.allerms;
    else g.diffall = g.allerms;
    end;
end;
if ~strcmpi(g.std, 'none')
    if isempty(datsub)
         g.addstd  = g.std;
    else g.diffstd = g.std;
    end;
end;

% check consistency
% -----------------
if length(datsub) > 0 & length(datadd) ~= length(datsub)
    error('The number of component to subtract must be the same as the number of components to add');
end;

% if only 2 dataset entered, toggle average to single trial
% ---------------------------------------------------------
if length(datadd) == 1 &strcmpi(g.addavg, 'on')
    g.addavg  = 'off';
    g.addall = 'on';
end;
if length(datsub) == 1 &strcmpi(g.subavg, 'on')
    g.subavg  = 'off';
    g.suball = 'on';
end;
if length(datsub) == 1 & length(datadd) == 1 &strcmpi(g.diffavg, 'on')
    g.diffavg  = 'off';
    g.diffall = 'on';
end;      

regions = {};
pnts   = ALLEEG(datadd(1)).pnts;
srate  = ALLEEG(datadd(1)).srate;
xmin   = ALLEEG(datadd(1)).xmin;
xmax   = ALLEEG(datadd(1)).xmax;
nbchan = ALLEEG(datadd(1)).nbchan;
chanlocs = ALLEEG(datadd(1)).chanlocs;
emdnbchan = ALLEEG(datadd(1)).emdnbchan;
emdchanlocs = ALLEEG(datadd(1)).emdchanlocs;

for index = union(datadd, datsub)
    if ALLEEG(index).pnts ~= pnts,     error(['Dataset '  int2str(index) ' does not have the same number of points as others']); end;
    if ALLEEG(index).xmin ~= xmin,     error(['Dataset '  int2str(index) ' does not have the same xmin as others']); end;
    if ALLEEG(index).xmax ~= xmax,     error(['Dataset '  int2str(index) ' does not have the same xmax as others']); end;
    if ALLEEG(index).emdnbchan ~= emdnbchan, error(['Dataset '  int2str(index) ' does not have the same number of channels as others']);end;
    if size(ALLEEG(index).IMFs,2)< Mode, error(['Dataset '  int2str(index) ' does not have the same number mode as others']);end;
end;


for nEEG=1:length(datadd)
         if size(ALLEEG(datadd(nEEG)).IMFs,1)==1
            data(1,:,:)=squeeze(ALLEEG(datadd(nEEG)).IMFs(:,Mode+1,:,:));
            else

            data=squeeze(ALLEEG(datadd(nEEG)).IMFs(:,Mode+1,:,:));
          end
            ALLEEG(datadd(nEEG)).data=data;
end



for nEEG=1:length(datsub)
         if size(ALLEEG(datsub(nEEG)).IMFs,1)==1
            data(1,:,:)=squeeze(ALLEEG(datsub(nEEG)).IMFs(:,Mode+1,:,:));
            else
            data=squeeze(ALLEEG(datsub(nEEG)).IMFs(:,Mode+1,:,:));

          end
            ALLEEG(datsub(nEEG)).data=data;
end

    
if ~isempty(g.alpha) & length(datadd) == 1
    error([ 'T-tests require more than one ''' datadd ''' dataset' ]);
end

% compute ERMs for add
% --------------------
for index = 1:length(datadd)
    TMPEEG = eeg_checkset(ALLEEG(datadd(index)),'loaddata');
    if flag == 1, erm1ind(:,:,index)  = mean(TMPEEG.data,3);
    else          erm1ind(:,:,index)  = mean(eeg_getdatact(TMPEEG, 'component', [1:size(TMPEEG.icaweights,1)]),3);
    end;
    addnames{index} = [ '#' int2str(datadd(index)) ' ' TMPEEG.setname ' (Trials=' int2str(TMPEEG.trials) ')' ];
    clear TMPEEG;
end;

% optional: subtract
% ------------------
colors = {}; % color aspect for curves
allcolors = { 'b' 'r' 'g' 'c' 'm' 'y' [0 0.5 0] [0.5 0 0] [0 0 0.5] [0.5 0.5 0] [0 0.5 0.5] [0.5 0 0.5] [0.5 0.5 0.5] };
allcolors = { allcolors{:} allcolors{:} allcolors{:} allcolors{:} allcolors{:} allcolors{:} };
allcolors = { allcolors{:} allcolors{:} allcolors{:} allcolors{:} allcolors{:} allcolors{:} };
if length(datsub) > 0 % dataset to subtract

    % compute ERMs for sub
    % --------------------
    for index = 1:length(datsub)
        TMPEEG = eeg_checkset(ALLEEG(datsub(index)),'loaddata');
        if flag == 1, erm2ind(:,:,index)  = mean(TMPEEG.data,3);
        else          erm2ind(:,:,index)  = mean(eeg_getdatact(TMPEEG, 'component', [1:size(TMPEEG.icaweights,1)]),3);
        end;
        subnames{index} = [ '#' int2str(datsub(index)) ' ' TMPEEG.setname '(Trials=' int2str(TMPEEG.trials) ')' ];
        clear TMPEEG
    end;
    
    l1 = size(erm1ind,3);
    l2 = size(erm2ind,3);
    allcolors1 = allcolors(3:l1+2);
    allcolors2 = allcolors(l1+3:l1+l2+3);
    allcolors3 = allcolors(l1+l2+3:end);
    [erms1, ermstd1, colors1, colstd1, legend1] = preparedata( erm1ind        , g.addavg , g.addstd , g.addall , g.mode, 'Add ' , addnames, 'b', allcolors1 );
    [erms2, ermstd2, colors2, colstd2, legend2] = preparedata( erm2ind        , g.subavg , g.substd , g.suball , g.mode, 'Sub ' , subnames, 'r', allcolors2 );
    [erms3, ermstd3, colors3, colstd3, legend3] = preparedata( erm1ind-erm2ind, g.diffavg, g.diffstd, g.diffall, g.mode, 'Diff ', ...
                                                      { addnames subnames }, 'k', allcolors3 );
    
    % handle special case of std
    % --------------------------
    ermtoplot  = [ erms1 erms2 erms3 ermstd1 ermstd2 ermstd3 ];
    colors     = { colors1{:} colors2{:} colors3{:} colstd1{:} colstd2{:} colstd3{:}};
    legend     = { legend1{:} legend2{:} legend3{:} };
    
    % highlight significant regions
    % -----------------------------
    if ~isempty(g.alpha)
        pvalues = pttest(erm1ind(g.chans,:,:), erm2ind(g.chans,:,:), 3);
        regions = p2regions(pvalues, g.alpha, [xmin xmax]*1000);
    else 
        pvalues= [];
    end;
    
else
    [ermtoplot, ermstd, colors, colstd, legend] = preparedata( erm1ind, g.addavg, g.addstd, g.addall, g.mode, '', addnames, 'k', allcolors);
    ermtoplot = [ ermtoplot ermstd ];
    colors    = { colors{:} colstd{:} };
    
    % highlight significant regions
    % -----------------------------
    if ~isempty(g.alpha)
        pvalues = ttest(erm1ind, 0, 3);
        regions = p2regions(pvalues, g.alpha, [xmin xmax]*1000);
    else 
        pvalues= [];
    end;
end;
    
% lowpass data
% ------------
if ~isempty(g.lowpass)
    if exist('filtfilt') == 2
        ermtoplot = eegfilt(ermtoplot, srate, 0, g.lowpass);
    else
        ermtoplot = eegfiltfft(ermtoplot, srate, 0, g.lowpass);
    end;
end;
if strcmpi(g.geom, 'array') | flag == 0, emdchanlocs = []; end;
if ~isfield(emdchanlocs, 'theta'), emdchanlocs = []; end;

% select time range
% -----------------
if ~isempty(g.tlim)
    pointrange = round(eeg_lat2point(g.tlim/1000, [1 1], srate, [xmin xmax]));
    g.tlim     = eeg_point2lat(pointrange, [1 1], srate, [xmin xmax]);
    ermtoplot  = reshape(ermtoplot, size(ermtoplot,1), pnts, size(ermtoplot,2)/pnts);
    ermtoplot  = ermtoplot(:,[pointrange(1):pointrange(2)],:);
    pnts       = size(ermtoplot,2);
    ermtoplot  = reshape(ermtoplot, size(ermtoplot,1), pnts*size(ermtoplot,3));    
    xmin = g.tlim(1);
    xmax = g.tlim(2);
end;

% plot data
% ---------

plottopoemd( ermtoplot, 'chanlocs', emdchanlocs, 'frames', pnts, ...
          'limits', [xmin xmax 0 0]*1000, 'title', g.title, 'colors', colors, ...
          'chans', g.chans, 'legend', legend, 'regions', regions, 'ylim', g.ylim, g.tplotopt{:});

% outputs
% -------
times  = linspace(xmin, xmax, pnts);
erm1   = mean(erm1ind,3);
if length(datsub) > 0 % dataset to subtract
    erm2   = mean(erm2ind,3);
    ermsub = erm1-erm2;
else
    erm2 = [];
    ermsub = [];
end;

if nargin < 3 & nargout == 1
    erm1 = sprintf('pop_comperm( %s, %d, %s);', inputname(1), ...
                  flag, vararg2str({ datadd datsub options{:} }) );
end;
return;

% convert significance values to alpha
% ------------------------------------
function regions = p2regions( pvalues, alpha, limits);
    
    for index = 1:size(pvalues,1)
        signif = diff([1 pvalues(index,:) 1] < alpha);
        pos    = find([signif] > 0);
        pos    = pos/length(pvalues)*(limits(2) - limits(1))+limits(1);
        neg    = find([signif(2:end)] < 0);
        neg    = neg/length(pvalues)*(limits(2) - limits(1))+limits(1);
        if length(pos) ~= length(neg), signif, pos, neg, error('Region error'); end;
        regions{index} = [neg;pos];
    end;
    
% process data
% ------------
function [ermtoplot, ermstd, colors, colstd, legend] = preparedata( ermind, plotavg, plotstd, plotall, mode, tag, dataset, coloravg, allcolors);

    colors    = {};
    legend    = {};
    ermtoplot = [];
    ermstd    = [];
    colstd    = {};

    % plot individual differences
    % ---------------------------
    if strcmpi(plotall, 'on')
        ermtoplot = [ ermtoplot ermind(:,:) ];
        for index=1:size(ermind,3)
            if iscell(dataset)
                if strcmpi(tag, 'Diff ')
                    legend = { legend{:} [ dataset{1}{index} ' - ' dataset{2}{index} ] };
                else
                    legend = { legend{:} dataset{index} };
                end;
            else
                legend = { legend{:} [ 'Dataset ' int2str(dataset(index)) ] };
            end;
            colors = { colors{:}  allcolors{index} };
        end;
    end;
    
    % plot average
    % ------------
    if strcmpi( plotavg, 'on')
        if strcmpi(mode, 'ave')
             granderm    = mean(ermind,3);
             legend      = { legend{:} [ tag 'Average' ] };
        else granderm    = sqrt(mean(ermind.^2,3));
             legend      = { legend{:} [ tag 'RMS' ] };
        end;
        colors    = { colors{:}  {coloravg;'linewidth';2 }};
        ermtoplot = [ ermtoplot granderm];
    end;

    % plot standard deviation
    % -----------------------
    if strcmpi(plotstd, 'on')
        if strcmpi(plotavg, 'on')
            std1      = std(ermind, [], 3);
            ermtoplot = [ ermtoplot granderm+std1 ];
            ermstd    = granderm-std1;
            legend    = { legend{:} [ tag 'Standard dev.' ] };
            colors    = { colors{:} { coloravg;'linestyle';':' } };
            colstd    = { { coloravg 'linestyle' ':' } };
        else 
            disp('Warning: cannot show standard deviation without showing average');
        end;
    end;

% ------------------------------------------------------------------
    
function [p, t, df] = pttest(d1, d2, dim)
%PTTEST Student's paired t-test.
%       PTTEST(X1, X2) gives the probability that Student's t
%       calculated on paired data X1 and X2 is higher than
%       observed, i.e. the "significance" level. This is used
%       to test whether two paired samples have significantly
%       different means.
%       [P, T] = PTTEST(X1, X2) gives this probability P and the
%       value of Student's t in T. The smaller P is, the more
%       significant the difference between the means.
%       E.g. if P = 0.05 or 0.01, it is very likely that the
%       two sets are sampled from distributions with different
%       means.
%
%       This works for PAIRED SAMPLES, i.e. when elements of X1
%       and X2 correspond one-on-one somehow.
%       E.g. residuals of two models on the same data.
%       Ref: Press et al. 1992. Numerical recipes in C. 14.2, Cambridge.

if size(d1,dim) ~= size(d2, dim)
   error('PTTEST: paired samples must have the same number of elements !')
end
if size(d1,dim) == 1
    close; error('Cannot compute paired t-test for a single ERM difference')
end; 
a1 = mean(d1, dim);
a2 = mean(d2, dim);
v1 = std(d1, [], dim).^2;
v2 = std(d2, [], dim).^2;
n1 = size(d1,dim);
df = n1 - 1;
disp(['Computing t-values, df:' int2str(df) ]);

d1 = d1-repmat(a1, [ones(1,dim-1) size(d1,3)]);
d2 = d2-repmat(a2, [ones(1,dim-1) size(d2,3)]);
%cab = (x1 - a1)' * (x2 - a2) / (n1 - 1);
cab = sum(d1.*d2,3)/(n1-1);
% use abs to avoid numerical errors for very similar data
% for which v1+v2-2cab may be close to 0.
t = (a1 - a2) ./ sqrt(abs(v1 + v2 - 2 * cab) / n1) ;
p = betainc( df ./ (df + t.*t), df/2, 0.5) ;

% ------------------------------------------------------------------

function [p, t] = ttest(d1, d2, dim)
%TTEST Student's t-test for equal variances.
%       TTEST(X1, X2) gives the probability that Student's t
%       calculated on data X1 and X2, sampled from distributions
%       with the same variance, is higher than observed, i.e.
%       the "significance" level. This is used to test whether
%       two sample have significantly different means.
%       [P, T] = TTEST(X1, X2) gives this probability P and the
%       value of Student's t in T. The smaller P is, the more
%       significant the difference between the means.
%       E.g. if P = 0.05 or 0.01, it is very likely that the
%       two sets are sampled from distributions with different
%       means.
%
%       This works if the samples are drawn from distributions with
%       the SAME VARIANCE. Otherwise, use UTTEST.
%
%See also: UTTEST, PTTEST.
if size(d1,dim) == 1
    close; error('Cannot compute t-test for a single ERM')
end; 
a1 = mean(d1, dim);
v1 = std(d1, [], dim).^2;
n1 = size(d1,dim);
if length(d2) == 1 & d2 == 0
    a2 = 0;
    n2 = n1;
    df = n1 + n2 - 2;
    pvar = (2*(n1 - 1) * v1) / df ;
else 
    a2 = mean(d2, dim);
    v2 = std(d2, [], dim).^2;
    n2 = size(d2,dim);
    df = n1 + n2 - 2;
    pvar = ((n1 - 1) * v1 + (n2 - 1) * v2) / df ;     
end;
disp(['Computing t-values, df:' int2str(df) ]);

t = (a1 - a2) ./ sqrt( pvar * (1/n1 + 1/n2)) ;
p = betainc( df ./ (df + t.*t), df/2, 0.5) ;


