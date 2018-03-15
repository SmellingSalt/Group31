% CorrectionMatrix.m is a function used by Bergen EEG&fMRI Toolbox for 
% EEGLAB in order to remove the fMRI artifacts on a EEG dataset recording. 
% Using this function, the pointed CURRENTSET of the EEG structure will be 
% rewriten after processing and removing the artifacts.
% 
% USAGE: 
%       [ EEG ] = CorrectionMatrix( EEG, weighting_matrix, Peak_references,
%                 onset_value, offset_value, baseline_matrix);
% 
% INPUTS:
%        EEG - is the structure loaded by the EEGLAB. This structure must
%              have a loaded dataset. This function uses internaly the 
%              dataset refered as the CURRENTSET.
% 
%        weighting_matrix - is a matrix used for correcting EEG data. This 
%                           matrix must be quadratic [ M x M ], where M is 
%                           the number of artifacts considered for
%                           correction.
% 
%        Peak_references - This matrix contains the references of each 
%                          start of the fMRI artifact for each independent
%                          EEG dataset channel. It has of
%                          [ channels  x  Nº. of fMRI References found ]. 
% 
%        onset_value - is the position of the real start of each artifact,
%                      relative to the marker position. Must be expressed
%                      in data points. (e.g. -150)
% 
%        offset_value - is the position of the real end of each artifact,
%                       relative to the marker position.Must be expressed
%                      in data points. (e.g. +11200)
% 
% OUTPUT:
%        EEG - is the structure of data used by EEGLAB. This structure will
%              be rewriten with the corrected EEGdataset.
%
% See also m_rp_info, m_moving_average, m_single_motion, detectchannel,
% detectmarkers, baselinematrix

% Copyright (C) 2009 The Bergen fMRI Group
% 
% Bergen fMRI Group, Department of Biological and Medical Psychology,
% University of Bergen, Norway
% 
% Written by Emanuel Neto, 2009
% netoemanuel@gmail.com
% 
% Last Modified on 18-Jun-2009 08:07:11

function [ EEG, message ] = CorrectionMatrix( EEG, weighting_matrix, Peak_references, onset_value, offset_value)
lim1 = length(Peak_references);
lim2 = length(weighting_matrix);
residual = lim2-lim1+1;
message = '';
n_channels = length(EEG.chanlocs);

step=0;
h = waitbar(0,'Initializing');
hw=findobj(h,'Type','Patch');
set(hw,'EdgeColor',[0 1 0],'FaceColor',[0 1 0]);
total=n_channels*lim2*2;
try
    for ch = 1: n_channels+1
        if ch > n_channels
            for i = residual  : lim2
                step = step+1;
                step_srt = num2str((step/total)*100);
                waitbar(step/total,h,['Applying changes (Channel ', num2str(ch),'/',num2str(n_channels),'). Total progress: ', num2str(sprintf('%1.0f', steptosrt)),'%' ]);
                starter = fix(Peak_references(i)+onset_value);
                ender = fix(Peak_references(i)+offset_value);
                EEG.data(ch-1,starter:ender) = CorrectionM(i,:);
            end
        else
            for i = residual  : lim2
                step = step+1;
                steptosrt = (step/total)*100;
                waitbar(step/total,h,['Applying changes (Channel ', num2str(ch),'/',num2str(n_channels),'). Total progress: ', num2str(sprintf('%1.0f', steptosrt)),'%' ]);
                starter = fix(Peak_references(i)+onset_value);
                ender = fix(Peak_references(i)+offset_value);
                A(i,:) = (EEG.data(ch,starter:ender))';
                if ch > 1
                    EEG.data(ch-1,starter:ender) = CorrectionM(i,:);
                end
            end
            A;
            for i= residual : lim2
                step = step+1;
                steptosrt = (step/total)*100;
                waitbar(step/total,h,['Applying changes (Channel ', num2str(ch),'/',num2str(n_channels),'). Total progress: ', num2str(sprintf('%1.0f', steptosrt)),'%' ]);
                w=weighting_matrix(i,:)/sum(weighting_matrix(i,:));
                Correctionmatrix (i,:) = w*A;
            end

            CorrectionM(:,:) = A - Correctionmatrix;
        end
    end
    waitbar(1,h,'Process completed');
    close(h);
    pause(0.1);
catch
    message = [10, 'Memory index error. EEG dataset was not modifyed!', 10,10,...
        'Possible causes:',10,...
        'a) Artifact duration exceedes dataset limit. Please check if last artifacts are complete. It might be necessary to cut dataset.',10,...
        'b) Not enough memory. Please read how to handle with Large Datasets in http://www.mathworks.com/support/tech-notes/1100/1107.html',10,' '];
    warndlg(message,'Correcting Matrix','modal');
    close(h);
end



