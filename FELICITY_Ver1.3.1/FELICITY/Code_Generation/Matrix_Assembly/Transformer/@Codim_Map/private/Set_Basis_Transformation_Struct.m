function Map_Basis = Set_Basis_Transformation_Struct(obj,Entity_Index)
%Set_Basis_Transformation_Struct
%
%   This sets a struct used in the ``Local_Transformation'' struct.

% Copyright (c) 03-19-2012,  Shawn W. Walker

if (Entity_Index > 0) % positive orientation
    suffix = ['p', num2str(Entity_Index)];
elseif (Entity_Index < 0) % negative orientation
    suffix = ['n', num2str(abs(Entity_Index))];
else
    error('Entity_Index cannot be 0!');
end

Map_Basis.Integration_Simplex_Type = obj.Domain.Integration_Domain.Type;
Map_Basis.Entity_Index = Entity_Index;
Map_Basis.CPP_Name  = ['Map_Basis', '_', suffix];
Map_Basis.Codim     = obj.Get_Codim_For_Basis_Function();
Map_Basis.Codim_Map = obj.Generate_Map_From_Ref_Domain_Of_DoI_To_Subdomain_Entity(Entity_Index);
Map_Basis.Num_Quad  = obj.Num_Quad;
Map_Basis.Val.VarName     = ['Value', '_', suffix];
Map_Basis.Val.Declare_CPP = ['SCALAR ', Map_Basis.Val.VarName, '[NB][NQ];'];
Map_Basis.Val.CPP_Routine = ['Basis_', Map_Basis.Val.VarName];

end