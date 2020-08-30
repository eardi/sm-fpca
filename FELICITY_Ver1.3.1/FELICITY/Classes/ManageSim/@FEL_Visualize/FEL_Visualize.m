% FELICITY Class for saving plots and making movies.
%
%   obj         = FEL_Visualize(); % initializes the object with Main_Dir := [];
%                 Note: you must set Main_Dir with "Set_Main_Dir" before saving
%                       any plots!
%
%   obj         = FEL_Visualize(Main_Dir);
%
%   Main_Dir    = string representing directory in which to store the plots and movies.
classdef FEL_Visualize < FEL_AbstractDataManagement
    properties %(SetAccess='private',GetAccess='private')
        %Main_Dir    % string for dir to save plots and movies
    end
    methods
        function obj = FEL_Visualize(varargin)
            
            if (nargin > 1)
                disp('Requires 0 or 1 argument!');
                disp('First  is a directory for saving plots and movies.');
                error('Check the arguments.');
            end
            
            if (nargin >= 1)
                DD = varargin{1};
            else
                DD = [];
            end
            obj = obj@FEL_AbstractDataManagement(DD);
        end
    end
end

% END %