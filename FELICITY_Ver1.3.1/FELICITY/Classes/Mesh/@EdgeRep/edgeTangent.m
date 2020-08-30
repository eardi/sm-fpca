function [ET, Edge_Length] = edgeTangent(obj,EI)
%edgeTangent
%
%   This mimics the analogous MATLAB:TriRep method (faceNormal).
%
%   [ET, Edge_Length] = obj.edgeTangent(EI);
%
%   EI = column vector (length M) of edge (cell) indices in the mesh; optional
%        argument.  If absent, then all edges in the mesh are considered.
%
%   ET = MxD matrix of unit tangent vectors of each edge, where D = geometric
%        dimension; ith row corresponds to the ith edge in EI.
%   Edge_Length = column vector (length M) containing euclidean lengths of each
%                 edge.

% Copyright (c) 04-13-2011,  Shawn W. Walker

if (nargin < 2)
    VEC = obj.Points(obj.ConnectivityList(:,2),:) - obj.Points(obj.ConnectivityList(:,1),:);
else
    VEC = obj.Points(obj.ConnectivityList(EI,2),:) - obj.Points(obj.ConnectivityList(EI,1),:);
end

Edge_Length = sqrt(sum(VEC.^2,2));

ET = VEC;
for ind = 1:size(ET,2)
    ET(:,ind) = ET(:,ind) ./ Edge_Length;
end

end