function [T,V] = bcc_tetrahedral_cube(nx,ny,nz)
%bcc_tetrahedral_cube
%
%   [T,V] = bcc_tetrahedral_cube(nx,ny,nz)
%
%   Generates a BCC lattice/tetrahedral mesh with dimensions (nx,ny,nz).
%   The domain is exactly [0,1]^3; so the BCC lattice is not quite
%   respected at the boundary, but this is ok.
%
%   Input:
%     nx  number of points in x direction on grid
%     ny  number of points in y direction on grid
%     nz  number of points in z direction on grid
%   Output:
%     T  tetrahedra list of indices into V
%     V  list of vertex coordinates in 3D
%
%   Example
%     [T,V] = bcc_tetrahedral_cube(3,3,3);
%     tetramesh(T,V); %also try tetramesh(T,V,'FaceAlpha',0);
%
% See also delaunayn, tetramesh

% first generate the initial mesh
[~, V0] = bcc_tetrahedral_mesh(nx,ny,nz,false);

% find all vertices above the x=1, y=1, and z=1 planes
x1_mask = V0(:,1) > 1 + 1e-11;
y1_mask = V0(:,2) > 1 + 1e-11;
z1_mask = V0(:,3) > 1 + 1e-11;
V_ind = (1:1:size(V0,1))';
V0_x1_ind = V_ind(x1_mask,1);
V0_y1_ind = V_ind(y1_mask,1);
V0_z1_ind = V_ind(z1_mask,1);

% move those vertices to exactly the x=1, y=1, and z=1 planes
V0(V0_x1_ind,1) = 1;
V0(V0_y1_ind,2) = 1;
V0(V0_z1_ind,3) = 1;

% copy those vertices, and move to exactly the x=0, y=0, and z=0 planes
V1_x0 = V0(V0_x1_ind,:);
V1_x0(:,1) = 0;
V1_y0 = V0(V0_y1_ind,:);
V1_y0(:,2) = 0;
V1_z0 = V0(V0_z1_ind,:);
V1_z0(:,3) = 0;

% add the vertex at the origin
V1_O = [0,0,0];

% collect the vertices
V = [V0; V1_x0; V1_y0; V1_z0; V1_O];

% now, mesh it
T = delaunay(V);

end