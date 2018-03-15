% m_rp_info.m is used as part of the Bergen EEG&fMRI Toolbox plugin for 
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

function [motiondata_struct,weighting_matrix] = m_rp_info(rp_file,n_fmri,threshold,k)
% Code to generate weighting matrices for artifact correction with the
% Realignment Parameter informed (rp-info) algorithm (Moosmann et al. Neuroimage 2009)
% rp_file   - realignment parameter file from SPM (*.txt file)
% n_fmri    - number of fMRI scans recorded (neded to respect dummy scans excluded before SPM realignment procedure)
% threshold - threshold of movement in mm
% k         - number of artifacts that constitute the templates (typical k=25)
% e.g. weighting_matrix=m_rp_info('rp_example#001.txt',0.8,25)
%
motiondata=m_single_motion(load(rp_file),threshold,0);
motiondata.both_not_normed=[zeros(1,length(load(rp_file))-length(motiondata.both_not_normed)) motiondata.both_not_normed];

n_data=length(motiondata.both_not_normed);      % length of motion data

% Respect Dummy scans excluded before SPM realignemnt
diff_n=n_fmri-n_data; % 
motiondata.both_not_normed =[zeros(1,diff_n),motiondata.both_not_normed];

if max(motiondata.both_not_normed)>0,
    slid_win=zeros(n_fmri,k);                       % init sliding slid_win output
    distance=zeros(1,n_fmri);                         % init linear weights
    for jslide=1:n_fmri                             % 'center' of sliding slid_win

        distance(1:jslide)=jslide:-1:1;             % generate (linear) distance ->
        distance(jslide+1:end)=2:+1:n_fmri-jslide+1;  % triangular plot with smallest values around jslide
        % picking k samples with the smallest distance would now result in standard sliding average
        % next, the motion data is added to this linear distance

        % this block integrates motion data into the weighting
        % for standard moving average it simply has to be skipped
        motion_scaling=k/min(motiondata.both_not_normed(motiondata.both_not_normed>0)); % scales impact of motion on distance
        distance=distance+motion_scaling*cumsum([-motiondata.both_not_normed(1:jslide) +motiondata.both_not_normed(jslide+1:end)]); % distance+motion
        distance(find(motiondata.both_not_normed))=NaN;  % exclude samples with motion above threshold
        distance=distance-min(distance);            % just for cosmetical reasons, can be omitted

        [sort_weight,sort_order]=sort(distance);    % order sample by distance
        slid_win(jslide,:)=sort_order(1:k);         % set sliding slid_win to smallest distance values
    end
    % Create Weighting Matrix
    weighting_matrix=zeros(n_fmri);
    for j=1:n_fmri,weighting_matrix(j,slid_win(j,:))=1;end
else
    weighting_matrix=m_moving_average(n_fmri,k);
end

motiondata_struct = motiondata;



% Create figure
% figure;
% subplot(3,1,1);
% plot(motiondata.both_not_normed,'k')
% xlim([0 n_fmri])
% subplot(3,1,[2,3]);
% imagesc(weighting_matrix)
% colormap(gray)