% eegplugin_gevd() - Generalized Eigenvalue Decomposition plugin
%
% Usage:
%   >> eegplugin_gevd(fig, trystrs, catchstrs);
%
% Inputs:
%   fig        - [integer] eeglab figure.
%   trystrs    - [struct] "try" strings for menu callbacks.
%   catchstrs  - [struct] "catch" strings for menu callbacks.
%
% Reference:
%       @article{parra2005,
%       author = {Lucas C. Parra and Clay D. Spence and Adam Gerson 
%                and Paul Sajda},
%       title = {Recipes for the Linear Analysis of {EEG}},
%       journal = {{NeuroImage}},
%       year = {in revision}}
%
% Authors: Xiang Zhou (zhxapple@hotmail.com, 2005)
%          with Adam Gerson (adg71@columbia.edu, 2005),
%          and Lucas Parra (parra@ccny.cuny.edu, 2005),
%          and Paul Sajda (ps629@columbia,edu 2005)

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) 2005 Xiang Zhou, Adam Gerson, Lucas Parra and Paul Sajda
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

function vers = eegplugin_gevd(fig, try_strings, catch_strings); 

vers='gevd1.0';
if nargin < 3
    error('eegplugin_gevd requires 3 arguments');
end;

% add gevd folder to path
% -----------------------
if ~exist('pop_gevd')
    p = which('eegplugin_gevd');
    p = p(1:findstr(p,'eegplugin_gevd.m')-1);
    addpath([ p vers ] );
end;


% create menu
menu = findobj(fig, 'tag', 'tools');

% menu callback commands
% ----------------------
cmd = [ '[ALLEEG]=pop_gevd(ALLEEG); EEG=ALLEEG(CURRENTSET); eeglab(''redraw''); ' ];

% add new submenu
uimenu( menu, 'label', 'Run Generalized Eigenvalue Decomposition (GEVD)', 'callback', cmd);
