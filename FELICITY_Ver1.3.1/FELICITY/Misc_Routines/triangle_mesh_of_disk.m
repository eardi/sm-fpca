function [TRI, VTX] = triangle_mesh_of_disk(Center,Radius,Refine_Level)
%triangle_mesh_of_disk
%
%   This generates a 2-D mesh of a disk (circle).
%
%   [TRI, VTX] = triangle_mesh_of_disk(Center,Radius,Refine_Level)
%
%   Center = (length 2 vector) containing the coordinates of the center of the disk.
%   Radius = desired radius of the disk.
%   Refine_Level = number of times to uniformly refine the mesh.  Larger the
%                  number, finer the mesh.
%   Example: Refine_Level = 0 gives a mesh that is a square (4 triangles) approximating
%            the disk.
%            Refine_Level = 1 gives a uniform (1to4) refinement of the 4 triangle case.
%            etc...
%
%   TRI = Mx3 matrix containing triangle connectivity data.
%   VTX = Qx2 matrix of vertex coordinates.
%
%   Note: as Refine_Level increases, the minimum angle in the triangulation
%         approaches ~32.5 degrees; the maximum angle is always 90 degrees.

% Copyright (c) 08-14-2014,  Shawn W. Walker

% define unit disk domain (centered at origin) with initial coarse mesh
VTX = (1/sqrt(2))*[1, 1; -1, 1; -1, -1; 1, -1; 0, 0];
TRI = [4, 1, 5; 1, 2, 5; 2, 3, 5; 3, 4, 5];

% uniform refinement
for ind = 1:Refine_Level
    MT = (1:1:size(TRI,1))';
    [VTX, TRI] = Refine_Entire_Mesh(VTX,TRI,[],MT);
    VTX = project_bdy(VTX, TRI);
end

% scale and shift
VTX = Radius * VTX;
VTX(:,1) = VTX(:,1) + Center(1);
VTX(:,2) = VTX(:,2) + Center(2);

end

function VTX = project_bdy(VTX, TRI)

TR = triangulation(TRI, VTX);
Bdy_Edge = TR.freeBoundary;
Bdy_Indices = unique(Bdy_Edge(:));
Bdy_Vtx = VTX(Bdy_Indices,:);
MAG1 = sqrt(sum(Bdy_Vtx.^2,2));
Bdy_Vtx(:,1) = Bdy_Vtx(:,1) ./ MAG1;
Bdy_Vtx(:,2) = Bdy_Vtx(:,2) ./ MAG1;
VTX(Bdy_Indices,:) = Bdy_Vtx;

end