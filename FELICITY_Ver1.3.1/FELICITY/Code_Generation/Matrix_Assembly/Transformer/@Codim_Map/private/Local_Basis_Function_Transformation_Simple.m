function Local_Trans = Local_Basis_Function_Transformation_Simple(obj)
%Local_Basis_Function_Transformation_Simple
%
%   This sets the struct to have all the necessary info for computing local
%   transformations for the simplest case of a codim=0 domain.

% Copyright (c) 03-18-2012,  Shawn W. Walker

Local_Trans.Main_Subroutine = []; % init

% generate map basis code info for each mesh entity
Local_Trans.Map_Basis = obj.Set_Basis_Transformation_Struct(1);
Local_Trans.Num_Map_Basis = length(Local_Trans.Map_Basis);

TAB = '    ';
Local_Trans.Main_Subroutine = [TAB, Local_Trans.Map_Basis(1).CPP_Name, '();'];

end