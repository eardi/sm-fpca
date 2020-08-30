function Coords = Get_DoF_Coord(obj,Mesh,GeoSpace,GeoFunc)
%Get_DoF_Coord
%
%   This returns the spatial coordinates of each global DoF in the FE space.
%
%   Coords = obj.Get_DoF_Coord(Mesh);
%
%   Mesh = (FELICITY mesh) this is the mesh that the FE space is defined on.
%
%   Coords = MxD matrix of space coordinates, where D is the geometric
%            dimension of 'Mesh'.
%
%   Note: this assumes the mesh is piecewise linear (no curved elements).  If
%   you have a curved mesh, then use the alternative calling procedure below.
%
%   Note: M = the number of global DoF indices. If the space is tuple-valued, then M is
%         the number of global DoF indices for ONE component only; note that all
%         components of a tuple-valued space share the same DoF coordinates.
%         Row i of Coords corresponds to global DoF index = i; again, if the space is
%         tuple-valued, then i refers to the global DoF index of component 1 only.
%
%   Alternative calling procedure:
%
%   Coords = obj.Get_DoF_Coord(Mesh,GeoSpace,GeoFunc);
%
%   GeoSpace = (FELICITY GeoElementSpace object) used for defining higher
%              order geometry.
%   GeoFunc  = RxD matrix of nodal values, where R is the number of DoFs in
%              GeoSpace and D is the ambient dimension.  GeoFunc represents
%              a function in GeoSpace; basically, this defines the mapping
%              to use when defining (curved) mesh elements.

% Copyright (c) 03-26-2018,  Shawn W. Walker

[SI, BC] = obj.Get_DoF_Bary_Coord(Mesh);

if (nargin==2)
    %GeoSpace = [];
    %GeoFunc = [];
    % treat the mesh as a lowest order piecewise linear continuous object
    % i.e. this is the standard case.
    Coords = Mesh.barycentricToCartesian(SI, BC);
else
    % treat the mesh as higher order piecewise whatever continuous object
    Ref_Coord = Mesh.barycentricToReference(BC);
    Interp_Points = {uint32(SI), Ref_Coord};
    Coords = GeoSpace.Interpolate(Mesh,GeoFunc,Interp_Points);
end

end