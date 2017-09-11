% FELICITY Class for 1-D Meshes.
%
%   obj  = MeshInterval(Edge,Vtx,Name);
%
%   Edge = Rx2 matrix representing the edge connectivity of the 1-D mesh; R =
%          number of elements.
%   Vtx  = MxD matrix representing the coordinates of the vertices; M = number
%          of vertices, and D = geometric dimension.
%   Name = (string) name for the domain that the mesh represents.
classdef MeshInterval < AbstractMesh & EdgeRep
    properties %(Access = private)
        
    end
    methods
        function obj = MeshInterval(varargin)
            
            if (nargin ~= 3)
                disp('Requires 3 arguments!');
                disp('First  is cell connectivity.');
                disp('Second is vertex coordinates.');
                disp('Third  is an appropriate name for what the mesh represents (domain).');
                error('Check the arguments!');
            end
            
            obj = obj@AbstractMesh(varargin{3});
            obj = obj@EdgeRep(varargin{1},varargin{2});
            
            %OUT_str  = '|---> Create MeshInterval Object...';
            %disp(OUT_str);
            
            TD = obj.Top_Dim;
            if (TD~=1)
                disp('Cell connectivity must have 2 columns for interval (edge) mesh!');
                error('Edge mesh must have topological dimension 1!');
            end
            
            GD = obj.Geo_Dim;
            if (GD==1)
                VOL = obj.Volume;
                if min(VOL) <= 0
                    error('Edge mesh has inverted (or degenerate) elements!');
                end
            end
        end
    end
end

% END %