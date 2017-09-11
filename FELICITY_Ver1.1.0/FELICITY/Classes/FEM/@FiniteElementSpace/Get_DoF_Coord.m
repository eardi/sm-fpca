function Coords = Get_DoF_Coord(obj,Mesh)
%Get_DoF_Coord
%
%   This returns the spatial coordinates of each global DoF in the FE space.
%
%   Note: this assumes the mesh is piecewise linear (no curved elements).  If
%   you have a curved mesh, then you need a different routine.
%
%   Coords = obj.Get_DoF_Coord(Mesh);
%
%   Mesh = (FELICITY mesh) this is the mesh that the FE space is defined on.
%
%   Coords = MxD matrix of space coordinates, where D is the geometric
%            dimension of 'Mesh'.
%
%   Note: M = the number of global DoF indices. If the space is tensor-valued, then M is
%         the number of global DoF indices for ONE component only; note that all
%         components of a tensor-valued space share the same DoF coordinates.
%         Row i of Coords corresponds to global DoF index = i; again, if the space is
%         tensor-valued, then i refers to the global DoF index of component 1 only.

% Copyright (c) 08-04-2014,  Shawn W. Walker

[SI, BC] = obj.Get_DoF_Bary_Coord(Mesh);

Coords = Mesh.baryToCart(SI, BC);

end