function [Center, Edge_Length] = circumcenters(obj,EI)
%circumcenters
%
%   This mimics the analogous MATLAB:TriRep method.
%
%   [Center, Edge_Length] = obj.circumcenters(EI);
%
%   EI = column vector (length M) of edge (cell) indices in the mesh; optional
%        argument.  If absent, then all edges in the mesh are considered.
%
%   Center = MxD matrix of coordinates of the midpoints of each edge, where D =
%            geometric dimension.
%   Edge_Length = column vector (length M) containing euclidean lengths of each
%                 edge.

% Copyright (c) 04-13-2011,  Shawn W. Walker

if (nargin < 2)
    Center = 0.5 * (obj.X(obj.Triangulation(:,1),:) + obj.X(obj.Triangulation(:,2),:));
    EI = [];
else
    Center = 0.5 * (obj.X(obj.Triangulation(EI,1),:) + obj.X(obj.Triangulation(EI,2),:));
end

[ET, Edge_Length] = obj.edgeTangents(EI);

end