% clustat_meandev() - Given a STUDY and clust_stat structures return the mean
% and standard deviation of each measure in each cluster. Use all the
% measures that had been used before for clustering.
%
%
% Usage:
%   >>  clust_stat =  cls_meandev(STUDY,clust_stat)
%
%
% Inputs:
%    STUDY             - studyset structure containing some or all files in ALLEEG
%    parentcluster    - Parentcluster to analyze.
%    clust_stat        - Structure with one substructure for each cluster under
%                        the parentcluster. Each substructure have the following info:
%                        cluster's name
%                        And then a paired info of Subject/dataset name, IC's,
%                        1st, 2nd, 3th.. independent variables.
%
% Outputs:
%
% See also:
%
%
% Author: % Ramon Martinez-Cancino, SCCN, INC, UCSD
%
% Copyright (C) 2014  Ramon Martinez-Cancino, SCCN, INC, UCSD
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
function clust_stat =  std_clustat(STUDY,parentcluster,varargin)

if nargin < 2
    help clustat_meandev;
    return;
end;

if ~isempty(varargin) && strcmp(varargin{1},'cls_stat')
    clustinfo = varargin{2};
else
    % Getting cluster fact matrix
    [clustinfo,tmp] = parse_clustinfo(STUDY,parentcluster);
end
clustinfo  = clustinfo.clust;

% % Finding Parentcluster and childs
% hits_temp     = cellfun(@(x)strcmp(x,parentcluster),{STUDY.cluster.name});
% parent_indx   = find(hits_temp);
% cls_childs = [STUDY.cluster(1).child];


% Preparing input
if ~isfield(STUDY.etc, 'preclust') && ~isfield(STUDY.etc.preclust, 'preclustparams') && isempty(STUDY.etc.preclust.preclustparams)
    error('Not enough information provided in STUDY structure');
end
%--------------------------------------------------------------------------
% Loop per measure used in preclustering
for imeasure = 1:length(STUDY.etc.preclust.preclustparams);

    strcom = STUDY.etc.preclust.preclustparams{imeasure}{1};
    
    %defult values
    freqrange  = [];
    timewindow = [];
    abso = 1;
    fun_arg = [];
    
    % scan datasets
    % -------------
    if strcmpi(strcom, 'scalp')
        scalpmodif = 'none';
    end;
    % Loop per clusters
    for cls = 1 : length(clustinfo)
            
%         filename = {clustinfo(cls).datasetinfo{1}.filename};
%         pathfile = {clustinfo(cls).datasetinfo{1}.filepath};
%         
%         for i = 1: length({clustinfo(cls).datasetinfo{1}.filename})
%             if any([strcmp(strcom,'erp'),strcmp(strcom,'spec'),strcmp(strcom,'ersp'),strcmp(strcom,'itc')])
%                 [tmp,filetmp,tmp] = fileparts(filename{i});
%                 file2read(i).filebase = [pathfile{i} filesep filetmp];
%                 
%             elseif strcmp(strcom,'scalp')
%                 file2read(i).filepath  = pathfile{i};
%                 file2read(i).filename  = filename{i};
%             end
%         end
        
        % Retreiving datasets (long story while using cell.design)
        % Getting ICs
        clsindx = find(strcmp(clustinfo(cls).name,{STUDY.cluster.name}));
        tmpval = cell2mat(STUDY.cluster(clsindx).allinds)';
        clustinfo(cls).ics = tmpval(:)'; clear tmpval;
        
        % getting sets
        tmpval = cell2mat(STUDY.cluster(clsindx).setinds)';
        cellinds = tmpval(:)'; clear tmpval;
        file2read_tmp = {STUDY.design(STUDY.currentdesign).cell(cellinds).filebase}';
        
        if any([strcmp(strcom,'erp'),strcmp(strcom,'spec'),strcmp(strcom,'ersp'),strcmp(strcom,'itc')])
            file2read = cell2struct(file2read_tmp,'filebase',size(file2read_tmp,1));     
        elseif strcmp(strcom,'scalp')
            for  i = 1: size(file2read_tmp,1)
                [filepath, filename, tmp] = fileparts(file2read_tmp{i});clear tmp;
                file2read(i).filepath  = filepath;
                file2read(i).filename  = filename;
            end
        end
        clear file2read_tmp setinds clsindx;
         
        switch strcom
            
            % select ica component ERPs
            % -------------------------
            case 'erp'
                X = std_readfile(file2read, 'components', clustinfo(cls).ics, 'timelimits', timewindow, 'measure', 'erp');
                X = abs(X);
                
                % select ica scalp maps
                % --------------------------
            case 'scalp'
                
                for isets = 1:length(file2read)
                    X(:,isets) = std_readtopo(file2read(isets),1, clustinfo(cls).ics(isets), scalpmodif, 'preclust');
                end
                
                % select ica comp spectra
                % -----------------------
            case 'spec'
                X = std_readfile( file2read, 'components', clustinfo(cls).ics, 'freqlimits', freqrange, 'measure', 'spec');
                if size(X,2) > 1, X = X - repmat(mean(X,2), [1 size(X,2)]); end;
                X = X - repmat(mean(X,1), [size(X,1) 1]);
                
                % select dipole information
                % -------------------------
            case 'dipoles'
                %                 idat  = STUDY.datasetinfo(STUDY.cluster(cluster_ind).sets(1,si)).imeasure;
                %                 icomp = STUDY.cluster(cluster_ind).comps(si);
                %                 fprintf('Creating input array for Affinity Propagation Clustering row %d, adding dipole for dataset %d component %d...\n', si, idat, icomp);
                %                 try
                %                     % select among 3 sub-options
                %                     % --------------------------
                %                     ldip = 1;
                %                     if size(ALLEEG(idat).dipfit.model(icomp).posxyz,1) == 2 % two dipoles model
                %                         if any(ALLEEG(idat).dipfit.model(icomp).posxyz(1,:)) ...
                %                                 && any(ALLEEG(idat).dipfit.model(icomp).posxyz(2,:)) %both dipoles exist
                %                             % find the leftmost dipole
                %                             [garb ldip] = max(ALLEEG(idat).dipfit.model(icomp).posxyz(:,2));
                %                         elseif any(ALLEEG(idat).dipfit.model(icomp).posxyz(2,:))
                %                             ldip = 2; % the leftmost dipole is the only one that exists
                %                         end
                %                     end
                %                     X = ALLEEG(idat).dipfit.model(icomp).posxyz(ldip,:);
                %                 catch
                %                     error([ sprintf('Some dipole information is missing (e.g. component %d of dataset %d)', icomp, idat) 10 ...
                %                         'Components are not assigned a dipole if residual variance is too high so' 10 ...
                %                         'in the STUDY info editor, remember to select component by residual' 10 ...
                % %                         'variance (column "select by r.v.") prior to preclustering them.' ]);
                %                 end
                
                % cluster on ica ersp / itc values
                % --------------------------------
            case  {'ersp', 'itc' }
                
                X = std_readfile( file2read, 'components', clustinfo(cls).ics, 'timelimits', timewindow, 'freqlimits', freqrange, 'measure', strcom);
        end;
        
        % Storing data
        switch strcom
            case {'erp','spec', 'scalp'}
                cls_stat.(strcom)(cls).mean = mean(X,2);
                cls_stat.(strcom)(cls).std  = std(X,0,2);
                
                % Getting the distance matrix
                S = squareform(pdist([cls_stat.(strcom)(cls).mean X]','euclidean'));
                cls_stat.(strcom)(cls).centroid_distsum   = sum(S(1,2:end));
                cls_stat.(strcom)(cls).centroid_distmean  = mean(S(1,2:end));
                cls_stat.(strcom)(cls).centroid_diststd   = std(S(1,2:end));
                
            case {'ersp','itc'}
                if ~isreal(X) X = abs(X); end; % for ITC data
                cls_stat.(strcom)(cls).mean = mean(X,3);
                cls_stat.(strcom)(cls).std  = std(X,0,3);
                
                % Getting the distance matrix
                valtmp = cat(3,X,cls_stat.(strcom)(cls).mean);
                valtmp = reshape(valtmp,[size(valtmp,1)*size(valtmp,2),size(valtmp,3)]);
                
                S = squareform(pdist(valtmp','euclidean'));
                cls_stat.(strcom)(cls).centroid_distsum   = sum(S(1,2:end));
                cls_stat.(strcom)(cls).centroid_distmean  = mean(S(1,2:end));
                cls_stat.(strcom)(cls).centroid_diststd   = std(S(1,2:end));
                
            case 'dipoles'
                %                 apdata.dipoles = data;
                
        end
        clear S X file2read filetmp;
    end
end

clust_stat.clust = clustinfo;
clust_stat.stats = cls_stat;
