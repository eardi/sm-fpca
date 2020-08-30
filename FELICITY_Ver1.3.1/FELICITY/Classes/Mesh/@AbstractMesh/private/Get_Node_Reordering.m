function [Order, Inv_Order] = Get_Node_Reordering(obj)
%Get_Node_Reordering
%
%   This produces the re-ordering map for the mesh nodes to give a tighter
%   adjacency matrix.
%
%   [Order, Inv_Order] = obj.Get_Node_Reordering;
%
%   Order = column vector representing map from old vertex index to new index.
%   Inv_Order = column vector representing the *inverse* map.

% Copyright (c) 08-19-2009,  Shawn W. Walker

Adj_Mat = obj.Get_Adjacency_Matrix();

% re-ordering map
%Order = symrcm(Adj_Mat)';
%Order = symamd(Adj_Mat)';
Order = colperm(Adj_Mat)';

temp = sortrows([(1:1:obj.Num_Vtx)', Order],2);
% inverse map
Inv_Order = temp(:,1);

end