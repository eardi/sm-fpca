% Concrete Base Class for performing level set interpolation
classdef LS_Many_Ellipses < Abstract_LevelSet
    properties %(SetAccess = private)
    end
    methods
        function obj = LS_Many_Ellipses(varargin)
            
            if nargin ~= 0
                disp('Requires 0 arguments!');
                error('Check the arguments!');
            end
            
            obj = obj@Abstract_LevelSet();
        end
    end
end

% END %