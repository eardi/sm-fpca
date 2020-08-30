function Local_Map = Local_Geometric_Map_Simple(obj)
%Local_Geometric_Map_Simple
%
%   This sets the struct to have all the necessary info for computing local
%   geometric transformations for the simplest case of a codim=0 domain.

% Copyright (c) 03-18-2012,  Shawn W. Walker

Local_Map.Main_Subroutine = []; % init

% generate compute map code info for each mesh entity
Local_Map.Compute_Map = obj.Set_Geometric_Map_Struct(1); % only one entity
Local_Map.Num_Compute_Map = length(Local_Map.Compute_Map);

elem_index_str = 'Global_Cell_Index';
TAB = '    ';
Local_Map.Main_Subroutine = [TAB, Local_Map.Compute_Map(1).CPP_Name, '(', elem_index_str, ');'];

end