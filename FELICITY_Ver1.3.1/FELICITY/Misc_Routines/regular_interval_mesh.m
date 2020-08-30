function [E,V] = regular_interval_mesh(nx)
%regular_interval_mesh
%
%   [E,V] = regular_interval_mesh(nx)
%
%   Generates a "regular" 1-D lattice/interval mesh of the unit interval [0, 1]
%   with number of points along the x axe given by: (nx).
%
%   Input:
%     nx  number of points in x direction on grid
%   Output:
%     E  edge list of indices into V
%     V  list of vertex coordinates in 1D
%
%   Example
%     [E,V] = regular_interval_mesh(5);
%     edgemesh(E,V);
%
% See also edgemesh

if ( nx < 2 )
    error('Must be at least 2 points in x direction!');
end

Vtx_Indices = (1:1:nx)';
E = [Vtx_Indices(1:end-1,1), Vtx_Indices(2:end,1)];
V = linspace(0,1,nx)';

end