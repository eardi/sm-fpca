function status = Gen_Coef_Function_Class_Constructor(obj,fid,CF_CODE)
%Gen_Coef_Function_Class_Constructor
%
%   This writes the Coef_Function_Class constructor.

% Copyright (c) 03-14-2012,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* constructor */', ENDL]);
fprintf(fid, ['SpecificFUNC::SpecificFUNC ()', ENDL]);
fprintf(fid, ['{', ENDL]);
fprintf(fid, [TAB, 'Name        = (char*) SpecificNAME;', ENDL]);
fprintf(fid, [TAB, 'CPP_Routine = (char*) SpecificFUNC_str;', ENDL]);
fprintf(fid, [TAB, 'Type        = (char*) SPACE_type;', ENDL]);
% fprintf(fid, [TAB, 'TopDim    = TD;', ENDL]);
% fprintf(fid, [TAB, 'GeoDim    = GD;', ENDL]);
fprintf(fid, [TAB, 'Num_Nodes   = 0;', ENDL]);
fprintf(fid, [TAB, 'Num_Comp    = NC;', ENDL]);
fprintf(fid, [TAB, 'Num_QP      = NQ;', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB, '// init pointers', ENDL]);
fprintf(fid, [TAB, 'basis_func = NULL;', ENDL]);
fprintf(fid, [TAB, 'for (int nc_i = 0; (nc_i < Num_Comp); nc_i++)', ENDL]);
fprintf(fid, [TAB2, 'Node_Value[nc_i] = NULL;', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB, '// init everything to zero', ENDL]);
% write the coef function variable initializations
for ind=1:length(CF_CODE)
    if CF_CODE(ind).Constant
        Num_QP_str = '1';
    else
        Num_QP_str = 'Num_QP';
    end
    VarName = CF_CODE(ind).Var_Name(1).line;
    
    % write the set_to_zero function call
    if isa(obj.FuncTrans,'Constant_Trans')
        % write for loop
        fprintf(fid, [TAB, 'for (int nc_i = 0; (nc_i < Num_Comp); nc_i++)', ENDL]);
        % there are NO quadrature points
        fprintf(fid, [TAB2, VarName, '[nc_i]', '.Set_To_Zero();', ENDL]);
    else
        % write for loop
        fprintf(fid, [TAB, 'for (int qp_i = 0; (qp_i < ', Num_QP_str, '); qp_i++)', ENDL]);
        fprintf(fid, [TAB, 'for (int nc_i = 0; (nc_i < Num_Comp); nc_i++)', ENDL]);
        fprintf(fid, [TAB2, VarName, '[nc_i][qp_i]', '.Set_To_Zero();', ENDL]);
    end
end

fprintf(fid, ['}', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
status = fprintf(fid, ['', ENDL]);

end