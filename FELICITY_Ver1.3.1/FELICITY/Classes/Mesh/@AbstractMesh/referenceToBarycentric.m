function BC = referenceToBarycentric(obj,local_coord)
%referenceToBarycentric
%
%   This converts local reference element coordinates to barycentric
%   coordinates.
%
%   BC = obj.referenceToBarycentric(local_coord);
%
%   local_coord = RxT matrix where each row represents the point coordinates in
%                 the local reference element.  R = number of points and
%                 T = topological dimension.
%
%   BC = (barycentric coordinates) Rx(T+1) matrix.

% Copyright (c) 02-07-2013,  Shawn W. Walker

num_coord = size(local_coord,1);
TD_chk    = size(local_coord,2);

% error check
TD = obj.Top_Dim;
if (TD ~= TD_chk)
    error('Topological dimension of mesh does not match dimension of local coordinates!');
end

BC = zeros(num_coord,TD+1);
BC(:,2:end) = local_coord;
if (TD==1)
    BC(:,1) = 1 - local_coord(:,1);
elseif (TD==2)
    BC(:,1) = 1 - local_coord(:,1) - local_coord(:,2);
elseif (TD==3)
    BC(:,1) = 1 - local_coord(:,1) - local_coord(:,2) - local_coord(:,3);
else
    error('Invalid!');
end

end