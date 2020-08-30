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
        Points
        ConnectivityList
    end
    methods
        function obj = EdgeRep(varargin)
            
            if (nargin ~= 2)
                disp('Requires 2 arguments!');
                disp('First  is cell connectivity.');
                disp('Second is vertex coordinates.');
                error('Check the arguments!');
            end
            
            obj.Points = varargin{2};
            obj.ConnectivityList = varargin{1};
            
            if (size(obj.ConnectivityList,2)~=2)
                error('Cell connectivity must have 2 columns for edge (interval) mesh!');
            end
            if (size(obj.Points,2)<1)
                error('Vertices must have at least one coordinate value!');
            end
            Min_Ind = min(obj.ConnectivityList(:));
            Max_Ind = max(obj.ConnectivityList(:));
            if (Min_Ind <= 0)
                error('Indices in triangulation must be positive.');
            end
            if (Max_Ind > size(obj.Points,1))
                error('Indices in triangulation are greater than the number of given vertices!');
            end
        end
    end
end

% END %