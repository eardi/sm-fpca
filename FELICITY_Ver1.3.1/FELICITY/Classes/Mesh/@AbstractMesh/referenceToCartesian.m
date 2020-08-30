function XC = referenceToCartesian(obj,SI,local_coord)
%referenceToCartesian
%
%   This converts local reference element coordinates to Cartesian
%   coordinates.  The reference coordinates are given with respect to a
%   given cell (simplex).
%
%   XC = obj.referenceToCartesian(SI,local_coord);
%
%   SI = Rx1 matrix of cell indices that correspond to "local_coord".
%   local_coord = RxT matrix where each row represents the point coordinates in
%                 the local reference element.  R = number of points and
%                 T = topological dimension.
%
%   XC = (cartesian coordinates) RxD matrix, where D is the geometric
%         dimension of the mesh.

% Copyright (c) 10-07-2016,  Shawn W. Walker

% first convert to barycentric coordinates
BC = obj.referenceToBarycentric(local_coord);

% then convert to cartesian
XC = obj.barycentricToCartesian(SI, BC);

end