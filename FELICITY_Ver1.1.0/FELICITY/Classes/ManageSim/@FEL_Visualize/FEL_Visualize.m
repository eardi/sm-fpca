% FELICITY Class for saving plots and making movies.
%
%   obj         = FEL_Visualize(Plot_Dir);
%
%   Plot_Dir    = string representing directory in which to store the plots and movies.
classdef FEL_Visualize
    properties %(SetAccess='private',GetAccess='private')
        Plot_Dir    % string for dir to save plots and movies
    end
    methods
        function obj = FEL_Visualize(varargin)
            
            if nargin ~= 1
                disp('Requires 1 argument!');
                disp('First  is a directory for saving plots and movies.');
                error('Check the arguments.');
            end
            
            obj.Plot_Dir    = varargin{1};
            % check that it is a valid directory
            if ~(exist(obj.Plot_Dir,'dir')==7)
                error('Plot_Dir is not a valid directory!');
            end
        end
    end
end

% END %