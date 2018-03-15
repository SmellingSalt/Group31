% eegplugin_std_ErpCalc()
%
% Usage:
%   >>  eegplugin_std_ErpCalc( fig, try_strings, catch_strings)
%
% Author: Makoto Miyakoshi JSPS/SCCN,INC,UCSD

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) 2012, Makoto Miyakoshi JSPS/SCCN,INC,UCSD
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
%
% History
% 11/13/2012 ver 1.0 by Makoto. Created.

function eegplugin_std_ErpCalc( fig, try_strings, catch_strings);

 vers = '1.0';
    if nargin < 3
        error('eegplugin_std_ErpCalc requires 3 arguments');
    end
    
% create menu
std = findobj(fig, 'tag', 'study');
submenu = uimenu( std, 'label', 'std_ErpCalc', 'userdata', 'startup:off;study:on');

% add new submenu
uimenu( submenu, 'label', 'Compute average ERPs', 'callback', 'STUDY = std_ErpCalc(STUDY, ALLEEG, EEG);', 'userdata', 'startup:off;study:on');
uimenu( submenu, 'label', 'Flexible ERP Plot',    'callback', 'STUDY = std_FlexibleErpPlot(STUDY, ALLEEG, EEG);', 'userdata', 'startup:off;study:on', 'separator', 'on');