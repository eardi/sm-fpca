function Nodal_BC_str = write_element_file_barycentric_string(Ref_Coord)
%write_element_file_barycentric_string
%
%   This creates a string representing the barycentric coordinates for the
%   given reference domain coordinates.

% Copyright (c) 10-07-2016,  Shawn W. Walker

Dim = length(Ref_Coord);

Nodal_BC = convert_to_barycentric(Ref_Coord);

Nodal_BC_str = []; % init string
for kk = 1:Dim
    Nodal_BC_str = [Nodal_BC_str, char(Nodal_BC(kk)), ', '];
end
Nodal_BC_str = [Nodal_BC_str, char(Nodal_BC(Dim+1))];
Nodal_BC_str = ['[', Nodal_BC_str, ']'];

end