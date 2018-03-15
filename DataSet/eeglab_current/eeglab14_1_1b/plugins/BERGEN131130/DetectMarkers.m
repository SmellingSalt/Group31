% DetectMarkers.m is a function used by Bergen EEG&fMRI Toolbox for EEGLAB 
% in order to detect fMRI artifacts on a EEG dataset recording. Using the
% gradient of a certain channel, and given some imputs, like the Repetition
% Rate, threshold trigger or a specific channel, DetectMarkers will scan
% the EEG dataset and builds a matrix with the references of each fMRI 
% start for each channel of the EEG dataset.
% 
% USAGE: 
%       [Peak_references, thres, ch] = threshold_detect(EEG, fMRI_TR, 
%                                grad_trigger, percent_trigger, channel);
% 
% 
% INPUTS:
%        EEG - is the structure loaded by the EEGLAB. This structure must
%              have a loaded dataset. This function uses internaly the 
%              dataset refered as the CURRENTSET.
% 
%        fMRI_TR - is the Repetition Rate of the fMRI scans and it should
%                  be especifyed in millisenconds. It can be an 
%                  approximated value.
%        
%        grad_trigger - is the value of amplitude treshold used for trigger
%                       the detection of the fMRI artifacts. This value is 
%                       considered as a threshold on the gradient of the 
%                       dataset. If grad_trigger = 0 is choosen then it's
%                       value will be determined as a percentage of the
%                       gradient data.
% 
%        percent_trigger - is the amplitude percentage of the gradient 
%                          data to be considered as grad_trigger value.
%                          This parameter will only be considered if
%                          grad_trigger differs from 0. Use values [0..100]
% 
%        channel - is the channel fo the EEG dataset that the algorythm 
%                  will use to scan the artifacts. If channel = 0 is
%                  choosen, the choice of channel will automated and based 
%                  on the channel that has the lowest variance.
%
% OUTPUTS: 
%         Peak_references - This matrix contains the references of each 
%                           start of the fMRI artifact for each independent
%                           EEG dataset channel. It has of
%                           [ channels x Nº. of fMRI References found ]. 
% 
%         thres - is the value of the amplitude treshold used to trigger
%                 the detection of possible fMRI artifacts.
% 
%         ch - is the channel choosen by the algorytm for the artifacts 
%              detection.
% 
%   EXAMPLES: 
%    
%   Example1:
%       threshold_detect(EEG, 2200, 0, 83, 0) 
%                       -> Scan artifacts on EEG dataset with estimated TR 
%                          of 2200 ms, considering the threshold of 83% of 
%                          the gradient channel to trigger detection, and 
%                          auto choose the channel.
%   Example2:
%       threshold_detect(EEG, 1800, 320, 0, 4) 
%                       -> Scan artifacts on EEG dataset with estimated TR 
%                          of 2200 ms, consider 320 micro volts/ms as the
%                          threshold to trigger detection, using channel 4.
%  
%   See also DETECTCHANNEL
%

% Copyright (C) 2009 The Bergen fMRI Group
% 
% Bergen fMRI Group, Department of Biological and Medical Psychology,
% University of Bergen, Norway
% 
% Written by Emanuel Neto, 2009
% netoemanuel@gmail.com
% 
% Last Modified on 18-Jun-2009 08:07:11


function [Peak_references, lim_threshold, real_TR, ref_channel] = DetectMarkers(EEG, fMRI_TR, lim_threshold, percent_trigger, ch)


% ------------------------------------------------------------------------
% Input validation
% ------------------------------------------------------------------------
if nargin < 1 
	error('Error: EEG DataSet must be loaded.');
	return;
end;
% Imputs may be given as value 0 when user goes for auto-detect.
exist_limit_flag = 0;
if percent_trigger == 0
    % Case of 0, Consider lim_threshold as priority
    % Otherwise Percentage has priority
    exist_limit_flag = 1;
    percent_trigger = 0.5;
else
    exist_limit_flag = 0;
    percent_trigger = percent_trigger/100;
end

% ------------------------------------------------------------------------
% Initialize
% ------------------------------------------------------------------------
peak=1;
global sub_peak
subpeak=[];
sub_peak=1;
position=1;


% ------------------------------------------------------------------------
% Pre calculus for Detection Method
% ------------------------------------------------------------------------
% Select Channel
    channel_data = EEG.data(ch,:); % Select Channel
    data_diff = diff(channel_data); % Use differential
    channel_dimmension = size(channel_data); % Total of sample
% Calculate threshold 
    Artifact_duration = get_window_lenght(EEG, fMRI_TR);
% Calculate threshold 
    if exist_limit_flag == 1
        if lim_threshold == 0
            lim_threshold=get_auto_limit(EEG,data_diff);
        end
    else
        lim_threshold=get_auto_limit(EEG,data_diff);
    end

    % ------------------------------------------------------------------------
% Initial Plot
% ------------------------------------------------------------------------
% plot(data_diff), title('Differential of data channel)'); % Ploting channel
% hold on 

% ------------------------------------------------------------------------
% Threshold detection (limit)
% ------------------------------------------------------------------------
% fprintf('Estimating possible fMRI peaks... ');
while(position < channel_dimmension(2))
    if ((data_diff(position)) > lim_threshold) % Peak was found
        if Artifact_duration > 0 % window_lenght is defined
            fMRI_scan(peak)=position;   % Store the fMRI_scan(peaks) location
%             plot(position, lim_threshold, 'r+') %ploting start of peaks
            position=position+Artifact_duration;
            peak=peak+1;
        else % window_lenght is not defined
            if sub_peak == 1 %1st peak, 1st sub_peak
               fMRI_scan(peak)=position;   % Store the 1st fMRI_scan(peaks)
            end
            % window_length = update_window_length(EEG, position, sub_peak);
            sub_peak = sub_peak + 1;
            position= position+1;
        end
    else
        position = position+1;
    end
end
% fprintf('Done! (See red markers "+".\n');


% ------------------------------------------------------------------------
% Finishing Detection method function
% ------------------------------------------------------------------------
% fprintf('Complete!\n');
% hold off;
Peak_references = fMRI_scan;
real_TR = (Peak_references(2)-Peak_references(1))/EEG.srate*1000;
ref_channel = ch;


% ------------------------------------------------------------------------
% Auto - Channel determintation
% ------------------------------------------------------------------------
function ch = auto_channel(EEG);
    total_ch = EEG.nbchan;
    for i=1 : total_ch
        channel_filter(i) = var(EEG.data(i,:)); % Filter based on variance
    end
    [val, ch] = min(channel_filter);
end

% ------------------------------------------------------------------------
% Auto - Threshold limit value
% ------------------------------------------------------------------------
function auto_limit = get_auto_limit(EEG, data_diff)
    auto_limit = ceil(max(data_diff)*percent_trigger);
end


% ------------------------------------------------------------------------
% Auto - Window_length
% ------------------------------------------------------------------------
function window_length = get_window_lenght(EEG, fMRI_TR);
    est_window_lenght = fMRI_TR*EEG.srate/1000;
    length = find(en_autocorr(data_diff, est_window_lenght) > 0.95);
    window_length = max(length)-min(length); 
end


end


