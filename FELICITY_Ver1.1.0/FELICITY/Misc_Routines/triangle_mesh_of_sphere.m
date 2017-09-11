function [TRI, VTX] = triangle_mesh_of_sphere(Center,Radius,Refine_Level)
%triangle_mesh_of_sphere
%
%   This generates a 2-D mesh of the surface of a sphere.
%
%   [TRI, VTX] = triangle_mesh_of_sphere(Center,Radius,Refine_Level)
%
%   Center = (length 3 vector) containing the coordinates of the center of the
%            sphere.
%   Radius = desired radius of the sphere.
%   Refine_Level = number of times to uniformly refine the mesh.  Larger the
%                  number, finer the mesh.
%   Example: Refine_Level = 0 gives a mesh that is an octahedron approximating
%            the sphere.
%            Refine_Level = 1 gives a uniform (1to4) refinement of the octhedron
%            case.
%            etc...
%
%   TRI = Mx3 matrix containing triangle connectivity data.
%   VTX = Qx3 matrix of vertex coordinates.
%
%   Note: as Refine_Level increases, the minimum angle in the triangulation
%         approaches 45 degrees and the maximum angle approaches 90 degrees.

% Copyright (c) 05-03-2013,  Shawn W. Walker

% define unit sphere domain with initial coarse mesh
VTX = (1/sqrt(2))*[1, 1; -1, 1; -1, -1; 1, -1; 0, 0; 0, 0];
VTX = [VTX, zeros(6,1)];
VTX(5,3) = 1;
VTX(6,3) = -1;
TRI = [1, 2, 5; 2, 3, 5; 3, 4, 5; 4, 1, 5;
             2, 1, 6; 3, 2, 6; 4, 3, 6; 1, 4, 6];
% uniform refinement
for ind = 1:Refine_Level
    MT = (1:1:size(TRI,1))';
    [VTX, TRI] = Refine_Entire_Mesh(VTX,TRI,[],MT);
    MAG1 = sqrt(sum(VTX.^2,2));
    VTX(:,1) = VTX(:,1) ./ MAG1;
    VTX(:,2) = VTX(:,2) ./ MAG1;
    VTX(:,3) = VTX(:,3) ./ MAG1;
end

% scale and shift
VTX = Radius * VTX;
VTX(:,1) = VTX(:,1) + Center(1);
VTX(:,2) = VTX(:,2) + Center(2);
VTX(:,3) = VTX(:,3) + Center(3);

end