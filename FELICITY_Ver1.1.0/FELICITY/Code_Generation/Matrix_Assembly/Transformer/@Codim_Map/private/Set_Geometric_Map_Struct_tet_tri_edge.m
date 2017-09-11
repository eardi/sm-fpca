function Compute_Map = Set_Geometric_Map_Struct_tet_tri_edge(obj,Sub_Entity_Index,DoI_Entity_Index)
%Set_Geometric_Map_Struct_tet_tri_edge
%
%   This sets a struct used in the ``Local_Map'' struct.
%   Note: Sub_Entity_Index is the local face relative to the enclosing tet.
%         DoI_Entity_Index is the local edge relative to the local face.

% Copyright (c) 06-26-2012,  Shawn W. Walker

if (Sub_Entity_Index > 0) % positive orientation
    Sub_str = ['p'];
elseif (Sub_Entity_Index < 0) % negative orientation
    Sub_str = ['n'];
else
    error('Sub_Entity_Index cannot be 0!');
end
if (DoI_Entity_Index > 0) % positive orientation
    DoI_str = ['p'];
elseif (DoI_Entity_Index < 0) % negative orientation
    DoI_str = ['n'];
else
    error('DoI_Entity_Index cannot be 0!');
end
suffix = [Sub_str, num2str(abs(Sub_Entity_Index)), '_', DoI_str, num2str(abs(DoI_Entity_Index))];

Compute_Map.Integration_Simplex_Type = obj.Domain.Integration_Domain.Type;
Compute_Map.Entity_Index = [Sub_Entity_Index, DoI_Entity_Index]; % relative to tet
Compute_Map.CPP_Name = ['Compute_Map', '_', suffix];
Compute_Map.Codim        = obj.Domain.Global.Top_Dim - obj.Domain.Integration_Domain.Top_Dim;
Compute_Map.Codim_Map    = obj.Generate_Local_Maps_For_Geometric_Basis_Functions(Compute_Map.Entity_Index);
Compute_Map.Num_Quad     = obj.Num_Quad;

end