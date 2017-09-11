function [EDGE, VTX] = interval_mesh_of_circle(Center,Radius,Num_Vtx)
%interval_mesh_of_circle
%
%   This generates a uniform mesh of a circle.
%
%   [EDGE, VTX] = interval_mesh_of_circle(Center,Radius,Num_Vtx);
%
%   Center = (length 2 vector) containing the coordinates of the center of the circle.
%   Radius = desired radius of the disk.
%   Num_Vtx = number of vertices to use.
%
%   EDGE = Mx2 matrix containing edge connectivity data.
%   VTX  = Qx2 matrix of vertex coordinates.

% Copyright (c) 02-06-2015,  Shawn W. Walker

t_vec = linspace(0,1,Num_Vtx+1)';
t_vec(end) = [];
x_vec = cos(2*pi*t_vec);
y_vec = sin(2*pi*t_vec);
VTX = [x_vec, y_vec];
ind1 = [(1:1:Num_Vtx)'; 1];
EDGE = [ind1(1:end-1), ind1(2:end)];

% scale and shift
VTX = Radius * VTX;
VTX(:,1) = VTX(:,1) + Center(1);
VTX(:,2) = VTX(:,2) + Center(2);

end