function CPP_TYPE_str = Get_CPP_Tensor_Data_Type_Name(obj,Num_Ind1,Num_Ind2,Num_Ind3)
%Get_CPP_Tensor_Data_Type_Name
%
%   Output the string for the C++ data type.

% Copyright (c) 02-20-2012,  Shawn W. Walker

CPP_TYPE_str = ['MAT_', num2str(Num_Ind1), 'x', num2str(Num_Ind2), 'x', num2str(Num_Ind3)];

end