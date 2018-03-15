function [ EEG ] = BaselineCorrect(EEG, Peak_references, weighting_matrix, baseline_method, onset_value, offset_value, ref_start, ref_end, extra_data)
% BaselineCorrect.m is a function used by Bergen EEG&fMRI Toolbox plugin 
% for EEGLAB in order to adjust the corected and/or non corrected data
% to a given baseline.
% 
% 
% Copyright (C) 2009 The Bergen fMRI Group
% 
% Bergen fMRI Group, Department of Biological and Medical Psychology,
% University of Bergen, Norway
% 
% Written by Emanuel Neto, 2009
% netoemanuel@gmail.com
% 
% Last Modified on 3-Nov-2009 12:04:11

n_channels = length(EEG.chanlocs);
TR = Peak_references(3)-Peak_references(2);

% Baseline Methods: variable "baseline_method"
% 0 - No method
% 1 - Based on WHOLE ARTIFACT to zero
% 2 - Average of precedent silent gap
%     ref_start will be used has the begining of the precedent silent gap
%     ref_end will be used has the end of the precedent silent gap
% 3 - Average of time interval
%
% extra_data if =1 then the data not afected by the gradient artifacts
% removal process is also ajusted for the specifyed baseline.

h = waitbar(0,'Baseline correction of Artifacts');
hw=findobj(h,'Type','Patch');
set(hw,'EdgeColor',[1 1 0],'FaceColor',[1 1 0]);
precision = 0.000001;

try
   lim1 = length(Peak_references);
   lim2 = length(weighting_matrix);
   residual = lim1 - lim2 + 1;
%    residual = lim2-lim1+1;
   switch baseline_method
       case 1 % 1 - Based on WHOLE ARTIFACT to zero
           baseline = 0;
           % Do corrected data
           for ch = 1: n_channels
               waitbar(ch/n_channels,h);
               pause(0.01);
               for i = residual  : lim1
                   starter = Peak_references(i)+onset_value;
                   ender = Peak_references(i)+offset_value;
                   artif_average = mean(EEG.data(ch,starter:ender));
                   adjust = baseline - artif_average;
                   if abs(adjust) > precision
                       for j=starter:ender
                           EEG.data(ch,j) = EEG.data(ch,j) + adjust;
                       end
                   end
               end
           end
           st = Peak_references(residual) + onset_value;
           en = Peak_references(lim1) + offset_value;

       case 2 % 2 - Average of precedent silent gap
           for ch = 1: n_channels
               waitbar(ch/n_channels,h);
               pause(0.01);
               for i = residual  : lim1
                   try
                       baseline_start = Peak_references(i) + ref_start;
                       baseline_end = Peak_references(i) + ref_end;
                       baseline = mean(EEG.data(ch,baseline_start:baseline_end));
                   catch
                       baseline = 0;
                   end
                   starter = Peak_references(i)+onset_value;
                   ender = Peak_references(i)+offset_value;
                   artif_average = mean(EEG.data(ch,starter:ender));
                   adjust = baseline - artif_average;
                   if abs(adjust) > precision
                       for j=starter:ender
                           EEG.data(ch,j) = EEG.data(ch,j) + adjust;
                       end
                   end
               end
           end
           st = Peak_references(residual) + onset_value;
           en = Peak_references(lim1) + offset_value;
           
       case 3
          for ch = 1: n_channels
               for i = residual  : lim1
                   waitbar(ch/n_channels,h);
                   pause(0.01);
                   try
                       baseline_start = Peak_references(i-1) + ref_end;
                       baseline_end = Peak_references(i) + ref_start -1 ;
                       baseline = mean(EEG.data(ch,baseline_start:baseline_end));
                   catch
                       baseline = 0;
                   end
                   starter = Peak_references(i)+ref_start;
                   ender = Peak_references(i)+ref_end;
                   artif_average = mean(EEG.data(ch,starter:ender));
                   adjust = baseline - artif_average;
                   if abs(adjust) > precision
                       for j=starter:ender
                           EEG.data(ch,j) = EEG.data(ch,j) + adjust;
                       end
                   end
               end
           end
           st = Peak_references(residual) + ref_start;
           en = Peak_references(lim1) + ref_end;
   end

   close(h);
   
   % Shift also non corrected data
   if extra_data == 1
       h = waitbar(0,'Baseline correction of non corrected data');
       boundary1 = fix(Peak_references(residual)+onset_value-1); % start of fMRI gradients
       boundary2 = fix(Peak_references(lim1)+offset_value+1); % end of fMRI gradients
       for ch = 1: n_channels
           waitbar(ch/n_channels,h);
           pause(0.01);
           switch baseline_method
               case 1
                   baseline = 0;
               otherwise
                   baseline1 = mean(EEG.data(ch,st:st+TR));
%                    baseline1 = mean(EEG.data(ch,Peak_references(residual):Peak_references(residual+1)));
%                    baseline2 = mean(EEG.data(ch,(Peak_references(lim2):Peak_references(lim2)+TR)));
                   baseline2 = mean(EEG.data(ch,en:en+TR));
           end
           lim3 = length(EEG.data(ch,:)); 
           adjust = baseline1 - mean(EEG.data(ch,1:boundary1));
           if abs(adjust) > precision
               for i=1:boundary1
                   EEG.data(ch,i) = EEG.data(ch,i) + adjust;
               end
           end
           adjust = baseline2 - mean(EEG.data(ch,boundary2:end));
           if abs(adjust) > precision
                for i=boundary2:lim3 % Channel could happen to turn disconected during recording
                     EEG.data(ch,i) = EEG.data(ch,i) + adjust;
                end
           end
       end
   end
end
    
    
    waitbar(1,h,'Baseline process completed.');
    pause(0.3);
    close(h);
