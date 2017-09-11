function CPP = Get_Interpolation_CPP_Info(obj,Interp_Name)
%Get_Interpolation_CPP_Info
%
%   This returns the CPP data names to use for the FEM interpolation.

% Copyright (c) 01-29-2013,  Shawn W. Walker

INT = obj.Interp(Interp_Name);

if ~isempty(INT)
    CPP.Data_Type_Name    = Interp_Name;
    CPP.Var_Name          = ['Iobj_', Interp_Name];
    
    CPP_DOM = obj.Get_CPPdefine_Domain_Name(INT.Domain.Name);
    CPP.Interp_Data       = CPP_DOM.Interp_Data;
    CPP.MEX_Interp_Data   = CPP_DOM.MEX_Interp_Data;
else
    CPP = [];
end

end