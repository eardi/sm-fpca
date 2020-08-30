function status = Gen_Basis_Function_Class_Constructor(obj,fid,BF_CODE)
%Gen_Basis_Function_Class_Constructor
%
%   This writes the Basis_Function_Class constructor.

% Copyright (c) 02-06-2013,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* constructor */', ENDL]);
fprintf(fid, ['SpecificFUNC::SpecificFUNC () :', ENDL]);
fprintf(fid, ['ABSTRACT_FEM_Function_Class () // call the base class constructor', ENDL]);
fprintf(fid, ['{', ENDL]);
fprintf(fid, [TAB, 'Name       = (char*) SpecificFUNC_str;', ENDL]);
fprintf(fid, [TAB, 'Type       = (char*) SPACE_type;', ENDL]);
fprintf(fid, [TAB, 'Space_Name = (char*) SPACE_name;', ENDL]);
fprintf(fid, [TAB, 'Sub_TopDim = SUB_TD;', ENDL]);
fprintf(fid, [TAB, 'DoI_TopDim = DOI_TD;', ENDL]);
fprintf(fid, [TAB, 'GeoDim     = GD;', ENDL]);
fprintf(fid, [TAB, 'Num_Basis  = NB;', ENDL]);
fprintf(fid, [TAB, 'Num_Comp   = NC;', ENDL]);
fprintf(fid, [TAB, 'Num_QP     = NQ;', ENDL]);
fprintf(fid, [TAB, 'Mesh       = NULL;', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB, '// init DoF information to NULL', ENDL]);
fprintf(fid, [TAB, 'for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)', ENDL]);
fprintf(fid, [TAB2, 'Elem_DoF[basis_i] = NULL;', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB, '// init everything to zero', ENDL]);
% write the basis function variable initializations
for ind=1:length(BF_CODE)
    if BF_CODE(ind).Constant
        Num_QP_str = '1';
    else
        Num_QP_str = 'Num_QP';
    end
    % write for loop
    fprintf(fid, [TAB, 'for (int qp_i = 0; (qp_i < ', Num_QP_str, '); qp_i++)', ENDL]);
    fprintf(fid, [TAB, 'for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)', ENDL]);
    % write the set_to_zero function call
    VarName = BF_CODE(ind).Var_Name(1).line;
    fprintf(fid, [TAB2, VarName, '[basis_i][qp_i]', '.Set_To_Zero();', ENDL]);
end

obj.Write_Init_Basis_Function_Values_snippet(fid);

fprintf(fid, ['}', ENDL]);

if isa(obj.FuncTrans,'Constant_Trans')
    TYPE_str = obj.FuncTrans.Get_CPP_Scalar_Data_Type_Name;
    C_Val_str = obj.FuncTrans.Output_CPP_Var_Name('Val');
    status = fprintf(fid, [TAB, '// initialize the constant once and for all', ENDL]);
    status = fprintf(fid, [TAB, 'const  ', TYPE_str, '  SpecificFUNC::', C_Val_str, ' = ', TYPE_str, '(1.0);', ENDL]);
end

fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
status = fprintf(fid, ['', ENDL]);

end