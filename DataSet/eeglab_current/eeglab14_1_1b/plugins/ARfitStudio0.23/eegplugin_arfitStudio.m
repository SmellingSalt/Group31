% eegplugin_arfitStudio() - Interpolate spike artifact (or anything)
%                           using ARFIT. User should install AFFIT and
%                           mcolon (this needs to be compiled). To
%                           install ARFIT, one can simply install
%                           SIFT. For help, see wiki page.
%
% http://www.mathworks.com/matlabcentral/fileexchange/174-arfit
% http://www.mathworks.com/matlabcentral/fileexchange/29854-multiple-colon/content/mcolonFolder/mcolon.m

% Copyright (C) 2015 Makoto Miyakoshi and Tim Mullen, SCCN,INC,UCSD
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
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1.07  USA

function vers = eegplugin_arfitStudio(fig, trystrs, catchstrs)
    
vers = 'beta';
if nargin < 3
    error('eegplugin_arfitStudio requires 3 arguments');
end;
    
% create menu
toolsmenu = findobj(fig, 'tag', 'tools');
uimenu( toolsmenu, 'label', 'ARfit Studio', 'separator','on','callback', 'arfitStudio');