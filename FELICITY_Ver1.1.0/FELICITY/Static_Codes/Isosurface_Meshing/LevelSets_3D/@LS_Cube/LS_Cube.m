% Concrete Base Class for performing level set interpolation
classdef LS_Cube < Abstract_LevelSet
    properties %(SetAccess = private)
    end
    methods
        function obj = LS_Cube(varargin)
            
            if nargin ~= 0
                disp('Requires 0 arguments!');
                error('Check the arguments!');
            end
            
            obj = obj@Abstract_LevelSet();
        end
    end
end

% END %