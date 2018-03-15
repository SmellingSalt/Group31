classdef Subject
%SUBJECT is a class representing each subject in the data_folder. 
%   A Subject corresponds to a folder, which contains one or more
%   Blocks. A Bock represents a raw file and it's associated
%   preprocessed file, if any (See Block).
%
% Copyright (C) 2017  Amirreza Bahreini, amirreza.bahreini@uzh.ch
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    properties(SetAccess=private)
        % Name of the folder of this subject.
        name
    end
    
    properties(SetAccess=private)
        % List of all blocks of this subject
        block_list
        
        % The address of the data_folder in which this subject is stored.
        data_folder
       
        % The address of the folder where the results are (to be) stored.
        result_folder
    end
    
    methods
        %% Constructor
        function self = Subject(data_folder, result_folder)
            self.result_folder = result_folder;
            self.data_folder = data_folder;
            self.name = self.extract_name(data_folder);
        end     
        
        function self = update_addresses(self, new_data_path, new_project_path)
            % The method is to be called to update addresses
            % in case the project is loaded from another operating system and may
            % have a different path to the data_folder or result_folder. This can
            % happen either because the data is on a server and the path to it is
            % different on different systems, or simply if the project is loaded
            % from a windows to a iOS or vice versa. 

            self.data_folder = [new_data_path self.name];
            self.result_folder = [new_project_path self.name];
        end
    end
    
    methods(Static, Access=private)
        function name = extract_name(address)
            if(isunix)
                splits = strsplit(address, '/');
            elseif(ispc)
                splits = strsplit(address, '\');
            end
            name = splits{end};
        end
    end
end

