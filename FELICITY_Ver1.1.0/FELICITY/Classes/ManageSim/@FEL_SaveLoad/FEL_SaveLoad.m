% FELICITY Class for storing time-series, or indexed, simulation data and re-loading it.
% Note: the class can manage static and dynamic data.  For example, data that does not
% depend on a time index is saved once in one file; data that does change with a time
% index is saved in several files (one for each time index).
%
%   obj         = FEL_SaveLoad(Data_Dir);
%
%   Data_Dir    = string representing directory in which to store the simulation data.
%
%   obj         = FEL_SaveLoad(Data_Dir,File_Prefix);
%
%   File_Prefix = string representing file name prefix to use when saving/loading
%                 simulation data.
%
%   obj         = FEL_SaveLoad(Data_Dir,File_Prefix,Num_Pad_Zeros_File_Index);
%
%   Num_Pad_Zeros_File_Index = number of zeros to pad in the index of the filename when
%                              storing simulation data. (Default = 6)
classdef FEL_SaveLoad
    properties %(SetAccess='private',GetAccess='private')
        Data_Dir    % string for dir to store and read simulation data
        File_Prefix % file name prefix to use when storing simulation data
        Num_Pad_Zeros_File_Index
    end
    methods
        function obj = FEL_SaveLoad(varargin)
            
            if or(nargin < 1,nargin > 3)
                disp('Requires 1 to 3 arguments!');
                disp('First  is a directory for storing data.');
                disp('Second is a file prefix to use in naming the storage files.');
                disp('Third  is the number of zeros to pad in the storage filename index.');
                error('Check the arguments.');
            end
            
            obj.Data_Dir    = varargin{1};
            if (nargin==2)
                obj.File_Prefix = varargin{2};
            else
                obj.File_Prefix = 'SimData';
            end
            if (nargin==3)
                obj.Num_Pad_Zeros_File_Index = varargin{3};
            else
                obj.Num_Pad_Zeros_File_Index = 6;
            end
            if or(obj.Num_Pad_Zeros_File_Index < 0, obj.Num_Pad_Zeros_File_Index > 20)
                error('Invalid zero pad length!');
            end

            % check that it is a valid directory
            if ~(exist(obj.Data_Dir,'dir')==7)
                error('Data_Dir is not a valid directory!');
            end
            
            % check that prefix is a string
            if ~ischar(obj.File_Prefix)
                error('File_Prefix must be a string!');
            end
            % make sure first character is NOT a number
            m = regexp(obj.File_Prefix(1), '\d', 'match');
            if ~isempty(m)
                error('First character in the prefix cannot be a number!');
            end
        end
    end
end

% END %