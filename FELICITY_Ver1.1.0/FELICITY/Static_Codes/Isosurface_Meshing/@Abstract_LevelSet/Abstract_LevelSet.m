% Abstract Class for performing level set interpolation
classdef Abstract_LevelSet
    properties %(SetAccess = private)
        Param              % struct for holding useful parameters
        Grid               % struct for holding grid data
    end
    methods
        function obj = Abstract_LevelSet(varargin)
            
            if nargin ~= 0
                disp('Requires 0 arguments!');
                error('Check the arguments!');
            end
            
            % init
            obj.Param         = [];
            obj.Grid          = [];
        end
    end
    methods (Abstract)
        [Val, Grad] = Interpolate(obj); % implemented in the derived class
    end
end

% END %