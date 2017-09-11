function [Cell, Vtx] = Abstract_Reorder(obj)
%Abstract_Reorder
%
%   This renumbers the mesh vertices to give a tighter adjacency matrix.
%
%   [Cell, Vtx] = obj.Abstract_Reorder;
%
%   Cell = the new "obj.Triangulation".
%   Vtx  = the new "obj.X".

% Copyright (c) 08-19-2009,  Shawn W. Walker

[Order, Inv_Order] = obj.Get_Node_Reordering();

% init
Cell = obj.Triangulation;
Vtx  = obj.X;

% reorder vertex indices
Cell(:) = Inv_Order(Cell(:));

% reorder vertex coordinates to match
Vtx = Vtx(Order,:);

end