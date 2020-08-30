function Local_Coord = barycentricToReference(obj,bc)
%barycentricToReference
%
%   This converts barycentric coordinates to local reference element
%   coordinates.
%
%   Local_Coord = obj.barycentricToReference(bc);
%
%   bc = (barycentric coord.) Rx(T+1) matrix where R = number of points and
%                             T = topological dimension.
%
%   Local_Coord = RxT matrix where each row represents the point coordinates in
%                 the local reference element.

% Copyright (c) 02-07-2013,  Shawn W. Walker

TD_chk = size(bc,2)-1;

% error check
TD = obj.Top_Dim;
if (TD ~= TD_chk)
    error('Topological dimension of mesh does not match dimension of barycentric coordinates!');
end

Local_Coord = bc(:,2:end);

end