% std_ErpCalc(): called by eegplugin_std_ErpCalc.m
%
% Usage:
%   >>  STUDY = std_ErpCalc(STUDY, ALLEEG, EEG)

% Author: Makoto Miyakoshi JSPS/SCCN,INC,UCSD
% History
% 01/28/2013 ver 1.1 by Makoto. Combined condition/group names supported.
% 11/13/2012 ver 1.0 by Makoto. Created.

% Copyright (C) 2012, Makoto Miyakoshi JSPS/SCCN,INC,UCSD
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

function STUDY = std_ErpCalc(STUDY, ALLEEG, EEG)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% generate list of conditions and groups %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear var1 var2 condString groupString
var1 = STUDY.design(STUDY.currentdesign).variable(1,1).value;
condString = '';
if ~isempty(var1)
    for n = 1:length(var1)
        if iscell(var1{1,n})
            tmpString = cell2mat(var1{1,n});
        else
            tmpString = var1{1,n};
        end
        condString = [condString '|' tmpString];
    end
end        
    
var2 = STUDY.design(STUDY.currentdesign).variable(1,2).value;
groupString = '';
if ~isempty(var2)
    for n = 1:length(var2)
        if iscell(var2{1,n})
            tmpString = cell2mat(var2{1,n});
        else
            tmpString = var2{1,n};
        end
        groupString = [groupString '|' tmpString];
    end
end   

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% collect user input %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
try
    userInput = inputgui('title', 'std_ErpCalc()', 'geom', ...
       {{2 12 [0 0] [1 1]} {2 12 [1 0] [1 1]} ...
        {2 12 [0 2] [1 1]} {2 12 [1 2] [1 1]} ...
        {5 12 [0 3] [1 1]} {5 12 [1 3] [1 1]} {5 12 [2 3] [1 1]} {5 12 [3 3] [1 1]} {5 12 [4 3] [1 1]} ...
        {5 12 [0 4] [1 1]} {5 12 [1 4] [1 1]} {5 12 [2 4] [1 1]} {5 12 [3 4] [1 1]} {5 12 [4 4] [1 1]} ...
        {4 12 [0 6] [1 1]} {4 12 [1 6] [1 1]} {4 12 [2 6] [1 1]} {4 12 [3 6] [1 1]}...
        {4 12 [2 7] [1 1]} {8 12 [6 7] [1 1]} {8 12 [7 7] [1 1]}...
        {2 12 [0 8] [1 1]} {2 12 [1 8] [1 1]}...
        {1 12 [0 10] [1 1]} ...
        {1 12 [0 11] [1 1]}},... 
    'uilist',...
       {{'style' 'text' 'string' 'Data type'} {'style' 'popupmenu' 'string' 'Cluster ERP|Backprojected ERP' 'tag' 'dataSelection' 'value' STUDY.erpCalc.dataType} ...
        {'style' 'text' 'string' 'Cluster num [N] or Backproj channel [ex.Fz] '} {'style' 'edit' 'string' STUDY.erpCalc.clsOrChanName} ...
        {'style' 'text' 'string' 'A in A-B'} {'style' 'text' 'string' 'Select condition [N]'} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection' 'value' STUDY.erpCalc.A_condition} {'style' 'text' 'string' 'Select group [N]'} {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection' 'value' STUDY.erpCalc.A_group} ...
        {'style' 'text' 'string' 'B in A-B'} {'style' 'text' 'string' 'Select condition [N]'} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection' 'value' STUDY.erpCalc.B_condition} {'style' 'text' 'string' 'Select group [N]'} {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection' 'value' STUDY.erpCalc.B_group} ...
        {'style' 'text' 'string' 'Methods'}  {'style' 'popupmenu' 'string' 'Window average|Peak within window' 'tag' 'methodSelection' 'value' STUDY.erpCalc.aveMethods} {'style' 'text' 'string' 'Window [start_ms end_ms]'} {'style' 'edit' 'string' num2str(STUDY.erpCalc.window)} ...
        {'style' 'text' 'string' 'Peak+/- width [ms]'} {'style' 'popupmenu' 'string' 'max|min' 'tag' 'dataSelection' 'value' STUDY.erpCalc.peak} {'style' 'edit' 'string' num2str(STUDY.erpCalc.peakWin)} ...
        {'style' 'text' 'string' 'Output file name (option)'}  {'style' 'edit' 'string' STUDY.erpCalc.saveFileName} ...
        {'style' 'text' 'string' 'Tips: Use Bonferroni-Holm: for n comparison, 1/n for the smallest p-value, 1/(n-1) for the second smallest p-value, ...'}...
        {'style' 'text' 'string' '         until you encounter an insignificant result. This is simple but more powerful than Bonferroni!'}});
catch
    userInput = inputgui('title', 'std_ErpCalc()', 'geom', ...
       {{2 12 [0 0] [1 1]} {2 12 [1 0] [1 1]} ...
        {2 12 [0 2] [1 1]} {2 12 [1 2] [1 1]} ...
        {5 12 [0 3] [1 1]} {5 12 [1 3] [1 1]} {5 12 [2 3] [1 1]} {5 12 [3 3] [1 1]} {5 12 [4 3] [1 1]} ...
        {5 12 [0 4] [1 1]} {5 12 [1 4] [1 1]} {5 12 [2 4] [1 1]} {5 12 [3 4] [1 1]} {5 12 [4 4] [1 1]} ...
        {4 12 [0 6] [1 1]} {4 12 [1 6] [1 1]} {4 12 [2 6] [1 1]} {4 12 [3 6] [1 1]}...
        {4 12 [2 7] [1 1]} {8 12 [6 7] [1 1]} {8 12 [7 7] [1 1]} ...
        {2 12 [0 8] [1 1]} {2 12 [1 8] [1 1]} ...
        {1 12 [0 10] [1 1]} ...
        {1 12 [0 11] [1 1]}},...
    'uilist',...
       {{'style' 'text' 'string' 'Data type'} {'style' 'popupmenu' 'string' 'Cluster ERP|Backprojected ERP' 'tag' 'dataSelection' 'value' 1} ...
        {'style' 'text' 'string' 'Cluster num [N] or Backproj channel [ex.Fz] '} {'style' 'edit' 'string' ''} ...
        {'style' 'text' 'string' 'A in A-B'} {'style' 'text' 'string' 'Select condition [N]'} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection' 'value' 1} {'style' 'text' 'string' 'Select group [N]'} {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection' 'value' 1} ...
        {'style' 'text' 'string' 'B in A-B'} {'style' 'text' 'string' 'Select condition [N]'} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection' 'value' 1} {'style' 'text' 'string' 'Select group [N]'} {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection' 'value' 1} ...
        {'style' 'text' 'string' 'Methods'}  {'style' 'popupmenu' 'string' 'Window average|Peak within window' 'tag' 'methodSelection' 'value' 1} {'style' 'text' 'string' 'Window [start_ms end_ms]'} {'style' 'edit' 'string' ''} ...
        {'style' 'text' 'string' 'Peak+/- width [ms]'} {'style' 'popupmenu' 'string' 'max|min' 'tag' 'dataSelection' 'value' 1} {'style' 'edit' 'string' ''} ...
        {'style' 'text' 'string' 'Output file name (option)'}  {'style' 'edit' 'string' ''}...
        {'style' 'text' 'string' 'Tips: Use Bonferroni-Holm: for n comparison, 1/n for the smallest p-value, 1/(n-1) for the second smallest p-value, ...'} ...
        {'style' 'text' 'string' '         until you encounter an insignificant result. This is simple but more powerful than Bonferroni!'}});
end

% if canceled, escape
if isempty(userInput)
    return
end

% at least condition or group specified, otherwise error
if ~(userInput{1,3}>1 && userInput{1,5}>1) || ~(userInput{1,4}>1 || userInput{1,6}>1)
    error('Enter conditions and groups to subtract')
end

% interpret userInput
STUDY.erpCalc.dataType      = userInput{1,1};
STUDY.erpCalc.clsOrChanName = userInput{1,2};
STUDY.erpCalc.A_condition   = userInput{1,3}-1;
STUDY.erpCalc.A_group       = userInput{1,4}-1;
STUDY.erpCalc.B_condition   = userInput{1,5}-1;
STUDY.erpCalc.B_group       = userInput{1,6}-1;
STUDY.erpCalc.aveMethods    = userInput{1,7};
STUDY.erpCalc.window        = str2num(userInput{1,8});
STUDY.erpCalc.peak          = userInput{1,9};
if ~isempty(userInput{1,10}); STUDY.erpCalc.peakWin = str2num(userInput{1,10}); else; STUDY.erpCalc.peakWin = [];     end
if ~isempty(userInput{1,11}); STUDY.erpCalc.saveFileName  = userInput{1,11};    else; STUDY.erpCalc.saveFileName = [];end

% compute average ERPs
if STUDY.erpCalc.dataType == 1 % cluster ERP
    
    % obtain current cluster number
    tmpClust = str2num(STUDY.erpCalc.clsOrChanName);
   
    % check if erpdata exists
    if ~isfield(STUDY.cluster(1,tmpClust), 'erpdata') 
        for n = 2:length(STUDY.cluster)
            STUDY = std_readerp(STUDY, ALLEEG, 'clusters', n);
        end
    end
    
    % find timerange
    erpTimes = STUDY.cluster(1,tmpClust).erptimes;
    winStart = min(find(STUDY.erpCalc.window(1) < erpTimes));
    winEnd   = max(find(erpTimes < STUDY.erpCalc.window(2)));
    
    % prepare A
    tmpA = STUDY.cluster(1,tmpClust).erpdata{STUDY.erpCalc.A_condition, STUDY.erpCalc.A_group};
    
    % prepare B
    tmpB = STUDY.cluster(1,tmpClust).erpdata{STUDY.erpCalc.B_condition, STUDY.erpCalc.B_group};

elseif STUDY.erpCalc.dataType == 2 % backProjectedData
    
    % obtain current channel number
    for n = 1:length(STUDY.backProj.channel)
        if strcmp(STUDY.backProj.channel{n}, STUDY.erpCalc.clsOrChanName)
            tmpChan = n;
            break
        end
        error('Fail to find the channel. See STUDY.backProj.channel.')
    end
    
    % find timerange
    erpTimes = EEG(1,1).times;
    winStart = min(find(STUDY.erpCalc.window(1) < erpTimes));
    winEnd   = max(find(erpTimes < STUDY.erpCalc.window(2)));
    
    % prepare A
    if length(STUDY.backProj.channel) > 1
        tmpA = STUDY.backProj.backProjectedData{STUDY.erpCalc.A_condition, STUDY.erpCalc.A_group}(tmpChan, :, :);
        tmpA = squeeze(tmpA);
    else
        tmpA = STUDY.backProj.backProjectedData{STUDY.erpCalc.A_condition, STUDY.erpCalc.A_group};
    end
    
    % prepare B
    if length(STUDY.backProj.channel) > 1
        tmpB = STUDY.backProj.backProjectedData{STUDY.erpCalc.B_condition, STUDY.erpCalc.B_group}(tmpChan, :, :);
        tmpB = squeeze(tmpB);
    else
        tmpB = STUDY.backProj.backProjectedData{STUDY.erpCalc.B_condition, STUDY.erpCalc.B_group};
    end

end
    
%        if simple averaging
if     STUDY.erpCalc.aveMethods == 1;
    finalA = mean(tmpA(winStart:winEnd, :), 1);
    finalB = mean(tmpB(winStart:winEnd, :), 1);

elseif STUDY.erpCalc.aveMethods == 2;% peak detection
    tmpPeakWin = round(STUDY.erpCalc.peakWin/(1000/EEG(1,1).srate));

    for n = 1:size(tmpA, 2)
        tmpdata = tmpA(winStart:winEnd,n);
        if     STUDY.erpCalc.peak == 1; % detect maximum
            [dummy tmppeak] = max(tmpdata);
        elseif STUDY.erpCalc.peak == 2; % detect minimum
            [dummy tmppeak] = min(tmpdata);
        end
        tmppeak = winStart + tmppeak; 
        tmpdata = mean(tmpA(tmppeak-tmpPeakWin:tmppeak+tmpPeakWin,n));
        finalA(1,n) = tmpdata;
        peakA(1,n) = erpTimes(tmppeak);
    end

    for n = 1:size(tmpB, 2)
        tmpdata = tmpB(winStart:winEnd,n);
        if     STUDY.erpCalc.peak == 1; % detect positive peak
            [dummy tmppeak] = max(tmpdata);
        elseif STUDY.erpCalc.peak == 2; % detect positive peak
            [dummy tmppeak] = min(tmpdata);
        end
        tmppeak = winStart + tmppeak; 
        tmpdata = mean(tmpB(tmppeak-tmpPeakWin:tmppeak+tmpPeakWin,n));
        finalB(1,n) = tmpdata;
        peakB(1,n) = erpTimes(tmppeak);
    end
end

% statistics
A_mean = mean(finalA);
A_std  = std(finalA);
B_mean = mean(finalB);
B_std  = std(finalB);

disp(char(10))

if      STUDY.erpCalc.A_group == STUDY.erpCalc.B_group;
    [stats, df, pvals] = statcond({finalA finalB}, 'paired', 'on');
elseif  STUDY.erpCalc.A_group ~= STUDY.erpCalc.B_group;
    [stats, df, pvals] = statcond({finalA finalB});
end

disp(['mean A = ' num2str(A_mean) ' (' num2str(A_std) ')']);
disp(['mean B = ' num2str(B_mean) ' (' num2str(B_std) ')']);
disp(['A - B: t = ' num2str(stats) ', df = ' num2str(df) ', pval = ' num2str(pvals)]);

if ~isempty(userInput{1,11});
    finalA = double(finalA)';
    finalB = double(finalB)';
    save([userInput{1,11} '_A.txt'], 'finalA', '-ascii');
    save([userInput{1,11} '_B.txt'], 'finalB', '-ascii');
    disp(['Data were saved under' pwd]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% peak latency statistics %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if STUDY.erpCalc.aveMethods == 2;% peak detection
    peakA_mean = mean(peakA);
    peakA_std  = std(peakA);
    peakB_mean = mean(peakB);
    peakB_std  = std(peakB);
    
    disp(char(10))
    
    if      STUDY.erpCalc.A_group == STUDY.erpCalc.B_group;
        [stats, df, pvals] = statcond({peakA peakB}, 'paired', 'on');
    elseif  STUDY.erpCalc.A_group ~= STUDY.erpCalc.B_group;
        [stats, df, pvals] = statcond({peakA peakB});
    end

    disp(['mean A (peak latency) = ' num2str(peakA_mean) ' (' num2str(peakA_std) ')']);
    disp(['mean B (peak latency) = ' num2str(peakB_mean) ' (' num2str(peakB_std) ')']);
    disp(['A - B (peak latency): t = ' num2str(stats) ', df = ' num2str(df) ', pval = ' num2str(pvals)]);

    if ~isempty(userInput{1,11});
        peakA = double(peakA)';
        peakB = double(peakB)';
        save([userInput{1,11} '_A_latency.txt'], 'peakA', '-ascii');
        save([userInput{1,11} '_B_latency.txt'], 'peakB', '-ascii');
        disp(['Peak latency data were saved under' pwd]);
    end
end
    