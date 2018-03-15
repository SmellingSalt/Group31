% pop_ermsel() - pop up a graphic interface to select ermnels
%
% Usage:
%   >> [ermlist] = pop_ermsel(ermstruct); % a window pops up
%   >> [ermlist strermnames cellermnames] = ...
%                        pop_ermsel(ermstruct, 'key', 'val', ...);
%
% Inputs:
%   ermstruct     - ermnel structure. See readlocs()
%
% Optional input:
%   'withindex'      - ['on'|'off'] add index to each entry. May also a be 
%                      an array of indices
%   'select'         - selection of ermnel. Can take as input all the
%                      outputs of this function.
%   'selectionmode' - selection mode 'multiple' or 'single'. See listdlg2().
%
% Output:
%   ermlist      - indices of selected ermnels
%   strermnames  - names of selected ermnel names in a concatenated string
%                   (ermnel names are separated by space characters)
%   cellermnames - names of selected ermnel names in a cell array
%
% Author: Arnaud Delorme, CNL / Salk Institute, 3 March 2003

% Copyright (C) 3 March 2003 Arnaud Delorme, Salk Institute, arno@salk.edu
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

function [ermlist,ermliststr, allermstr] = pop_erms(erms, varargin); 
    
    if nargin < 1
        help pop_erms;
        return;
    end;
    if isempty(erms), disp('Empty input'); return; end;
    if isnumeric(erms),
        for c = 1:length(erms)
            newerms{c} = num2str(erms(c));
        end;
        erms = newerms;
    end;
    ermlist    = [];
    ermliststr = {};
    allermstr  = '';
    
    g = finputcheck(varargin, { 'withindex'     {  'integer';'string' } { [] {'on' 'off'} }   'off';
                                'select'        { 'cell';'string';'integer' } [] [];
                                'selectionmode' 'string' { 'single';'multiple' } 'multiple'});
    if isstr(g), error(g); end;
    if ~isstr(g.withindex), erm_indices = g.withindex; g.withindex = 'on';
    else                    erm_indices = 1:length(erms);
    end;
    
    % convert selection to integer
    % ----------------------------
    if isstr(g.select) & ~isempty(g.select)
        g.select = parsetxt(g.select);
    end;
    if iscell(g.select) & ~isempty(g.select)
        if isstr(g.select{1})
            tmplower = lower( erms );
            for index = 1:length(g.select)
                matchind = strmatch(lower(g.select{index}), tmplower, 'exact');
                if ~isempty(matchind), g.select{index} = matchind;
                else error( [ 'Cannot find ''' g.select{index} '''' ] );
                end;
            end;
        end;
        g.select = [ g.select{:} ];
    end;
    if ~isnumeric( g.select ), g.select = []; end;
    
    % add index to ermnel name
    % -------------------------
	tmpstr = {erms};
    if isnumeric(erms{1})
        tmpstr = [ erms{:} ];
        tmpfieldnames = cell(1, length(tmpstr));
        for index=1:length(tmpstr), 
            if strcmpi(g.withindex, 'on')
                tmpfieldnames{index} = [ num2str(erm_indices(index)) '  -  ' num2str(tmpstr(index)) ]; 
            else
                tmpfieldnames{index} = num2str(tmpstr(index)); 
            end;
        end;
    else
        tmpfieldnames = erms;
        if strcmpi(g.withindex, 'on')
            for index=1:length(tmpfieldnames), 
                tmpfieldnames{index} = [ num2str(erm_indices(index)) '  -  ' tmpfieldnames{index} ]; 
            end;
        end;
    end;
    [ermlist,tmp,ermliststr] = listdlg2('PromptString',strvcat('(use shift|Ctrl to', 'select several)'), ...
                'ListString', tmpfieldnames, 'initialvalue', g.select, 'selectionmode', g.selectionmode);   
    if tmp == 0
        ermlist = [];
        ermliststr = '';
        return;
    else
        allermstr = erms(ermlist);
    end;
    
    % test for spaces
    % ---------------
    spacepresent = 0;
    if ~isnumeric(erms{1})
        tmpstrs = [ allermstr{:} ];
        if ~isempty( find(tmpstrs == ' ')) | ~isempty( find(tmpstrs == 9))
            spacepresent = 1;
        end;
    end;
    
    % get concatenated string (if index)
    % -----------------------
    if strcmpi(g.withindex, 'on') | spacepresent
        if isnumeric(erms{1})
            ermliststr = num2str(celltomat(allermstr));
        else
            ermliststr = '';
            for index = 1:length(allermstr)
                if spacepresent
                    ermliststr = [ ermliststr '''' allermstr{index} ''' ' ];
                else
                    ermliststr = [ ermliststr allermstr{index} ' ' ];
                end;
            end;
            ermliststr = ermliststr(1:end-1);
        end;
    end;
    
   
    
    return;
