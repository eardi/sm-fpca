% FELICITY Class for 2-D Triangle Meshes.
%
%   obj  = MeshTriangle(Tri,Vtx,Name);
%
%   Tri  = Rx3 matrix representing the triangle connectivity of the 2-D mesh;
%          R = number of elements.
%   Vtx  = MxD matrix representing the coordinates of the vertices; M = number
%          of vertices, and D = geometric dimension.
%   Name = (string) name for the domain that the mesh represents.
classdef MeshTriangle < AbstractMesh & TriRep
    properties %(Access = private)
        
    end
    methods
        function obj = MeshTriangle(varargin)
            
            if (nargin ~= 3)
                disp('Requires 3 arguments!');
                disp('First  is cell connectivity.');
                disp('Second is vertex coordinates.');
                disp('Third  is an appropriate name for what the mesh represents (domain).');
                error('Check the arguments!');
            end
            
            obj = obj@AbstractMesh(varargin{3});
            obj = obj@TriRep(varargin{1},varargin{2});
            
            %OUT_str  = '|---> Create MeshTriangle Object...';
            %disp(OUT_str);
            
            TD = obj.Top_Dim;
            if (TD~=2)
                disp('Cell connectivity must have 3 columns for triangle mesh!');
                error('Triangle mesh must have topological dimension 2!');
            end
            
            GD = obj.Geo_Dim;
            if (GD==2)
                VOL = obj.Volume;
                if (min(VOL) <= 0)
                    error('Triangle mesh has inverted (or degenerate) elements!');
                end
            end
        end
    end
end

% END %