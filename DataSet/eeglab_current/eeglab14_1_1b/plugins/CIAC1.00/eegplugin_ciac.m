% eegplugin_ciac() - EEGLAB plugin to select ICs representing cochlear implant artifacts
%
% Usage:
%   >> eegplugin_ciac(fig, try_strings, catch_strings);
%
% Inputs:
%   fig           - [integer]  EEGLAB figure
%   try_strings   - [struct] "try" strings for menu callbacks.
%   catch_strings - [struct] "catch" strings for menu callbacks.
%
% See also:  pop_ciac(), ciac()
%
% Author:  F.C. Viola, Neuropsychology Lab, Department of Psychology, University of Oldenburg, Germany 20/10/2011 (filipa.viola@uni-oldenburg.de)

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

function vers=eegplugin_ciac(fig, try_strings, catch_strings);

 vers = 'ciac1.00';
    if nargin < 3
        error('eegplugin_ciac requires 3 arguments');
    end
    
menu = findobj(fig, 'tag', 'study');
uimenu(menu, 'label', 'CIAC', 'callback', ... 
    [try_strings.no_check '[CIAC, STUDY, ALLEEG, LASTCOM]= pop_ciac(STUDY,ALLEEG);' catch_strings.add_to_hist ]);
