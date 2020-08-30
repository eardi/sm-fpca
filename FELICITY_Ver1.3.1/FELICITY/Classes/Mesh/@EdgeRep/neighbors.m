function EN = neighbors(obj,EI)
%neighbors
%
%   This mimics the analogous MATLAB:TriRep method.  DEPENDS on
%   vertexAttachments.
%
%   EN = obj.neighbors(EI);
%
%   EI = column vector (length M) of edge (cell) indices in the mesh; optional
%        argument.  If absent, then all edges in the mesh are considered.
%
%   EN = Mx2 matrix of edge indices.  Entry (i,j) is the edge index (in EI) that is the
%        neighbor of edge i (in EI) opposite to local vertex j (j = 1 or 2).
%        Note: an entry of zero indicates that the neighbor does not exist.
%
%   Example 1-D mesh:
%             E1         E2         E3
%        |----->----|----->----|----->----|
%        V1         V2         V3         V4
%
%        E1 = [V1, V2]  --->  neighbors are [2 0]
%        E2 = [V2, V3]  --->  neighbors are [3 1]
%        E3 = [V3, V4]  --->  neighbors are [0 2]
%
%        The corresponding neighbor structure is:
%        NB = [2 0; 3 1; 0 2];

% Copyright (c) 07-25-2014,  Shawn W. Walker

if nargin < 2
    EI = (1:1:obj.size(1))';
end
EN = zeros(length(EI),2);

attached_edges = obj.vertexAttachments;
Non_Zero_Tail = (attached_edges(:,1) > 0);
Non_Zero_Head = (attached_edges(:,2) > 0);
Both_Non_Zero = Non_Zero_Tail & Non_Zero_Head;

EN(attached_edges(Both_Non_Zero,2),1) = attached_edges(Both_Non_Zero,1);
EN(attached_edges(Both_Non_Zero,1),2) = attached_edges(Both_Non_Zero,2);

end