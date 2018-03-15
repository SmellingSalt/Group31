% gevd()     - Determine optimal components to discriminate
%              between two datasets using generalized eigenvalue
%              decomposition (GEVD)
%
% Usage:
%   >> [W] = gevd(dataset_1,dataset_2,zeromean,normcov)
%
%   Inputs:
%       dataset_1          - EEG data for first class
%                             [channels x samples x epochs] or
%                             [channels x samples]
%       dataset_2          - EEG data for second class
%			     PCA performed if empty
%       zeromean           - [0|1] -> 1 indicates that the mean is 
%                            subtracted from each trial before computing 
%                            the covariance matrices.
%       normcov            - [0|1] -> 1 indicated that normalized covariances 
%			     are used for each class as well.
%
%			     The zeromean and normcov operations are suggested
%			     by Ramoser, et. al for Common Spatial Patterns
%                            zeromean=1 and normcov=1 by default
%                            
%   Outputs:
%       W                  - Discriminating eigenvectors
%                               corresponding eigenvalues are sorted
%                               in descending order
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

function W=gevd(dataset_1,dataset_2,zeromean,normcov)

% Zeromean each trial and use normalized covariance matrix as used by Ramoser
if nargin<3|isempty(zeromean), zeromean=1; end
if nargin<4|isempty(normcov), normcov=1; end

N(1)=size(dataset_1,3);

if ~isempty(dataset_2),
  N(2)=size(dataset_2,3);
  PCA=0;
else
  PCA=1;
end

if ~zeromean,

    Rxx1=cov(dataset_1(:,:)');
    if ~PCA,
        Rxx2=cov(dataset_2(:,:)');
    else
	Rxx2=eye(size(Rxx1));
    end

else

    for i=1:(1+~PCA),
        if i==1, data=dataset_1; else data=dataset_2; end
        for trial=1:N(i),
            E=squeeze(data(:,:,trial)); % channels x samples
            [chans,T]=size(E);

            if zeromean, E=E-repmat(mean(E,2),[1 T]); end

            tmpC = (E*E');
	    if normcov,
                C{i}(:,:,trial) = tmpC./trace(tmpC);
	    else
		C{i}(:,:,trial) = tmpC;
            end
        end % trial
	if normcov,
           Cmean{i}=mean(C{i},3);
        else
	   Cmean{i}=sum(C{i},3);
        end
    end % i

    if ~PCA,
        Rxx1=Cmean{1};
	Rxx2=Cmean{2};
    else
        Rxx2=Cmean{1};
	Rxx1=eye(size(Rxx2));
    end

end

% Find the directions with maximum/minimum power ratio
[W,D]=eig(Rxx2,Rxx1);

for i=1:size(W,2)
    W(:,i)=W(:,i)/norm(W(:,i));
end;

% Keep only positive eigenvalues
d = diag(D);
W = W(:,find(d>0));
d = d(find(d>0));

% Sort by decreasing eigenvalues-ratio
[d,indx] = sort(d,'descend');
W = W(:,indx);
