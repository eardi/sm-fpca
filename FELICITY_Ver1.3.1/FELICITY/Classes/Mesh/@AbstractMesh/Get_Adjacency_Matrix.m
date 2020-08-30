function Adj_Mat = Get_Adjacency_Matrix(obj)
%Get_Adjacency_Matrix
%
%   This outputs the adjacency matrix for the vertices in the mesh.
%
%   Adj_Mat = obj.Get_Adjacency_Matrix;
%
%   Adj_Mat = sparse matrix representing which vertices are adjacent to each
%             other.

% Copyright (c) 04-15-2011,  Shawn W. Walker

Num_Vtx = obj.Num_Vtx;
Edge    = obj.edges;

% Note: Tim Davis' "sparse2" is at least 50% faster
Adj_Mat = sparse(Edge(:,1),Edge(:,2),1,Num_Vtx,Num_Vtx);

end