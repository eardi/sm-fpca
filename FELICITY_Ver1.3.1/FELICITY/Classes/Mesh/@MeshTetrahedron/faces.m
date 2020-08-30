function FACE = faces(obj)
%faces
%
%   This returns a unique list of triangle faces in the 3-D triangulation.
%   Note: this is analogous to the "obj.edges" method.
%
%   FACE = obj.faces;
%
%   FACE = mesh triangular faces contained in the tetrahedral mesh.

% Copyright (c) 10-17-2016,  Shawn W. Walker

TET = obj.ConnectivityList;

% collect all faces (and sort!)
All_Faces = sort([TET(:,[2 3 4]); TET(:,[1 4 3]); TET(:,[1 2 4]); TET(:,[1 3 2])],2);

% get the unique set of faces contained in the mesh
FACE = unique(All_Faces,'rows');

end