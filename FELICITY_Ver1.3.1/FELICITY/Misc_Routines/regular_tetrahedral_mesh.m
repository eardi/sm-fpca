function [T,V] = regular_tetrahedral_mesh(nx,ny,nz)
%regular_tetrahedral_mesh
%
% [T,V] = regular_tetrahedral_mesh(nx,ny,nz)
%
% Generates a regular tetrahedral mesh of the unit cube with number of grid
% points in each dimension given by (nx,ny,nz).
%
% Input:
%   nx  number of points in x direction on grid
%   ny  number of points in y direction on grid
%   nz  number of points in z direction on grid
% Output:
%   T  tetrahedra list of indices into V
%   V  list of vertex coordinates in 3D
%
% Example
%    [T,V] = regular_tetrahedral_mesh(3,3,3);
%    tetramesh(T,V); %also try tetramesh(T,V,'FaceAlpha',0);
%
% written by: http://www.alecjacobson.com/weblog/
%
% See also delaunayn, tetramesh

if or( nx < 2 , or( ny < 2 , nz < 2 ) )
    error('Must be at least 2 points in all three directions!');
end

% Create a grid
[x,y,z] = meshgrid(linspace(0,1,nx),linspace(0,1,ny),linspace(0,1,nz));
V = [x(:) y(:) z(:)];
% meshgrid flips x and y ordering
idx = reshape(1:prod([ny,nx,nz]),[ny,nx,nz]);
v1 = idx(1:end-1,1:end-1,1:end-1);v1=v1(:);
v2 = idx(1:end-1,2:end,1:end-1);v2=v2(:);
v3 = idx(2:end,1:end-1,1:end-1);v3=v3(:);
v4 = idx(2:end,2:end,1:end-1);v4=v4(:);
v5 = idx(1:end-1,1:end-1,2:end);v5=v5(:);
v6 = idx(1:end-1,2:end,2:end);v6=v6(:);
v7 = idx(2:end,1:end-1,2:end);v7=v7(:);
v8 = idx(2:end,2:end,2:end);v8=v8(:);
% create the cell connectivity
T = [ ...
    v1  v8  v3  v7; ...
    v1  v5  v8  v7; ...
    v1  v4  v3  v8; ...
    v1  v2  v4  v8; ...
    v1  v5  v6  v8; ...
    v1  v6  v2  v8];
%

% NOTE: the original code is what is below, but that makes Tets with a negative
% volume.  So we swapped 2 of the columns.
% T = [ ...
%     v1  v3  v8  v7; ...
%     v1  v8  v5  v7; ...
%     v1  v3  v4  v8; ...
%     v1  v4  v2  v8; ...
%     v1  v6  v5  v8; ...
%     v1  v2  v6  v8];
end