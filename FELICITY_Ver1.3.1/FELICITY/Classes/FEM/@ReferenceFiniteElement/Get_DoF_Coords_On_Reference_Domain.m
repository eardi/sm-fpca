function DoF_Coord = Get_DoF_Coords_On_Reference_Domain(obj)
%Get_DoF_Coords_On_Reference_Domain
%
%   This returns a matrix holding the reference domain coordinates of all
%   the DoFs.
%
%   DoF_Coord = obj.Get_DoF_Coords_On_Reference_Domain();
%
%   DoF_Coord = MxT matrix of coordinates for all the DoFs.  M is the
%               number of local DoFs, and T is the topological dimension of
%               the reference domain.

% Copyright (c) 08-15-2019,  Shawn W. Walker

DoF_Coord = obj.Nodal_Data.BC_Coord(:,2:3);

end