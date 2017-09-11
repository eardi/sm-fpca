function CPP_Var_str = Get_Geo_CPP_Var_Name(Var_str)
%Get_Geo_CPP_Var_Name
%
%   Output the string for the actual C++ variable name.

% Copyright (c) 02-20-2012,  Shawn W. Walker

CPP_Var_str = ['Map_', Var_str]; % just add a prefix

end