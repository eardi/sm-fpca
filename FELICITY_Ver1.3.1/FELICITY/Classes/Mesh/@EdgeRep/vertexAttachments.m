function EI = vertexAttachments(obj,VI)
%vertexAttachments
%
%   This mimics the analogous MATLAB:TriRep method.  This routine is slightly
%   limited, because it assumes that every vertex has, at most, 2 edges
%   attached to it.
%
%   EI = obj.vertexAttachments(VI);
%
%   VI = column vector (length M) of vertex indices in the mesh; optional
%        argument.  If absent, then all vertices in the mesh are considered.
%
%   EI = Mx2 matrix of edge (cell) indices in the mesh.  EI(i) contains the
%        edge indices that are attached to vertex VI(i).  An entry of 0
%        indicates no edge.  Moreover, given VI(i), the first column
%        EI(i,1) contains the edge index that contains VI(i) as the first
%        vertex; similarly for the second column.  In other words,
%        VI(i) = obj.Mesh.ConnectivityList(EI(i,j),j), for j = 1,2.

% Copyright (c) 04-13-2011,  Shawn W. Walker

if nargin < 2
    VI = (1:1:size(obj.Points,1))';
end

EI = zeros(length(VI),2);

% find edges where VI is the tail (first vertex)
[TF, LOC] = ismember(VI,obj.ConnectivityList(:,1));
EI(TF,1) = LOC(TF);

% find edges where VI is the head (second vertex)
[TF, LOC] = ismember(VI,obj.ConnectivityList(:,2));
EI(TF,2) = LOC(TF);

end