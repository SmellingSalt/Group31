% euclidian.m is used as part of the Bergen EEG&fMRI Toolbox plugin for 
% EEGLAB.
% 
% Copyright (C) 2009 The Bergen fMRI Group
% 
% Bergen fMRI Group, Department of Biological and Medical Psychology,
% University of Bergen, Norway
% 
% Written by Matthias Moosmann, 2009
% moosmann@gmail.com
% 
% Last Modified on 18-Jun-2009 08:07:11

% function euclidian(input_vectors)
% calculates euclidian length of 
% vectors(=columns) in a matrix
function length_vecs=euclidian(input_vecs)
num_vecs=size(input_vecs,1);
length_vecs=zeros(1,num_vecs);
for i=1:num_vecs
    length_vecs(i)=norm(input_vecs(i,:));
end