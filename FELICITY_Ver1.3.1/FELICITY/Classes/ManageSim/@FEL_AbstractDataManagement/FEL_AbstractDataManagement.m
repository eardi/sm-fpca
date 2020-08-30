% FELICITY (abstract) Class for storing data
classdef FEL_AbstractDataManagement
    properties (SetAccess='private')%,GetAccess='private')
        Main_Dir    % string for dir to save and load data
    end
    methods
        function obj = FEL_AbstractDataManagement(varargin)
            
            if (nargin > 1)
                disp('Requires 0 or 1 argument!');
                disp('First  is a directory for storing data.');
                error('Check the arguments.');
            end
            
            if (nargin >= 1)
                obj.Main_Dir = varargin{1};
            else
                obj.Main_Dir = [];
            end
            
            if ~isempty(obj.Main_Dir)
                obj = obj.Set_Main_Dir(obj.Main_Dir);
            end
        end
    end
end

% END %