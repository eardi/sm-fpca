function [SI, BC] = Get_DoF_Bary_Coord(obj,Mesh)
%Get_DoF_Bary_Coord
%
%   For each global DoF in the FE space, this returns a simplex index in the
%   global mesh that contains the DoF, and the associated barycentric
%   coordinates for the DoF (relative to that simplex).
%
%   [SI, BC] = obj.Get_DoF_Bary_Coord(Mesh);
%
%   Mesh = (FELICITY mesh) this is the mesh that the FE space is defined on.
%
%   SI = column vector (length M) of mesh element (cell) indices.
%   BC = Mx(T+1) matrix of barycentric coordinates, where T is the topological
%        dimension of 'Mesh'.
%
%   Note: M = the number of global DoF indices. If the space is tuple-valued, then M is
%         the number of global DoF indices for ONE component only; note that all
%         components of a tuple-valued space share the same DoF coordinates.
%         Row i of [SI, BC] corresponds to global DoF index = i; again, if the space is
%         tuple-valued, then i refers to the global DoF index of component 1 only.

% Copyright (c) 08-04-2014,  Shawn W. Walker

obj.Verify_Mesh(Mesh);

[R, C] = obj.Get_Element_Info_For_Each_DoF;

% get the enclosing cell index for each subdomain element
if ~isempty(obj.Mesh_Info.SubName)
    SI = Mesh.Subdomain(obj.Mesh_Info.SubIndex).Data(R,1);
    SI = double(SI);
else % finite element space is defined on the global mesh
    SI = R;
end

% get barycentric coordinates on each subdomain element
Sub_BC = obj.RefElem.Nodal_Data.BC_Coord(C,:);

% get the local topological entity index of each subdomain element relative to
% its enclosing cell (remember, the finite element space is defined on the
%                     subdomain)
if ~isempty(obj.Mesh_Info.SubName)
    if (Mesh.Subdomain(obj.Mesh_Info.SubIndex).Dim < Mesh.Top_Dim)
        Local_Sub_Indices = Mesh.Subdomain(obj.Mesh_Info.SubIndex).Data(R,2);
    else % subdomain topological dimension is the same as the global mesh
        Local_Sub_Indices = [];
    end
else % finite element space is defined on the global mesh
    Local_Sub_Indices = [];
end

BC = obj.Lift_Barycentric_Coord_to_Enclosing_Cell(Mesh,Sub_BC,Local_Sub_Indices);

end