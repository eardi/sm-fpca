function [T,V] = bcc_triangle_mesh(nx,ny)
%bcc_triangle_mesh
%
%   [T,V] =  bcc_triangle_mesh(nx,ny)
%
%   Generates a "BCC" 2-D lattice/triangle mesh of the unit square [0, 1] x [0, 1] with
%             number of points along the x and y axes given by: (nx,ny).
%   Note: this is the standard 2-D criss-cross grid.
%
%   Input:
%     nx  number of points in x direction on grid
%     ny  number of points in y direction on grid
%   Output:
%     T  triangle list of indices into V
%     V  list of vertex coordinates in 2D
%
%   Example
%     [T,V] = bcc_triangle_mesh(3,3);
%     trimesh(T,V(:,1),V(:,2));
%
% See also delaunay, trimesh

if or( nx < 2 , ny < 2 )
    error('Must be at least 2 points in all two directions!');
end

% Create a grid
[x,y] = meshgrid(linspace(0,1,nx),linspace(0,1,ny));
V = [x(:) y(:)];
% meshgrid flips x and y ordering
idx = reshape(1:prod([ny,nx]),[ny,nx]);
% local vertex numbering
v1 = idx(1:end-1,1:end-1);v1=v1(:);
v2 = idx(2:end,1:end-1);v2=v2(:);
v3 = idx(1:end-1,2:end);v3=v3(:);
v4 = idx(2:end,2:end);v4=v4(:);

% cell dimensions
Cell_X = (1/(nx-1));
Cell_Y = (1/(ny-1));

% create BCC coordinates
New_BCC = V(v1,:);
New_BCC(:,1) = New_BCC(:,1) + Cell_X/2;
New_BCC(:,2) = New_BCC(:,2) + Cell_Y/2;

Num_Cells = (nx-1) * (ny-1);
if (size(New_BCC,1)~=Num_Cells)
    error('Number of cells does not match number of center vertices.');
end

v5 = (1:1:Num_Cells)' + size(V,1);
V = [V; New_BCC]; % v5 is linked to v1~v4

% create the cell connectivity
T = [ ...
    v1  v3  v5;
    v3  v4  v5;
    v4  v2  v5;
    v2  v1  v5];
%

end