% m_single_motion.m is used as part of the Bergen EEG&fMRI Toolbox 
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

% threshold and weight motion data into single var
function motiondata=single_motion(transrotdata,p_slomo_threshold,p_trans_rot_scale)
% p_trans_rot_scale=100;                   % scale factor trans vs rot motion
% p_slomo_threshold=5;                      %  threshold for motion signal
                                % (value relative to median)
%fprintf('single_motion: process fMRI motion signal\n');
motiondata.trans=euclidian(diff(transrotdata(:,1:3))); % translat speed
motiondata.rot=euclidian(diff(transrotdata(:,4:6)))*180/pi;   % rotat speed

motiondata.thres_trans=p_slomo_threshold;
motiondata.thres_rot=p_slomo_threshold;

motiondata.trans_t=motiondata.trans.*(motiondata.trans>motiondata.thres_trans);
motiondata.rot_t=motiondata.rot.*(motiondata.rot>motiondata.thres_rot);

motiondata.both_not_normed=motiondata.trans_t+motiondata.rot_t*p_trans_rot_scale;
if max(motiondata.both_not_normed)~=0
    motiondata.both=motiondata.both_not_normed/max(motiondata.both_not_normed);
else
    motiondata.both=motiondata.both_not_normed;
end
motiondata.numvols=length(motiondata.both);