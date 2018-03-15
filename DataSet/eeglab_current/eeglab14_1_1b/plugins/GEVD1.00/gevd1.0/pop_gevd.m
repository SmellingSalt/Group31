% pop_gevd() - Determine optimal components to discriminate
%              between two datasets using generalized eigenvalue
%              decomposition (GEVD)
%
% Usage:
%   >> [ALLEEG, W]=pop_gevd(ALLEEG, datasetlist, chansubset, ...
%                  chansubset2,trainingwindowlength, trainingwindowoffset, ...
%		   zeromean, normcov)
%
%   Inputs:
%       ALLEEG               - array of datasets
%       datasetlist          - list of datasets
%			       PCA performed if only one set is listed
%       chansubset           - vector of channel subset for dataset 1          [1:min(Dset1,Dset2)]
%       chansubset2          - vector of channel subset for dataset 2          [chansubset]
%       trainingwindowlength - Length of training window in samples            [all]
%       trainingwindowoffset - Offset(s) of training window(s) in samples      [1]
%       zeromean           - [0|1] -> 1 indicates that the mean is
%                            subtracted from each trial before computing
%                            the covariance matrices.
%       normcov            - [0|1] -> 1 indicated that normalized covariances
%                            are used for each class as well.
%
%                            The zeromean and normcov operations are suggested
%                            by Ramoser, et. al for Common Spatial Patterns
%                            zeromean=1 and normcov=1 by default
%
%  Outputs:
%       ALLEEG               - array of datasets
%       W                    - Discriminating eigenvectors
%                                corresponding eigenvalues are sorted
%                                in descending order
%
% Reference:
%       @article{parra2005,
%       author = {Lucas C. Parra and Clay D. Spence and Adam Gerson 
%                and Paul Sajda},
%       title = {Recipes for the Linear Analysis of {EEG}},
%       journal = {{NeuroImage}},
%       year = {in revision}}
%
% Authors: Xiang Zhou (zhxapple@hotmail.com, 2005)
%          with Adam Gerson (adg71@columbia.edu, 2005),
%          and Lucas Parra (parra@ccny.cuny.edu, 2005),
%          and Paul Sajda (ps629@columbia,edu 2005)

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) 2005 Xiang Zhou, Adam Gerson, Lucas Parra and Paul Sajda
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

function [ALLEEG, W]=pop_gevd(ALLEEG, setlist, chansubset, chansubset2, trainingwindowlength, trainingwindowoffset, zeromean, normcov)

if nargin < 1
    help pop_gevd;
    return;
end;   
if isempty(ALLEEG)
    error('pop_gevd(): cannot process empty sets of data');
end
if nargin < 2
    % which set to save
    
    uilist = { { 'style' 'text' 'string' 'Enter two datasets to compare (ex: 1 3):' } ...
        { 'style' 'edit' 'string' [ '1 2' ] } ...
        { 'style' 'text' 'string' 'Enter channel subset ([] = all):' } ...
        { 'style' 'edit' 'string' '' } ...
        { 'style' 'text' 'string' 'Enter channel subset for dataset 2 ([] = same as dataset 1):' } ...
        { 'style' 'edit' 'string' '' } ...
        { 'style' 'text' 'string' 'Training Window Length (samples [] = all):' } ...
        { 'style' 'edit' 'string' '' } ...
        { 'style' 'text' 'string' 'Training Window Offset (samples, 1 = epoch start):' } ...
        { 'style' 'edit' 'string' '1' } ...
        { 'style' 'text' 'string' 'Zeromean each epoch:' } ...
        {} { 'style' 'checkbox' 'string' '' 'value' 1 } {} ...
        { 'style' 'text' 'string' 'Use normalized covariances:' } ...
        {} { 'style' 'checkbox' 'string' '' 'value' 1 } {} ...
	{} ...
	{ 'style' 'text' 'string' 'NOTE: Data should be filtered to passband of interest before finding components.' }
        };

    result = inputgui( { [80 20] [80 20] [80 20] [80 20] [80 20] [80 6.25 7.5 6.25] [80 6.25 7.5 6.25] [1] [1]}, ...
        uilist, 'pophelp(''pop_gevd'')', ...
        'Generalized Eigenvalue Decomposition -- pop_gevd()');               

    if length(result) == 0 return; end;
    setlist   	 = eval( [ '[' result{1} ']' ] );
    chansubset   = eval( [ '[' result{2} ']' ] );
    if isempty( chansubset ), chansubset = 1:ALLEEG(setlist(1)).nbchan; end;
    
    chansubset2  = eval( [ '[' result{3} ']' ] );
    if isempty(chansubset2), chansubset2=chansubset; end
    
    trainingwindowlength = str2num(result{4});
    if isempty(trainingwindowlength)
        trainingwindowlength = ALLEEG(setlist(1)).pnts;
    end;
    trainingwindowoffset = str2num(result{5});
    if isempty(trainingwindowoffset)
        trainingwindowoffset = 1;
    end;
    zeromean = result{6};
    if isempty(zeromean)
        zeromean = 1;
    end;
    normcov = result{7};
    if isempty(normcov)
        normcov = 1;
    end;
end;

try, icadefs; catch, end;

if max(trainingwindowlength+trainingwindowoffset-1)>ALLEEG(setlist(1)).pnts,
    error('pop_gevd(): training window exceeds length of dataset 1');
end
if length(setlist)==2,
  if max(trainingwindowlength+trainingwindowoffset-1)>ALLEEG(setlist(2)).pnts,
    error('pop_gevd(): training window exceeds length of dataset 2');
  end

  if (length(chansubset)~=length(chansubset2)),
    error('Number of channels from each dataset must be equal.');
  end

  chansubset = 1:min(ALLEEG(setlist(1)).nbchan,ALLEEG(setlist(2)).nbchan);
  chansubset2=chansubset;
end

%%% GEVD %%%
fprintf('Generalized eigenvalue decomposition (GEVD)...');
if length(setlist)==2,
W = gevd( ...
    ALLEEG(setlist(1)).data(chansubset,trainingwindowoffset:trainingwindowoffset+trainingwindowlength-1,:), ...
    ALLEEG(setlist(2)).data(chansubset,trainingwindowoffset:trainingwindowoffset+trainingwindowlength-1,:), ...
    zeromean,normcov);
else
W = gevd( ...
    ALLEEG(setlist(1)).data(chansubset,trainingwindowoffset:trainingwindowoffset+trainingwindowlength-1,:), ...
    [],zeromean,normcov);
end

if rank(W)==size(W,1)
    A=inv(W');
else
    A=R*W*pinv(W'*R*W); % This is not implemented yet - must define R
end;

for i=1:length(setlist),
    ALLEEG(setlist(i)).icaweights=zeros(ALLEEG(setlist(i)).nbchan);
    
    % In case a subset of channels are used, assign unused electrodes in scalp projection to NaN
    ALLEEG(setlist(i)).icawinv=nan.*ones(ALLEEG(setlist(i)).nbchan);
    ALLEEG(setlist(i)).icasphere=eye(ALLEEG(setlist(i)).nbchan);
end

ALLEEG(setlist(1)).icaweights(chansubset,chansubset)=W';
ALLEEG(setlist(1)).icawinv(chansubset,chansubset)=A; 


if length(setlist)==2,
  ALLEEG(setlist(2)).icaweights(chansubset2,chansubset2)=W';
  ALLEEG(setlist(2)).icawinv(chansubset2,chansubset2)=A; 
end

eeg_options; 
for i=1:length(setlist),
    if option_computeica
        ALLEEG(setlist(i)).icaact    = (ALLEEG(setlist(i)).icaweights*ALLEEG(setlist(i)).icasphere)*reshape(ALLEEG(setlist(i)).data, ALLEEG(setlist(i)).nbchan, ALLEEG(setlist(i)).trials*ALLEEG(setlist(i)).pnts);
        ALLEEG(setlist(i)).icaact    = reshape( ALLEEG(setlist(i)).icaact, size(ALLEEG(setlist(i)).icaact,1), ALLEEG(setlist(i)).pnts, ALLEEG(setlist(i)).trials);
    end;
end

for i=1:length(setlist), [ALLEEG]=eeg_store(ALLEEG,ALLEEG(setlist(i)),setlist(i)); end

fprintf('Done.\n');
