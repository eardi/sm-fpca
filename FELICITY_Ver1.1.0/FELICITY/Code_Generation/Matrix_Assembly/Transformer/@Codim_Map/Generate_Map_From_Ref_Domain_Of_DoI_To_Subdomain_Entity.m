function FEL_Sym_Map = Generate_Map_From_Ref_Domain_Of_DoI_To_Subdomain_Entity(obj,entity_ind)
%Generate_Map_From_Ref_Domain_Of_DoI_To_Subdomain_Entity
%
%   This generates a symbolic map (expression).  The map takes a point in the
%   reference element for the Domain of Integration (DoI) and "maps" it to a
%   point in the given topological entity in the Subdomain reference element.
%
%   Note: the symbolic map 'FEL_Sym_Map' is a FELSymFunc object.
%
%   Note: this map is useful for mapping *finite element* basis functions.
%
%   See 'Generate_Local_Maps_For_Geometric_Basis_Functions' for more info.

% Copyright (c) 03-06-2013,  Shawn W. Walker

Local_Map = obj.Generate_Local_Maps_For_Geometric_Basis_Functions(entity_ind);

FEL_Sym_Map = Local_Map.DoI;

end