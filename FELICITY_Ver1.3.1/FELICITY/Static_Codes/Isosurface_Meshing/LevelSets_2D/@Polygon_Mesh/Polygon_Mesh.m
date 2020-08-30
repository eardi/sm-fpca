% Concrete Base Class for performing in/out tests
classdef Polygon_Mesh < Abstract_LevelSet
    properties %(SetAccess = private)
    end
    methods
        function obj = Polygon_Mesh(varargin)
            
            if nargin ~= 2
                disp('Requires 2 arguments!');
                disp('First  is a Nx2 array of vertex coordinates.');
                disp('Second is a Mx2 array of edge vertex connectivity data.');
                error('Check the arguments!');
            end
            
            obj = obj@Abstract_LevelSet();
            
            obj.Grid.Vtx      = varargin{1};
            obj.Grid.Edge     = varargin{2};
            
        end
    end
end

% END %