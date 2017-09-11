function Tri_Neighbor_Array = Get_Triangle_Neighbors(Num_Vertices,Tri_Elem)
%Get_Triangle_Neighbors
%
%   This routine creates a data structure that tells which triangles belong to pairs
%   of vertices in a triangle mesh.
%
%   Tri_Neighbor_Array = Get_Triangle_Neighbors(Num_Vertices,Tri_Elem)
%
%   OUTPUTS
%   -------
%   Vtx_Tri_Neighbor_Array:
%       An NxN array (N = Num_Vertices) that contains the data structure.  So, for
%       example, if you look at element (5,76) in this array, then the entry there
%       tells you the index of the triangle that the DIRECTED side (i.e. the vector
%       that goes from vertex #5 to vertex #76) belongs to.  And note that the entry
%       at (76,5) in the array will give a different triangle index than at (5,76)
%       because the sides are DIRECTED.  An entry of '0' at location (r,c) means that
%       the vector from vertex #r to vertex #c is NOT a DIRECTED side in any of the
%       triangles in the mesh.
%
%   INPUTS
%   ------
%   Num_Vertices:
%       The number of vertices in the mesh.
%
%   Tri_Elem:
%       An Mx3 array containing the mesh triangle data structure.

% Copyright (c) 08-18-2006,  Shawn W. Walker

% setup a list of vertex indices, where each row gives the two vertices that
% determine one DIRECTED side of a triangle.  So, here all the 1st sides of each
% triangle are listed, followed by all the 2nd sides, then by the 3rd sides.
Tri_Side_Vtx_Indices = [Tri_Elem(:,1:2); Tri_Elem(:,2:3); Tri_Elem(:,[3 1])];

% setup a list of indices to each triangle in the mesh
Tri_Indices_0 = (1:1:size(Tri_Elem,1))';

% duplicate this so that for each triangle side, we know the triangle it belongs to
Tri_Indices = [Tri_Indices_0; Tri_Indices_0; Tri_Indices_0];

% put it into a sparse matrix (could use sparse2 here)
Tri_Neighbor_Array = sparse(Tri_Side_Vtx_Indices(:,1),Tri_Side_Vtx_Indices(:,2),...
                            Tri_Indices,Num_Vertices,Num_Vertices);

% Here is some equivalent (slow) code:
% Tri_Neighbor_Array = sparse(Num_Vertices, Num_Vertices);
% for t_index = 1:size(Tri_Elem,1)
%     Tri_Neighbor_Array(Tri_Elem(t_index,1),Tri_Elem(t_index,2)) = t_index;
%     Tri_Neighbor_Array(Tri_Elem(t_index,2),Tri_Elem(t_index,3)) = t_index;
%     Tri_Neighbor_Array(Tri_Elem(t_index,3),Tri_Elem(t_index,1)) = t_index;
% end

% END %