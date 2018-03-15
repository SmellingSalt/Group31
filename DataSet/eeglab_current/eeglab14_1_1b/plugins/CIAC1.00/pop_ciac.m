%pop_ciac - calls ciac() function which evaluates temporal and spatial properties of ICs included in a STUDY and selects ICs representing CI artifacts.
%           It displays the scalp maps of the  ICs selected and the original and corrected AEPs for each dataset contained in the STUDY.
%           All datasets MUST be epoched to the same auditory stimuli.
%           IMPORTANT: It requires that the user had run DIPFIT for each dataset contained in the STUDY. For details about
%           how to use DIPFIT, please check http://sccn.ucsd.edu/wiki/A08:_DIPFIT.
%
% Usage:
%          >> [CIAC,STUDY,ALLEEG] = ciac(STUDY, ALLEEG, dur,twind,th_rv,th_der,th_corr,Cz_ind,plot);
%
% Inputs:
%  STUDY - input STUDY structure
%  ALLEEG - input ALLEEG structure
%  dur - duration of the auditory stimuli [ms]
%  twind - time window of interest [ms] containing the AEP response. It should
%  be an interval, e.g. [80 140]
%  th_rv - threshold for residual variance. Recommended values 0.15 < th_rv  < 0.25
%  th_der - threshold for derivative. Recommended values 1.5 < th_der < 3.5
%  th_corr - threshold for correlation. Recommended values 0.85 < th_corr < 0.95
%  Cz_ind - index of the channel of interest. Recommended Cz index.
%  plot - if plot=1, output plots for each dataset are displayed, if plot=0, plots are saved automatically
%  in the same folder where the STUDY set is saved. Default: plot=1.
%
% Outputs:
% CIAC - structure that contains indices of ICs selected as
% representing the CI artifact for each dataset analysed.
% STUDY - STUDY structure updated
% ALLEEG - ALLEEG structure
%
% See also:  ciac()
%
% Author: F.C. Viola, Neuropsychology Lab, Department of Psychology, University of Oldenburg, Germany 20/10/2011 (filipa.viola@uni-oldenburg.de)

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) F.C. Viola, Neuropsychology Lab, Dept. Psychology, Uni Oldenburg
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

function [CIAC,STUDY,ALLEEG,com] = pop_ciac(STUDY,ALLEEG)

CIAC=[];
com = 'babbb'; % this initialization ensure that the function will return something
% if the user press the cancel button

if nargin < 2
    disp('No input parameters')
    disp('see >> help pop_ciac');
    return;
end;

    promptstr    = { 'Duration audio stimuli (insert a value in ms):', ...
        'Time window AEP (insert values in ms, e.g. [80 250]):', ...
        'Threshold RV (requires DIPFIT, insert a value <0.25):', ...
        'Threshold Derivative (insert a value >1):', ...
        'Threshold Correlation (insert a value between ]0 1]:',...
        'Index from channel of interest (Cz recommended):', ...
        'Display output plots (1=''yes''; 0=''no'' and plots are saved)'};

    inistr       = { '', ...
       '',...
       0.2,...
       2.5,...
       0.9,...
       '',...
       1};
    
   result = inputdlg2( promptstr, 'Selection of CI artifact ICs', 1, inistr, 'pop_ciac');

    if size(result,1) == 0
      
    else
       
        dur   = eval(  result{1} );
        twind = eval( result{2} );
        th_rv=eval(result{3});
        th_der=eval( result{4} );
        th_corr=eval(result{5});
        cz=eval(result{6});
        pl=eval(result{7});         
       
        [CIAC,STUDY,ALLEEG] = ciac(STUDY,ALLEEG,dur,twind,th_rv,th_der,th_corr,cz,pl);
        
        com = sprintf('pop_ciac(STUDY,ALLEEG,%g,[%s],%g,%g,%g,%g,%g)',dur,num2str(twind),th_rv,th_der,th_corr,cz,pl);
    end



end