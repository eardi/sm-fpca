function [T,V] = regular_triangle_mesh(nx,ny)
%regular_triangle_mesh
%
%   [T,V] = regular_triangle_mesh(nx,ny)
%
%   Generates a "regular" 2-D lattice/triangle mesh of the unit square [0, 1] x [0, 1] with
%             number of points along the x and y axes given by: (nx,ny).
%
%   Input:
%     nx  number of points in x direction on grid
%     ny  number of points in y direction on grid
%   Output:
%     T  triangle list of indices into V
%     V  list of vertex coordinates in 2D
%
%   Example
%     [T,V] = regular_triangle_mesh(3,3);
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

% create the cell connectivity
T = [ ...
    v1  v3  v4;
    v1  v4  v2];
%

end