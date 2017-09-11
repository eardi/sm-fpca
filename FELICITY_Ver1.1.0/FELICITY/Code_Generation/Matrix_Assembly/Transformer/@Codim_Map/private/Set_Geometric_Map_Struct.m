function Compute_Map = Set_Geometric_Map_Struct(obj,Entity_Index)
%Set_Geometric_Map_Struct
%
%   This sets a struct used in the ``Local_Map'' struct.

% Copyright (c) 06-05-2012,  Shawn W. Walker

if (Entity_Index > 0) % positive orientation
    suffix = ['p', num2str(Entity_Index)];
elseif (Entity_Index < 0) % negative orientation
    suffix = ['n', num2str(abs(Entity_Index))];
else
    error('Entity_Index cannot be 0!');
end

Compute_Map.Integration_Simplex_Type = obj.Domain.Integration_Domain.Type;
Compute_Map.Entity_Index = Entity_Index;
Compute_Map.CPP_Name = ['Compute_Map', '_', suffix];
Compute_Map.Codim        = obj.Domain.Global.Top_Dim - obj.Domain.Integration_Domain.Top_Dim;
Compute_Map.Codim_Map    = obj.Generate_Local_Maps_For_Geometric_Basis_Functions(Compute_Map.Entity_Index);
Compute_Map.Num_Quad     = obj.Num_Quad;

end