% std_FlexibleErpPlot() - a utility tool for plotting ERPs well.
%
% Usage
% [STUDY, plotLines] = std_FlexibleErpPlot(STUDY, ALLEEG, EEG)
%
% Inputs
% STUDY, ALLEEG, EEG: EEGLAB variables.
% GUI : inputs in GUI is stored and used for after second use. 
%
% Outputs
% plotLines: 5 cells containing processed lines.
%
% Note
% Low-pass filter used here is fir1 that is twice as sharp as the one that
% is used in STUDY ERP plotting.

% Authors: Makoto Miyakoshi, JSPS/SCCN,INC,UCSD
% History:
% 06/19/2014 ver 1.3 by Makoto. 'none' for no entry in GUI. If only within- or between-subject condition, omit the other inputs. Filter order optimized: same as the cutoff frequency to minimize the filter order.
% 01/28/2013 ver 1.2 by Makoto. Combined condition/group names supported.
% 01/23/2013 ver 1.1 by Makoto. Error by GUI cancel by user fixed. Filter now calls Andreas Widmann's pop_eegfiltnew().
% 11/16/2012 ver 1.0 by Makoto. Created.

% Copyright (C) Makoto Miyakoshi
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

function [STUDY, plotLines] = std_FlexibleErpPlot(STUDY, ALLEEG, EEG)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% generate list of conditions and groups %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% retrieve within-subject conditions
condString = '(none)';
if ~isempty(STUDY.condition{1,1})
    var1 = STUDY.design(STUDY.currentdesign).variable(1,1).value;
    for n = 1:length(var1)
        if iscell(var1{1,n})
            tmpString = cell2mat(var1{1,n});
        else
            tmpString = var1{1,n};
        end
        condString = [condString '|' tmpString]; %#ok<*AGROW>
    end
end    

% retrieve between-subject conditions
groupString = '(none)';
if ~isempty(STUDY.group{1,1})
    var2 = STUDY.design(STUDY.currentdesign).variable(1,2).value;
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
% launch GUI to collect user input
[userInput, tmpSTUDY] = inputgui('title', 'std_FlexibleErpPlot()', 'userdata', STUDY, 'geom', ...
   {{2 14 [0 0] [1 1]} {2 14 [1 0] [1 1]} ...
    {2 14 [0 2] [1 1]} {2 14 [1 2] [1 1]} ...
    {2 14 [0 3] [1 1]} {2 14 [1 3] [1 1]} ...
    {9 14 [0 4] [1 1]} {9 14 [1 4] [1 1]} {9 14 [2 4] [1 1]} {9 14 [3 4] [1 1]} {9 14 [4 4] [1 1]} {9 14 [5 4] [1 1]} {9 14 [6 4] [1 1]} {9 14 [7 4] [1 1]} {9 14 [8 4] [1 1]}  ...
    {9 14 [0 5] [1 1]} {9 14 [1 5] [1 1]} {9 14 [2 5] [1 1]} {9 14 [3 5] [1 1]} {9 14 [4 5] [1 1]} {9 14 [5 5] [1 1]} {9 14 [6 5] [1 1]} {9 14 [7 5] [1 1]} {9 14 [8 5] [1 1]} ...
    {9 14 [0 6] [1 1]} {9 14 [1 6] [1 1]} {9 14 [2 6] [1 1]} {9 14 [3 6] [1 1]} {9 14 [4 6] [1 1]} {9 14 [5 6] [1 1]} {9 14 [6 6] [1 1]} {9 14 [7 6] [1 1]} {9 14 [8 6] [1 1]} ...
    {9 14 [0 7] [1 1]} {9 14 [1 7] [1 1]} {9 14 [2 7] [1 1]} {9 14 [3 7] [1 1]} {9 14 [4 7] [1 1]} {9 14 [5 7] [1 1]} {9 14 [6 7] [1 1]} {9 14 [7 7] [1 1]} {9 14 [8 7] [1 1]} ...    
    {9 14 [0 8] [1 1]} {9 14 [1 8] [1 1]} {9 14 [2 8] [1 1]} {9 14 [3 8] [1 1]} {9 14 [4 8] [1 1]} {9 14 [5 8] [1 1]} {9 14 [6 8] [1 1]} {9 14 [7 8] [1 1]} {9 14 [8 8] [1 1]} ...
    {9 14 [0 9] [1 1]} {9 14 [1 9] [1 1]} {9 14 [2 9] [1 1]} {9 14 [3 9] [1 1]} {9 14 [4 9] [1 1]} {9 14 [5 9] [1 1]} {9 14 [6 9] [1 1]} {9 14 [7 9] [1 1]} {9 14 [8 9] [1 1]} ...    
    {3 14 [1 11] [1 1]} ...
    {4 14 [0 13] [1 1]} {4 14 [1 13] [1 1]} {4 14 [2 13] [1 1]} {4 14 [3 13] [1 1]} ...
    {4 14 [0 14] [1 1]} {4 14 [1 14] [1 1]} {4 14 [2 14] [1 1]} {4 14 [3 14] [1 1]}},...
'uilist',...
   {{'style' 'text' 'string' 'Data type'} {'style' 'popupmenu' 'string' 'Cluster ERP|Backprojected ERP' 'tag' 'dataSelection' 'value' STUDY.flexErpPlot.dataType} ...
    {'style' 'text' 'string' 'Cluster num [N] or Backproj channel [ex.Fz] '} {'style' 'edit' 'string' STUDY.flexErpPlot.channel} ...
    {'style' 'text' 'string' 'Baseline for plot [start_ms end_ms]'} {'style' 'edit' 'string' STUDY.flexErpPlot.baseLine} ...
    {'style' 'text' 'string' ''}  {'style' 'text' 'string' 'Color'}  {'style' 'text' 'string' 'Width'}  {'style' 'text' 'string' 'Style'} {'style' 'text' 'string' 'Condition'} {'style' 'text' 'string' 'Group'} {'style' 'text' 'string' 'Operator'} {'style' 'text' 'string' 'Condition'} {'style' 'text' 'string' 'Group'}...
    {'style' 'text' 'string' 'Line 1'} {'style' 'popupmenu' 'string' '(none)|Black|Red|Blue|Green|Fuchsia|Lime|Aqua|Maroon|Olive|Purple|Teal|Navy|Gray' 'tag' 'Color1' 'value' STUDY.flexErpPlot.lines{1,1}.color} {'style' 'popupmenu' 'string' '(none)|0.5|1|1.5|2|2.5|3|3.5|4' 'tag' 'LineWidth1' 'value' STUDY.flexErpPlot.lines{1,1}.width} {'style' 'popupmenu' 'string' '(none)|Solid|Dashed|Dotted|Dash-dot' 'tag' 'LineStyle1' 'value' STUDY.flexErpPlot.lines{1,1}.style} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection1' 'value' STUDY.flexErpPlot.lines{1,1}.condition} {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection1' 'value' STUDY.flexErpPlot.lines{1,1}.group} {'style' 'popupmenu' 'string' '(none)|-|+' 'tag' 'operator1' 'value' STUDY.flexErpPlot.lines{1,1}.operator} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection1' 'value' STUDY.flexErpPlot.lines{1,1}.subCond}  {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection1' 'value' STUDY.flexErpPlot.lines{1,1}.subGroup}...
    {'style' 'text' 'string' 'Line 2'} {'style' 'popupmenu' 'string' '(none)|Black|Red|Blue|Green|Fuchsia|Lime|Aqua|Maroon|Olive|Purple|Teal|Navy|Gray' 'tag' 'Color2' 'value' STUDY.flexErpPlot.lines{1,2}.color} {'style' 'popupmenu' 'string' '(none)|0.5|1|1.5|2|2.5|3|3.5|4' 'tag' 'LineWidth2' 'value' STUDY.flexErpPlot.lines{1,2}.width} {'style' 'popupmenu' 'string' '(none)|Solid|Dashed|Dotted|Dash-dot' 'tag' 'LineStyle2' 'value' STUDY.flexErpPlot.lines{1,2}.style} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection2' 'value' STUDY.flexErpPlot.lines{1,2}.condition} {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection2' 'value' STUDY.flexErpPlot.lines{1,2}.group} {'style' 'popupmenu' 'string' '(none)|-|+' 'tag' 'operator2' 'value' STUDY.flexErpPlot.lines{1,2}.operator} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection2' 'value' STUDY.flexErpPlot.lines{1,2}.subCond}  {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection2' 'value' STUDY.flexErpPlot.lines{1,2}.subGroup}...
    {'style' 'text' 'string' 'Line 3'} {'style' 'popupmenu' 'string' '(none)|Black|Red|Blue|Green|Fuchsia|Lime|Aqua|Maroon|Olive|Purple|Teal|Navy|Gray' 'tag' 'Color3' 'value' STUDY.flexErpPlot.lines{1,3}.color} {'style' 'popupmenu' 'string' '(none)|0.5|1|1.5|2|2.5|3|3.5|4' 'tag' 'LineWidth3' 'value' STUDY.flexErpPlot.lines{1,3}.width} {'style' 'popupmenu' 'string' '(none)|Solid|Dashed|Dotted|Dash-dot' 'tag' 'LineStyle3' 'value' STUDY.flexErpPlot.lines{1,3}.style} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection3' 'value' STUDY.flexErpPlot.lines{1,3}.condition} {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection3' 'value' STUDY.flexErpPlot.lines{1,3}.group} {'style' 'popupmenu' 'string' '(none)|-|+' 'tag' 'operator3' 'value' STUDY.flexErpPlot.lines{1,3}.operator} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection3' 'value' STUDY.flexErpPlot.lines{1,3}.subCond}  {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection3' 'value' STUDY.flexErpPlot.lines{1,3}.subGroup}...
    {'style' 'text' 'string' 'Line 4'} {'style' 'popupmenu' 'string' '(none)|Black|Red|Blue|Green|Fuchsia|Lime|Aqua|Maroon|Olive|Purple|Teal|Navy|Gray' 'tag' 'Color4' 'value' STUDY.flexErpPlot.lines{1,4}.color} {'style' 'popupmenu' 'string' '(none)|0.5|1|1.5|2|2.5|3|3.5|4' 'tag' 'LineWidth4' 'value' STUDY.flexErpPlot.lines{1,4}.width} {'style' 'popupmenu' 'string' '(none)|Solid|Dashed|Dotted|Dash-dot' 'tag' 'LineStyle4' 'value' STUDY.flexErpPlot.lines{1,4}.style} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection4' 'value' STUDY.flexErpPlot.lines{1,4}.condition} {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection4' 'value' STUDY.flexErpPlot.lines{1,4}.group} {'style' 'popupmenu' 'string' '(none)|-|+' 'tag' 'operator4' 'value' STUDY.flexErpPlot.lines{1,4}.operator} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection4' 'value' STUDY.flexErpPlot.lines{1,4}.subCond}  {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection4' 'value' STUDY.flexErpPlot.lines{1,4}.subGroup}...
    {'style' 'text' 'string' 'Line 5'} {'style' 'popupmenu' 'string' '(none)|Black|Red|Blue|Green|Fuchsia|Lime|Aqua|Maroon|Olive|Purple|Teal|Navy|Gray' 'tag' 'Color5' 'value' STUDY.flexErpPlot.lines{1,5}.color} {'style' 'popupmenu' 'string' '(none)|0.5|1|1.5|2|2.5|3|3.5|4' 'tag' 'LineWidth5' 'value' STUDY.flexErpPlot.lines{1,5}.width} {'style' 'popupmenu' 'string' '(none)|Solid|Dashed|Dotted|Dash-dot' 'tag' 'LineStyle5' 'value' STUDY.flexErpPlot.lines{1,5}.style} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection5' 'value' STUDY.flexErpPlot.lines{1,5}.condition} {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection5' 'value' STUDY.flexErpPlot.lines{1,5}.group} {'style' 'popupmenu' 'string' '(none)|-|+' 'tag' 'operator5' 'value' STUDY.flexErpPlot.lines{1,5}.operator} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection5' 'value' STUDY.flexErpPlot.lines{1,5}.subCond}  {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection5' 'value' STUDY.flexErpPlot.lines{1,5}.subGroup}...
    {'style' 'pushbutton' 'enable' 'on' 'string' 'erp params'   'Callback' 'TMP = get(gcbf, ''userdata''); TMP = pop_erpparams(TMP);  set(gcbf, ''userdata'', TMP); clear TMP;' } ...
    {'style' 'text' 'string' 'y-axis +/- length [microvolt]'}  {'style' 'edit' 'string' STUDY.flexErpPlot.yAxisLength}  {'style' 'text' 'string' 'Minor tick interval [ms]'}  {'style' 'edit' 'string' STUDY.flexErpPlot.minorTickInterval}...
    {'style' 'text' 'string' 'Plot title'}  {'style' 'edit' 'string' STUDY.flexErpPlot.plotTitle}  {'style' 'text' 'string' 'Legend'}  {'style' 'edit' 'string' STUDY.flexErpPlot.legendString}});

catch
[userInput, tmpSTUDY] = inputgui('title', 'std_FlexibleErpPlot()', 'userdata', STUDY, 'geom', ...
   {{2 14 [0 0] [1 1]} {2 14 [1 0] [1 1]} ...
    {2 14 [0 2] [1 1]} {2 14 [1 2] [1 1]} ...
    {2 14 [0 3] [1 1]} {2 14 [1 3] [1 1]} ...
    {9 14 [0 4] [1 1]} {9 14 [1 4] [1 1]} {9 14 [2 4] [1 1]} {9 14 [3 4] [1 1]} {9 14 [4 4] [1 1]} {9 14 [5 4] [1 1]} {9 14 [6 4] [1 1]} {9 14 [7 4] [1 1]} {9 14 [8 4] [1 1]}  ...
    {9 14 [0 5] [1 1]} {9 14 [1 5] [1 1]} {9 14 [2 5] [1 1]} {9 14 [3 5] [1 1]} {9 14 [4 5] [1 1]} {9 14 [5 5] [1 1]} {9 14 [6 5] [1 1]} {9 14 [7 5] [1 1]} {9 14 [8 5] [1 1]} ...
    {9 14 [0 6] [1 1]} {9 14 [1 6] [1 1]} {9 14 [2 6] [1 1]} {9 14 [3 6] [1 1]} {9 14 [4 6] [1 1]} {9 14 [5 6] [1 1]} {9 14 [6 6] [1 1]} {9 14 [7 6] [1 1]} {9 14 [8 6] [1 1]} ...
    {9 14 [0 7] [1 1]} {9 14 [1 7] [1 1]} {9 14 [2 7] [1 1]} {9 14 [3 7] [1 1]} {9 14 [4 7] [1 1]} {9 14 [5 7] [1 1]} {9 14 [6 7] [1 1]} {9 14 [7 7] [1 1]} {9 14 [8 7] [1 1]} ...    
    {9 14 [0 8] [1 1]} {9 14 [1 8] [1 1]} {9 14 [2 8] [1 1]} {9 14 [3 8] [1 1]} {9 14 [4 8] [1 1]} {9 14 [5 8] [1 1]} {9 14 [6 8] [1 1]} {9 14 [7 8] [1 1]} {9 14 [8 8] [1 1]} ...
    {9 14 [0 9] [1 1]} {9 14 [1 9] [1 1]} {9 14 [2 9] [1 1]} {9 14 [3 9] [1 1]} {9 14 [4 9] [1 1]} {9 14 [5 9] [1 1]} {9 14 [6 9] [1 1]} {9 14 [7 9] [1 1]} {9 14 [8 9] [1 1]} ...    
    {3 14 [1 11] [1 1]}...
    {4 14 [0 13] [1 1]} {4 14 [1 13] [1 1]} {4 14 [2 13] [1 1]} {4 14 [3 13] [1 1]} ...
    {4 14 [0 14] [1 1]} {4 14 [1 14] [1 1]} {4 14 [2 14] [1 1]} {4 14 [3 14] [1 1]}},...
'uilist',...
   {{'style' 'text' 'string' 'Data type'} {'style' 'popupmenu' 'string' 'Cluster ERP|Backprojected ERP' 'tag' 'dataSelection' 'value' 1} ...
    {'style' 'text' 'string' 'Cluster num [N] or Backproj channel [ex.Fz] '} {'style' 'edit' 'string' ''} ...
    {'style' 'text' 'string' 'Baseline for plot [start_ms end_ms]'} {'style' 'edit' 'string' ''} ...
    {'style' 'text' 'string' ''}  {'style' 'text' 'string' 'Color'}  {'style' 'text' 'string' 'Width'}  {'style' 'text' 'string' 'Style'} {'style' 'text' 'string' 'Condition'} {'style' 'text' 'string' 'Group'} {'style' 'text' 'string' 'Operator'} {'style' 'text' 'string' 'Condition'} {'style' 'text' 'string' 'Group'}...
    {'style' 'text' 'string' 'Line 1'} {'style' 'popupmenu' 'string' '(none)|Black|Red|Blue|Green|Fuchsia|Lime|Aqua|Maroon|Olive|Purple|Teal|Navy|Gray' 'tag' 'Color1' 'value' 1} {'style' 'popupmenu' 'string' '(none)|0.5|1|1.5|2|2.5|3|3.5|4' 'tag' 'LineWidth1' 'value' 1} {'style' 'popupmenu' 'string' '(none)|Solid|Dashed|Dotted|Dash-dot' 'tag' 'LineStyle1' 'value' 1} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection1' 'value' 1} {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection1' 'value' 1} {'style' 'popupmenu' 'string' '(none)|-|+' 'tag' 'operator1' 'value' 1} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection1' 'value' 1}  {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection1' 'value' 1}...
    {'style' 'text' 'string' 'Line 2'} {'style' 'popupmenu' 'string' '(none)|Black|Red|Blue|Green|Fuchsia|Lime|Aqua|Maroon|Olive|Purple|Teal|Navy|Gray' 'tag' 'Color2' 'value' 1} {'style' 'popupmenu' 'string' '(none)|0.5|1|1.5|2|2.5|3|3.5|4' 'tag' 'LineWidth2' 'value' 1} {'style' 'popupmenu' 'string' '(none)|Solid|Dashed|Dotted|Dash-dot' 'tag' 'LineStyle2' 'value' 1} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection2' 'value' 1} {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection2' 'value' 1} {'style' 'popupmenu' 'string' '(none)|-|+' 'tag' 'operator2' 'value' 1} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection2' 'value' 1}  {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection2' 'value' 1}...
    {'style' 'text' 'string' 'Line 3'} {'style' 'popupmenu' 'string' '(none)|Black|Red|Blue|Green|Fuchsia|Lime|Aqua|Maroon|Olive|Purple|Teal|Navy|Gray' 'tag' 'Color3' 'value' 1} {'style' 'popupmenu' 'string' '(none)|0.5|1|1.5|2|2.5|3|3.5|4' 'tag' 'LineWidth3' 'value' 1} {'style' 'popupmenu' 'string' '(none)|Solid|Dashed|Dotted|Dash-dot' 'tag' 'LineStyle3' 'value' 1} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection3' 'value' 1} {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection3' 'value' 1} {'style' 'popupmenu' 'string' '(none)|-|+' 'tag' 'operator3' 'value' 1} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection3' 'value' 1}  {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection3' 'value' 1}...
    {'style' 'text' 'string' 'Line 4'} {'style' 'popupmenu' 'string' '(none)|Black|Red|Blue|Green|Fuchsia|Lime|Aqua|Maroon|Olive|Purple|Teal|Navy|Gray' 'tag' 'Color4' 'value' 1} {'style' 'popupmenu' 'string' '(none)|0.5|1|1.5|2|2.5|3|3.5|4' 'tag' 'LineWidth4' 'value' 1} {'style' 'popupmenu' 'string' '(none)|Solid|Dashed|Dotted|Dash-dot' 'tag' 'LineStyle4' 'value' 1} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection4' 'value' 1} {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection4' 'value' 1} {'style' 'popupmenu' 'string' '(none)|-|+' 'tag' 'operator4' 'value' 1} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection4' 'value' 1}  {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection4' 'value' 1}...
    {'style' 'text' 'string' 'Line 5'} {'style' 'popupmenu' 'string' '(none)|Black|Red|Blue|Green|Fuchsia|Lime|Aqua|Maroon|Olive|Purple|Teal|Navy|Gray' 'tag' 'Color5' 'value' 1} {'style' 'popupmenu' 'string' '(none)|0.5|1|1.5|2|2.5|3|3.5|4' 'tag' 'LineWidth5' 'value' 1} {'style' 'popupmenu' 'string' '(none)|Solid|Dashed|Dotted|Dash-dot' 'tag' 'LineStyle5' 'value' 1} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection5' 'value' 1} {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection5' 'value' 1} {'style' 'popupmenu' 'string' '(none)|-|+' 'tag' 'operator5' 'value' 1} {'style' 'popupmenu' 'string' condString 'tag' 'dataSelection5' 'value' 1}  {'style' 'popupmenu' 'string' groupString 'tag' 'dataSelection5' 'value' 1}...
    {'style' 'pushbutton' 'enable' 'on' 'string' 'erp params'   'Callback' 'TMP = get(gcbf, ''userdata''); TMP = pop_erpparams(TMP);  set(gcbf, ''userdata'', TMP); clear TMP;'} ...
    {'style' 'text' 'string' 'y-axis +/- length [microvolt]'}  {'style' 'edit' 'string' '1'}  {'style' 'text' 'string' 'Minor tick interval [ms]'}  {'style' 'edit' 'string' '200'}...
    {'style' 'text' 'string' 'Plot title'}  {'style' 'edit' 'string' 'plot title here'}  {'style' 'text' 'string' 'Legend'}  {'style' 'edit' 'string' '{''Example1'', ''Example2''}' }});
end

% check cluster num
if userInput{1,1}==1
    if isempty(userInput{1,2}); error('Specify cluster number.'); end
    if ~isnumeric(str2num(userInput{1,2})); error('Use integer to specify cluster number.'); end %#ok<*ST2NM>
    if mod(str2num(userInput{1,2}),1)~=0; error('Use integer to specify cluster number.'); end
else
    if isempty(userInput{1,2}); error('Specify channel name(s).'); end
end

% check baseline period
if isempty(userInput{1,3}); error('Specify baseline period.'); end
if max(size(str2num(userInput{1,3})))~=2; error('Specify start and end of baseline period in ms.'); end

% update STUDY with tmpSTUDY
STUDY = tmpSTUDY;

% decode and store userInput
STUDY.flexErpPlot.dataType = userInput{1,1};
STUDY.flexErpPlot.channel  = userInput{1,2};
STUDY.flexErpPlot.baseLine = userInput{1,3};

STUDY.flexErpPlot.lines{1,1}.color     = userInput{1,4};
STUDY.flexErpPlot.lines{1,1}.width     = userInput{1,5};
STUDY.flexErpPlot.lines{1,1}.style     = userInput{1,6};
STUDY.flexErpPlot.lines{1,1}.condition = userInput{1,7};
STUDY.flexErpPlot.lines{1,1}.group     = userInput{1,8};
STUDY.flexErpPlot.lines{1,1}.operator  = userInput{1,9};
STUDY.flexErpPlot.lines{1,1}.subCond   = userInput{1,10};
STUDY.flexErpPlot.lines{1,1}.subGroup  = userInput{1,11};

STUDY.flexErpPlot.lines{1,2}.color     = userInput{1,12};
STUDY.flexErpPlot.lines{1,2}.width     = userInput{1,13};
STUDY.flexErpPlot.lines{1,2}.style     = userInput{1,14};
STUDY.flexErpPlot.lines{1,2}.condition = userInput{1,15};
STUDY.flexErpPlot.lines{1,2}.group     = userInput{1,16};
STUDY.flexErpPlot.lines{1,2}.operator  = userInput{1,17};
STUDY.flexErpPlot.lines{1,2}.subCond   = userInput{1,18};
STUDY.flexErpPlot.lines{1,2}.subGroup  = userInput{1,19};

STUDY.flexErpPlot.lines{1,3}.color     = userInput{1,20};
STUDY.flexErpPlot.lines{1,3}.width     = userInput{1,21};
STUDY.flexErpPlot.lines{1,3}.style     = userInput{1,22};
STUDY.flexErpPlot.lines{1,3}.condition = userInput{1,23};
STUDY.flexErpPlot.lines{1,3}.group     = userInput{1,24};
STUDY.flexErpPlot.lines{1,3}.operator  = userInput{1,25};
STUDY.flexErpPlot.lines{1,3}.subCond   = userInput{1,26};
STUDY.flexErpPlot.lines{1,3}.subGroup  = userInput{1,27};

STUDY.flexErpPlot.lines{1,4}.color     = userInput{1,28};
STUDY.flexErpPlot.lines{1,4}.width     = userInput{1,29};
STUDY.flexErpPlot.lines{1,4}.style     = userInput{1,30};
STUDY.flexErpPlot.lines{1,4}.condition = userInput{1,31};
STUDY.flexErpPlot.lines{1,4}.group     = userInput{1,32};
STUDY.flexErpPlot.lines{1,4}.operator  = userInput{1,33};
STUDY.flexErpPlot.lines{1,4}.subCond   = userInput{1,34};
STUDY.flexErpPlot.lines{1,4}.subGroup  = userInput{1,35};

STUDY.flexErpPlot.lines{1,5}.color     = userInput{1,36};
STUDY.flexErpPlot.lines{1,5}.width     = userInput{1,37};
STUDY.flexErpPlot.lines{1,5}.style     = userInput{1,38};
STUDY.flexErpPlot.lines{1,5}.condition = userInput{1,39};
STUDY.flexErpPlot.lines{1,5}.group     = userInput{1,40};
STUDY.flexErpPlot.lines{1,5}.operator  = userInput{1,41};
STUDY.flexErpPlot.lines{1,5}.subCond   = userInput{1,42};
STUDY.flexErpPlot.lines{1,5}.subGroup  = userInput{1,43};

STUDY.flexErpPlot.yAxisLength       = userInput{1,44};
STUDY.flexErpPlot.minorTickInterval = userInput{1,45};
STUDY.flexErpPlot.plotTitle         = userInput{1,46};
STUDY.flexErpPlot.legendString      = userInput{1,47};

%
%%%%%%%%%%%%%%%%%%%%% Line color information %%%%%%%%%%%%%%%%%%%%%
%
% 16 colors names officially supported by W3C specification for HTML
colors{1,1}  = [1 1 1];            % White
colors{2,1}  = [1 1 0];            % Yellow
colors{3,1}  = [1 0 1];            % Fuchsia
colors{4,1}  = [1 0 0];            % Red
colors{5,1}  = [0.75  0.75  0.75]; % Silver
colors{6,1}  = [0.5 0.5 0.5];      % Gray
colors{7,1}  = [0.5 0.5 0];        % Olive
colors{8,1}  = [0.5 0 0.5];        % Purple
colors{9,1}  = [0.5 0 0];          % Maroon
colors{10,1} = [0 1 1];            % Aqua
colors{11,1} = [0 1 0];            % Lime
colors{12,1} = [0 0.5 0.5];        % Teal
colors{13,1} = [0 0.5 0];          % Green
colors{14,1} = [0 0 1];            % Blue
colors{15,1} = [0 0 0.5];          % Navy
colors{16,1} = [0 0 0];            % Black

% create colorIndex
colorIndex = [16 4 14 13 3 11 10 9 7 8 12 15 6];

%%%%%%%%%%%%%%%%%%%%%%
%%% if cluster ERP %%%
%%%%%%%%%%%%%%%%%%%%%%
if STUDY.flexErpPlot.dataType == 1;
   % check if erpdata exists
    tmpClust = str2num(STUDY.flexErpPlot.channel);
    if ~isfield(STUDY.cluster(1,tmpClust), 'erpdata') 
        for n = 2:length(STUDY.cluster)
            STUDY = std_readerp(STUDY, ALLEEG, 'clusters', n);
        end
    end
   % obtain cluster ERP baseline period
    if ~isempty(STUDY.flexErpPlot.baseLine)
        baseLine  = str2num(STUDY.flexErpPlot.baseLine);
        erpTime   = STUDY.cluster(1,tmpClust).erptimes;
        baseStart = find(baseLine(1) < erpTime, 1 );
        baseEnd   = find(erpTime < baseLine(2), 1, 'last' );
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% if backprojected ERP %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
elseif STUDY.flexErpPlot.dataType == 2;
   % obtain backprojected ERP baseline period
    if ~isempty(STUDY.flexErpPlot.baseLine)
        dataRange = STUDY.etc.erpparams.timerange;
        baseLine  = str2num(STUDY.flexErpPlot.baseLine);
        erpTime   = EEG(1,1).times;
        dataStart = find(dataRange(1) <= erpTime, 1 );
        dataEnd   = find(erpTime <= dataRange(2), 1, 'last' );
        baseStart = find(baseLine(1) <= erpTime, 1 );
        baseEnd   = find(erpTime <= baseLine(2), 1, 'last' );
        erpTime   = erpTime(dataStart:dataEnd); % for later use
    end
    
    % search which channel to use
    for n = 1:length(STUDY.backProj.channel)
        tmpChannel = STUDY.flexErpPlot.channel;
        if strcmp(STUDY.backProj.channel{n,1}, tmpChannel)
            tmpChanNum = n;
            break
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%
%%% compute lines %%%
%%%%%%%%%%%%%%%%%%%%%
for n = 1:5
    if STUDY.flexErpPlot.lines{1,n}.color>1 && STUDY.flexErpPlot.lines{1,n}.width>1
        
        if isempty(STUDY.condition{1,1}) % if no within-subject condition
            tmpCond  = STUDY.flexErpPlot.lines{1,n}.condition;
        else                             % if within-subject condition, subtract 1 for the first 'none'.
            tmpCond  = STUDY.flexErpPlot.lines{1,n}.condition-1;
        end
        
        if isempty(STUDY.group{1,1}) % if no within-subject condition
            tmpGroup  = STUDY.flexErpPlot.lines{1,n}.group;
        else                             % if within-subject condition, subtract 1 for the first 'none'.
            tmpGroup  = STUDY.flexErpPlot.lines{1,n}.group-1;
        end        

%%%%%%%%%%%%%%%%%%
%%% main lines %%%
%%%%%%%%%%%%%%%%%%
        if     STUDY.flexErpPlot.dataType == 1;
            % cluster ERP
            tmpERP   = STUDY.cluster(1,tmpClust).erpdata{tmpCond, tmpGroup};
        elseif STUDY.flexErpPlot.dataType == 2;
            % backprojected ERP
                tmpERP   = STUDY.backProj.backProjectedData{tmpCond, tmpGroup};
            if length(STUDY.backProj.channel)  > 1
                tmpERP = squeeze(tmpERP(tmpChanNum,:,:));
            end
         end
        tmpERP   = squeeze(mean(tmpERP, 2));
        
%%%%%%%%%%%%%%%%%%%%%%%%%
%%% subtracting lines %%%
%%%%%%%%%%%%%%%%%%%%%%%%%        
        % subtract the other condition
        if STUDY.flexErpPlot.lines{1,n}.operator>1
            
            if isempty(STUDY.condition{1,1}) % if no within-subject condition
                tmpSubCond  = STUDY.flexErpPlot.lines{1,n}.subCond;
            else                             % if within-subject condition, subtract 1 for the first 'none'.
                tmpSubCond  = STUDY.flexErpPlot.lines{1,n}.subCond-1;
            end
            
            if isempty(STUDY.group{1,1}) % if no within-subject condition
                tmpSubGroup  = STUDY.flexErpPlot.lines{1,n}.subGroup;
            else                             % if within-subject condition, subtract 1 for the first 'none'.
                tmpSubGroup  = STUDY.flexErpPlot.lines{1,n}.subGroup-1;
            end
            
            if     STUDY.flexErpPlot.dataType == 1;
                % cluster ERP
                tmpSubERP   = STUDY.cluster(1,tmpClust).erpdata{tmpSubCond, tmpSubGroup};
            elseif STUDY.flexErpPlot.dataType == 2;
                % backprojected ERP
                    tmpSubERP = STUDY.backProj.backProjectedData{tmpSubCond, tmpSubGroup};
                if length(STUDY.backProj.channel)  > 1
                    tmpSubERP = squeeze(tmpSubERP(tmpChanNum,:,:));
                end
            end
            tmpSubERP   = squeeze(mean(tmpSubERP, 2));
            
            if      STUDY.flexErpPlot.lines{1,n}.operator == 2
                tmpERP = tmpERP - tmpSubERP;
            elseif  STUDY.flexErpPlot.lines{1,n}.operator == 3
                tmpERP = tmpERP + tmpSubERP;
            end
        end
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% processing for plotting %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             
        % low-pass filter if requested
        if ~isempty(STUDY.etc.erpparams.filter)
           tmpFiltData.data   = tmpERP';
           tmpFiltData.srate  = EEG(1,1).srate;
           tmpFiltData.trials = 1;
           tmpFiltData.event  = [];
           tmpFiltData.pnts   = length(tmpERP);
           filtorder = pop_firwsord('hamming', EEG(1,1).srate, STUDY.etc.erpparams.filter);
           tmpFiltData_done   = pop_eegfiltnew(tmpFiltData, 0, STUDY.etc.erpparams.filter, filtorder);
           % tmpFiltData_done   = pop_eegfiltnew(tmpFiltData, 0, STUDY.etc.erpparams.filter);
           tmpERP             = tmpFiltData_done.data';
        end
        
        % baseline correction
        tmpERP   = tmpERP - mean(tmpERP(baseStart:baseEnd));

        % if backprojected ERP, limit data range
        if STUDY.flexErpPlot.dataType == 2;
            tmpERP = tmpERP(dataStart:dataEnd);
        end

        % final output
        plotLines{1,n} = tmpERP;
    else
        % empty output
        plotLines{1,n} = [];
    end
end

%%%%%%%%%%%%%%%%%%%%%%
%%% Plot all lines %%%
%%%%%%%%%%%%%%%%%%%%%%
figure
for n = 1:5;
    if ~isempty(plotLines{1,n})
        
        % decode lineStyle
        if     STUDY.flexErpPlot.lines{1,n}.style == 2
            lineStyle = '-';
        elseif STUDY.flexErpPlot.lines{1,n}.style == 3
            lineStyle = '--';
        elseif STUDY.flexErpPlot.lines{1,n}.style == 4
            lineStyle = ':';        
        elseif STUDY.flexErpPlot.lines{1,n}.style == 5
            lineStyle = '-.';
        end
        plot(erpTime, plotLines{1,n}, 'Color', colors{colorIndex(STUDY.flexErpPlot.lines{1,n}.color-1),1}, 'LineWidth', (STUDY.flexErpPlot.lines{1,n}.width-1)*0.5, 'LineStyle', lineStyle)
        hold on
    end
end

% adjust yaxis height
if ~isempty(STUDY.etc.erpparams.ylim)
    set(gca, 'ylim', [STUDY.etc.erpparams.ylim(1) STUDY.etc.erpparams.ylim(2)]);
end

% Plot title
annotation('textbox', [0 0.93 1 0.06], 'String', STUDY.flexErpPlot.plotTitle,...
    'HorizontalAlignment','center', 'FontSize', 20, 'FontName','Arial',...
    'FitBoxToText','off', 'LineStyle','none')

% Legend
legendHandle = legend(eval(STUDY.flexErpPlot.legendString));
set(legendHandle, 'FontSize', 16, 'FontName','Arial');

%%%%%%%%%%%%%%%%%
%%% edit axis %%%
%%%%%%%%%%%%%%%%%
yAxisLength       = str2num(STUDY.flexErpPlot.yAxisLength);
minorTickInterval = str2num(STUDY.flexErpPlot.minorTickInterval);

set(gcf, 'Color',[1 1 1], 'Name', 'std_FlexibleErpPlot()', 'numbertitle','off')

% yaxis
line([0 0], [-yAxisLength yAxisLength], 'Color', [0 0 0])

% xaxis
line([erpTime(1) erpTime(end)], [0 0], 'Color', [0 0 0])
minorTickPosi    = 0:minorTickInterval:erpTime(end);
minorTickNega    = 0:-minorTickInterval:erpTime(1);
minorTickLatency = sort(nonzeros(unique([minorTickNega minorTickPosi])));
for n = 1:length(minorTickLatency)
    line([minorTickLatency(n) minorTickLatency(n)], [-yAxisLength/20 yAxisLength/20], 'Color', [0 0 0])
end
set(gca, 'Visible','off')
% set(gca, 'Visible','on')
% set(gca, 'Box', 'off')
% set(gca, 'YColor',[1 1 1], 'XColor',[1 1 1])
% set(get(gca,'XLabel'), 'String', 'Latency (ms)', 'Color', [0 0 0], 'FontSize', 16, 'FontName', 'Ariel')
% set(get(gca,'YLabel'), 'String', 'Amplitude ($\mu$V)','interpreter','latex', 'Color', [0 0 0], 'FontSize', 16, 'FontName', 'Ariel')