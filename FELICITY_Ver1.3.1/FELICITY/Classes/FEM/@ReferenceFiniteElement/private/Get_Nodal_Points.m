function Nodal_Points = Get_Nodal_Points(obj)
%Get_Nodal_Points
%
%   This returns the coordinates of the nodal variables (i.e the
%   coordinates of the DoFs) on the reference element.

% Copyright (c) 04-19-2011,  Shawn W. Walker

% error checking
ERR = max(abs((sum(obj.Nodal_Data.BC_Coord,2) - 1)));
if ERR > 1e-15
    error('Barycentric coordinates should sum to 1.');
end
if size(obj.Simplex_Vtx,1)~=size(obj.Nodal_Data.BC_Coord,2)
    error('Barycentric coordinates and simplex vertices not compatible!');
end

Nodal_Points = zeros(obj.Num_Basis,size(obj.Simplex_Vtx,2));
for ind = 1:obj.Num_Basis
    Nodal_Points(ind,:) = obj.Nodal_Data.BC_Coord(ind,:) * obj.Simplex_Vtx; % row vector times multiple column vectors
end

end