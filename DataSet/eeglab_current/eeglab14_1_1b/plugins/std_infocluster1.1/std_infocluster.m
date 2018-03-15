% std_infocluster() - sumarize relation of Cluster Vs Subject/Dataset Vs IC
%
% Usage:
%   >>  clustinfo = std_infocluster(STUDY, ALLEEG);
%
% Inputs:
%      STUDY    - studyset structure containing some or all files in ALLEEG
%      ALLEEG   - vector of loaded EEG datasets
%
% Optional inputs:
%
%
% parentcluster    - Parentcluster to analyze. By default the 1st Parentcluster
% keepsession      - Keep original session info [0,1]. Default 1
% plotinfo         - Plot Cluster Vs Subject/Dataset Vs No of IC [0,1]. Default 1
% csvsave          - Save as CSV [0,1]. Default 0
% verbose          - [0,1] Default 1
% calc             - NOT used right now, but for future purposes
% figlabel         - [0/1] 1 to chow "ICs" in the label's cell, otherwise does
%                    not show the label. Default 1
%
%
% Outputs:
%    clustinfo  - Structure with one substructure for each cluster under
%    the parentcluster. Each substructure have the following info:
%               cluster's name
%               And then a paired info of Subject/dataset name, IC's,
%               1st and 2nd independet variables.
%
% See also:
%   std_plotinfocluster
%
% Author: Ramon Martinez-Cancino, SCCN, 2014
%
% Copyright (C) 2014  Ramon Martinez-Cancino,INC, SCCN
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

function [STUDY , clust_statout] = std_infocluster(STUDY, ALLEEG, varargin)

% Checking entries
if nargin < 2
    help std_infocluster;
    return;
end

clust_statout  = [];
clust_stat     = [];
try
    options = varargin;
    if ~isempty( varargin ),
        for i = 1:2:numel(options)
            g.(options{i}) = options{i+1};
        end
    else g= []; end;
catch
    disp('std_infocluster() error: calling convention {''key'', value, ... } error'); return;
end;

try g.parentcluster;     catch, g.parentcluster   = STUDY.cluster(1).name;          end; % By default the 1st cluster
try g.keepsession;       catch, g.keepsession     = 1;                              end; % Keep original session info
try g.plotinfo;          catch, g.plotinfo        = 1;                              end; % Plot by default
try g.csvsave;           catch, g.csvsave         = 0;                              end; % Save as CSV
try g.savepath;          catch, g.savepath        = STUDY.filepath;                 end; % Path to save
try g.filename;          catch, g.filename        = STUDY.name;                     end; % Path to save
try g.verbose;           catch, g.verbose         = 1;                              end; % verbose
try g.calc;              catch, g.calc            = 1;                              end; % Choose what to calc
try g.figlabel;          catch, g.figlabel        = 1;                              end; % Show labels in fig
try g.handles;           catch, g.handles         = '';                             end; % Just for calls from GUIs

% Checking for session field
OrigSession = {STUDY.datasetinfo.session};                     % Backing up session info
IsSession = ~(cellfun(@isempty, {STUDY.datasetinfo.session}));

if sum(IsSession) ~= length(IsSession)
    STUDY = std_checkdatasession(STUDY, ALLEEG, 'verbose', g.verbose);
end
if isempty(g.handles)  || isempty(getappdata(g.handles.mainfig,'clust_statout')) || isempty(getappdata(g.handles.mainfig,'SubjClusIC_Matrix'))
    %Parsing info from clusters and doing some stats
    [clust_stat,SubjClusIC_Matrix] = parse_clustinfo(STUDY,g.parentcluster);
    clust_stat                     = std_clustat(STUDY,g.parentcluster,'cls_stat',clust_stat);
    
    if ~isempty(g.handles)
        setappdata(g.handles.mainfig,'clust_statout',clust_stat);
        setappdata(g.handles.mainfig,'SubjClusIC_Matrix',SubjClusIC_Matrix);
    end
else
    clust_stat        = getappdata(g.handles.mainfig,'clust_statout');
    SubjClusIC_Matrix = getappdata(g.handles.mainfig,'SubjClusIC_Matrix');
end

% Plots
%..........................................................................
if (g.plotinfo == 1)
    switch g.calc
        case 1
            % 1 - IC Vs Subj Vs Cluster (that is why infloclust3d)
            [mat2plot, UniqSubjInd] = std_plotinfocluster(STUDY,SubjClusIC_Matrix,g.parentcluster,'plot',g.plotinfo,'figlabel',g.figlabel);
            
        case 2
            % 2 -Compactnes of clusters 
            std_plotclsmeasure(STUDY,g.parentcluster,clust_stat.stats,g.calc-1);   
    end
end
%..........................................................................

% Restitute original session values
%..........................................................................
if g.keepsession
    if sum(IsSession)==0
        [STUDY.datasetinfo.session] = deal('');
    else
        for i = 1:length(STUDY.datasetinfo)
            STUDY.datasetinfo(i).session = OrigSession{i};
        end
    end
end
%..........................................................................

% Save csv files
%..........................................................................
if g.csvsave
    
    % 1) text file output of the Number of ICs in Cluster x Subjects matrix
    filename_out1 = [g.savepath filesep g.filename '_IC_Subj.txt'];
    
    ColHeader    =  {clust_stat.clust.name};
    headers    =  {STUDY.datasetinfo(UniqSubjInd).subject};
    header_string = '';
    
    for i = 1:length(headers)
        header_string = [header_string,',',headers{i}];
    end
    
    % Write the Header to a file
    fid = fopen(filename_out1,'w');
    fprintf(fid,'%s\r\n',header_string);
    fclose(fid);
    
    % Write the name of the vars to a file
    for i = 1: size(mat2plot,1)
        data2print = ColHeader{i};
        for j = 1 : size(mat2plot,2)
            data2print = [data2print, ',' , num2str(mat2plot(i,j))];
        end
        fid = fopen(filename_out1,'a');
        fprintf(fid,'%s\r\n',data2print);
        fclose(fid);
    end
     if g.verbose, display(['File successfully saved: ' filename_out1]); end;
        
    % 2) text file output of the Cluster, Number of ICs, and  Number of Unique subjects in separate columns.
    
    filename_out2 = [g.savepath filesep g.filename '_unique_ICs_Subj.txt'];
    
    for i = 1 : length({clust_stat.clust.name})
        Mat2Save2(i,1) = length(unique([clust_stat.clust(i).subj]));
        Mat2Save2(i,2) = length([clust_stat.clust(i).ics]) ; 
    end
    
    headers    =  {'No.ICs', 'No.Sub/Dset'};
    
        header_string = '';
    
    for i = 1:length(headers)
        header_string = [header_string,',',headers{i}];
    end
    
     % Write the Header to a file
    fid = fopen(filename_out2,'w');
    fprintf(fid,'%s\r\n',header_string);
    fclose(fid);
    
    for i = 1: size(Mat2Save2,1)
        data2print = ColHeader{i};
        for j = 1 : size(Mat2Save2,2)
            data2print = [data2print, ',' , num2str(Mat2Save2(i,j))];
        end
        fid = fopen(filename_out2,'a');
        fprintf(fid,'%s\r\n',data2print);
        fclose(fid);
    end
    if g.verbose, display(['File successfully saved: ' filename_out2 ]); end;
end

%..........................................................................
if isfield(clust_stat,'clust') && isfield(clust_stat,'stats')
    clust_statout = clust_stat;
end
