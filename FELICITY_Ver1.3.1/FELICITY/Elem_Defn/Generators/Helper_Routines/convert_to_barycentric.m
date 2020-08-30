function BC_Coord = convert_to_barycentric(Ref_Coord)
%convert_to_barycentric
%
%   This converts (symbolic) reference domain coordinates to (symbolic)
%   barycentric coordinates.

% Copyright (c) 10-08-2016,  Shawn W. Walker

Dim = length(Ref_Coord);

% compute equivalent barycentric coordinates
BC_Coord = sym(zeros(Dim+1,1)); % init
BC_Coord(2:end) = Ref_Coord(:);
BC_Coord(1) = simplify(1 - sum(Ref_Coord));

end