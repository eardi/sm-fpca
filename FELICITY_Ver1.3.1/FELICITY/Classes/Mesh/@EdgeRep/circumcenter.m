function [Center, Edge_Length] = circumcenter(obj,EI)
%circumcenter
%
%   This mimics the analogous MATLAB:triangulation method.
%
%   [Center, Edge_Length] = obj.circumcenter(EI);
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
    Center = 0.5 * (obj.Points(obj.ConnectivityList(:,1),:) + obj.Points(obj.ConnectivityList(:,2),:));
    EI = [];
else
    Center = 0.5 * (obj.Points(obj.ConnectivityList(EI,1),:) + obj.Points(obj.ConnectivityList(EI,2),:));
end

[ET, Edge_Length] = obj.edgeTangents(EI);

end