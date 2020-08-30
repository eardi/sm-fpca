function CPP_TYPE_str = Get_CPP_Vector_Data_Type_Name(obj,Num_Comp)
%Get_CPP_Vector_Data_Type_Name
%
%   Output the string for the C++ data type.

% Copyright (c) 02-20-2012,  Shawn W. Walker

CPP_TYPE_str = ['VEC_', num2str(Num_Comp), 'x1'];

end