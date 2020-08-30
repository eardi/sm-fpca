function Local_Coord = cartesianToReference(obj,SI,XC)
%cartesianToReference
%
%   This converts cartesian coordinates to local reference element
%   coordinates relative to a given cell (simplex).
%
%   local_coord = obj.cartesianToReference(SI,XC);
%
%   SI = Rx1 matrix of cell indices that correspond to "local_coord".
%   XC = (cartesian coordinates) RxD matrix, where D is the geometric
%         dimension of the mesh.
%
%   Local_Coord = RxT matrix where each row represents the point coordinates in
%                 the local reference element.  R = number of points and
%                 T = topological dimension.

% Copyright (c) 10-07-2016,  Shawn W. Walker

% first convert cartesian to barycentric
BC = obj.cartesianToBarycentric(SI, XC);

% then convert to reference element coordinates
Local_Coord = obj.barycentricToReference(BC);

end