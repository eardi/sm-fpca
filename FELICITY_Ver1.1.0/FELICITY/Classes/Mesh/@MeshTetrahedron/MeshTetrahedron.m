% FELICITY Class for 3-D Tetrahedron Meshes.
%
%   obj  = MeshTetrahedron(Tet,Vtx,Name);
%
%   Tet  = Rx4 matrix representing the tetrahedron connectivity of the 3-D mesh;
%          R = number of elements.
%   Vtx  = MxD matrix representing the coordinates of the vertices; M = number
%          of vertices, and D = geometric dimension (must be 3).
%   Name = (string) name for the domain that the mesh represents.
classdef MeshTetrahedron < AbstractMesh & TriRep
    properties %(Access = private)
        
    end
    methods
        function obj = MeshTetrahedron(varargin)
            
            if (nargin ~= 3)
                disp('Requires 3 arguments!');
                disp('First  is cell connectivity.');
                disp('Second is vertex coordinates.');
                disp('Third  is an appropriate name for what the mesh represents (domain).');
                error('Check the arguments!');
            end
            
            obj = obj@AbstractMesh(varargin{3});
            obj = obj@TriRep(varargin{1},varargin{2});
            
            %OUT_str  = '|---> Create MeshTetrahedron Object...';
            %disp(OUT_str);
            
            TD = obj.Top_Dim;
            if (TD~=3)
                disp('Cell connectivity must have 4 columns for tetrahedron mesh!');
                error('Tetrahedron mesh must have topological dimension 3!');
            end
            
            VOL = obj.Volume;
            if min(VOL) <= 0
                error('Tetrahedron mesh has inverted (or degenerate) elements!');
            end
        end
    end
end

% END %