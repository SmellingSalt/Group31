% m_moving_average.m is used as part of the Bergen EEG&fMRI Toolbox 
% plugin for EEGLAB. 
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

function weighting_matrix=m_moving_average(n_fmri,k)
% Code to generate weighting matrices for artifact correction with the
% moving average algorithm (Allen et al. Neuroimage 2000)
% n_fmri   - number of fMRI volumes recorded
% k        - number of artifacts that constitute the templates (typical k=25)
%
slid_win=zeros(n_fmri,k);                       % init sliding slid_win output
distance=zeros(1,n_fmri);                         % init linear weights
for jslide=1:n_fmri                             % 'center' of sliding slid_win

    distance(1:jslide)=jslide:-1:1;             % generate (linear) distance ->
    distance(jslide+1:end)=2:+1:n_fmri-jslide+1;  % triangular plot with smallest values around jslide
    % picking k samples with the smallest distance would now result in standard sliding average
    % next, the motion data is added to this linear distance
      [sort_weight,sort_order]=sort(distance);    % order sample by distance
    slid_win(jslide,:)=sort_order(1:k);         % set sliding slid_win to smallest distance values

end

% Create Weighting Matrix
weighting_matrix=zeros(n_fmri);
for j=1:n_fmri
    weighting_matrix(j,slid_win(j,:))=1;
end

