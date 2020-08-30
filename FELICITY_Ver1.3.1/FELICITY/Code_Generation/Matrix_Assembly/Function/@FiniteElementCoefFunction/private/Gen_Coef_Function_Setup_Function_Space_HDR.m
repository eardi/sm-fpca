function status = Gen_Coef_Function_Setup_Function_Space_HDR(obj,fid,BasisFunc)
%Gen_Coef_Function_Setup_Function_Space_HDR
%
%   This declares the Coef_Function_Class Setup_Function_Space (first part).

% Copyright (c) 03-14-2012,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
%TAB2 = [TAB, TAB];
%%%%%%%
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* put incoming function data from MATLAB into a nice struct  */', ENDL]);
fprintf(fid, ['void SpecificFUNC::Setup_Function_Space(const mxArray* Values,        // inputs', ENDL]);
Basis_Func_Data_Type_str = ['const ', BasisFunc.CPP_Data_Type, '*'];
Basis_Func_str = [Basis_Func_Data_Type_str, '   basis_func_input'];
fprintf(fid, ['                                        ', Basis_Func_str, ')          // inputs', ENDL]);
fprintf(fid, ['{', ENDL]);
fprintf(fid, [TAB, 'basis_func = basis_func_input;', ENDL]);
status = fprintf(fid, [obj.END_Auto_Gen, ENDL]);

end