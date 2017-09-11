% Simple Class for 1-D Meshes (mimics MATLAB's TriRep)
%
%   obj  = EdgeRep(Edge,Vtx);
%
%   Edge = Rx2 matrix representing the edge connectivity of the 1-D mesh; R =
%          number of elements.
%   Vtx  = MxD matrix representing the coordinates of the vertices; M = number
%          of vertices, and D = geometric dimension.
classdef EdgeRep
    properties (SetAccess = private)
        X
        Triangulation
    end
    methods
        function obj = EdgeRep(varargin)
            
            if (nargin ~= 2)
                disp('Requires 2 arguments!');
                disp('First  is cell connectivity.');
                disp('Second is vertex coordinates.');
                error('Check the arguments!');
            end
            
            obj.X = varargin{2};
            obj.Triangulation = varargin{1};
            
            if (size(obj.Triangulation,2)~=2)
                error('Cell connectivity must have 2 columns for edge (interval) mesh!');
            end
            if (size(obj.X,2)<1)
                error('Vertices must have at least one coordinate value!');
            end
            Min_Ind = min(obj.Triangulation(:));
            Max_Ind = max(obj.Triangulation(:));
            if (Min_Ind <= 0)
                error('Indices in triangulation must be positive.');
            end
            if (Max_Ind > size(obj.X,1))
                error('Indices in triangulation are greater than the number of given vertices!');
            end
        end
    end
end

% END %