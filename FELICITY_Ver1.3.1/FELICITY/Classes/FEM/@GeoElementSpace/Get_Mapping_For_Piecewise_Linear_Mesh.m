function PW_Linear_Mapping = Get_Mapping_For_Piecewise_Linear_Mesh(obj,Mesh)
%Get_Mapping_For_Piecewise_Linear_Mesh
%
%   This returns the FE coefficient vector (in the possibly higher order
%   Geo- Element Space) for the finite element function that represents the
%   piecewise *linear* mapping from the standard reference element, to
%   actual *linear* elements in the base (piecewise linear) Mesh.
%
%   PW_Linear_Mapping = obj.Get_Mapping_For_Piecewise_Linear_Mesh(Mesh);
%
%   Mesh = FELICITY mesh on which the GeoElementSpace is defined.
%
%   PW_Linear_Mapping = MxD matrix of nodal values, where M is the number
%                       of DoFs in the GeoElementSpace, and D is the
%                       geometric dimension of the mesh.
%
%   Note: PW_Linear_Mapping represents a finite element function in the
%         (possibly) higher order GeoElementSpace; it is *not* necessarily
%         a piecewise linear function over "Mesh".  It is a higher degree
%         function that happens to be linear over each element in Mesh.
%         Specifically, PW_Linear_Mapping represents \Phi, where
%
%         \Phi : T_{ref} ---> \hat{T},
%
%         i.e. \Phi maps from the standard reference domain to an actual
%         element in the piecewise *linear* mesh.

% Copyright (c) 04-10-2017,  Shawn W. Walker

obj.Verify_Mesh(Mesh);

PW_Linear_Mapping = obj.Get_DoF_Coord(Mesh);

end