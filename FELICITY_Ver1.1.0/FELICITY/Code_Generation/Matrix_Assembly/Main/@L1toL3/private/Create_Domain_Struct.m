function DS = Create_Domain_Struct(obj,DOMAIN,Set_of_Integration_TF)
%Create_Domain_Struct
%
%   This creates an intermediate struct.

% Copyright (c) 08-01-2011,  Shawn W. Walker

[Num_Quad, Top_Dim] = Get_Num_Quad_Points_From_Quad_Order(obj.MATS.Quad_Order,DOMAIN.Type);

% create Domain struct (for integration set)
DS.Name = DOMAIN.Name;
DS.Type = DOMAIN.Type;
DS.Dim  = Top_Dim;
DS.Subset_Of = [];
if ~or(isempty(DOMAIN.Subset_Of),strcmp(DOMAIN.Subset_Of,''))
    DS.Subset_Of = DOMAIN.Subset_Of;
end
DS.Set_of_Integration_TF = Set_of_Integration_TF;
DS.Num_Quad = Num_Quad;

end