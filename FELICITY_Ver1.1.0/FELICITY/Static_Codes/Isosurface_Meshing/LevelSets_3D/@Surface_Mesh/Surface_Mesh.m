% Concrete Base Class for performing in/out tests
classdef Surface_Mesh < Abstract_LevelSet
    properties %(SetAccess = private)
    end
    methods
        function obj = Surface_Mesh(varargin)
            
            if nargin ~= 2
                disp('Requires 2 arguments!');
                disp('First  is a Nx3 array of vertex coordinates.');
                disp('Second is a Mx3 array of face vertex connectivity data.');
                error('Check the arguments!');
            end
            
            obj = obj@Abstract_LevelSet();
            
            obj.Grid.Vtx      = varargin{1};
            obj.Grid.Tri      = varargin{2};
            
        end
    end
end

% END %