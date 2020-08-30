function CPP_TYPE_str = Get_CPP_Matrix_Data_Type_Name(obj,Num_Row,Num_Col)
%Get_CPP_Matrix_Data_Type_Name
%
%   Output the string for the C++ data type.

% Copyright (c) 02-20-2012,  Shawn W. Walker

CPP_TYPE_str = ['MAT_', num2str(Num_Row), 'x', num2str(Num_Col)];

end