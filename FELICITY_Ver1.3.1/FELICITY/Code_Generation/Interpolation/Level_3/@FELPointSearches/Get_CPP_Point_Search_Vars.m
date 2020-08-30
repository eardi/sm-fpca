function PTS = Get_CPP_Point_Search_Vars(obj,Domain_Name)
%Get_CPP_Point_Search_Vars
%
%   This returns a struct containing CPP variable name info for variables containing
%   given points (on a search Domain) as well as variables containing the found (local)
%   points.

% Copyright (c) 06-28-2014,  Shawn W. Walker

[TF, LOC] = ismember(Domain_Name,obj.keys);
if ~TF
    error('Given Domain_Name does not exist!');
end

PTS.Search_Data_CPP_Type  = 'Subdomain_Search_Data_Class';
PTS.Search_Data_Var       = [Domain_Name, '_Search_Data'];
PTS.MEX_Point_Search_Data = ['PRHS_', PTS.Search_Data_Var];

PTS.Found_Points_CPP_Type = 'Unstructured_Local_Points_Class';
PTS.Found_Points_Var      = [Domain_Name, '_Found_Points'];

PTS.Search_Obj_CPP_Type   = ['CLASS_Search_', Domain_Name];
PTS.Search_Obj_Var        = [Domain_Name, '_Search_Obj'];

end