function status = Gen_Mesh_Geometry_Class_Constructor(obj,fid,Geo_CODE)
%Gen_Mesh_Geometry_Class_Constructor
%
%   This writes the Mesh_Geometry_Class constructor.

% Copyright (c) 06-06-2012,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
TAB2 = [TAB, TAB];
%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* constructor */', ENDL]);
fprintf(fid, ['MGC::MGC () : Abstract_MESH_GEOMETRY_Class ()', ENDL]);
fprintf(fid, ['{', ENDL]);
fprintf(fid, [TAB, 'Type      = (char*) MAP_type;', ENDL]);
fprintf(fid, [TAB, 'Global_TopDim = GLOBAL_TD;', ENDL]);
fprintf(fid, [TAB, 'Sub_TopDim    = SUB_TD;', ENDL]);
fprintf(fid, [TAB, 'DoI_TopDim    = DOI_TD;', ENDL]);
fprintf(fid, [TAB, 'GeoDim    = GD;', ENDL]);
fprintf(fid, [TAB, 'Num_QP    = NQ;', ENDL]);
fprintf(fid, [TAB, 'Num_Basis = NB;', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB, '// init mesh information to NULL', ENDL]);
fprintf(fid, [TAB, 'Num_Nodes = 0;', ENDL]);
fprintf(fid, [TAB, 'Num_Elem  = 0;', ENDL]);
fprintf(fid, [TAB, 'for (int gd_i = 0; (gd_i < GeoDim); gd_i++)', ENDL]);
fprintf(fid, [TAB2, 'Node_Value[gd_i] = NULL;', ENDL]);
fprintf(fid, [TAB, 'for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)', ENDL]);
fprintf(fid, [TAB2, '{', ENDL]);
fprintf(fid, [TAB2, 'Elem_DoF[basis_i] = NULL;', ENDL]);
fprintf(fid, [TAB2, 'kc[basis_i]       = -1; // a NULL value', ENDL]);
fprintf(fid, [TAB2, '}', ENDL]);
fprintf(fid, [TAB, 'for (int o_i = 0; (o_i < (Sub_TopDim+1)); o_i++)', ENDL]);
fprintf(fid, [TAB2, '{', ENDL]);
fprintf(fid, [TAB2, 'Orientation[o_i] = +1.0;', ENDL]);
fprintf(fid, [TAB2, 'Elem_Orient[o_i] = NULL;', ENDL]);
fprintf(fid, [TAB2, '}', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB, '// init everything to zero', ENDL]);
% write the geometry variable initializations
for ind=1:length(Geo_CODE)
    if Geo_CODE(ind).Constant
        Num_QP_str = '1';
    else
        Num_QP_str = 'Num_QP';
    end
    % write for loop
    fprintf(fid, [TAB, 'for (int qp_i = 0; (qp_i < ', Num_QP_str, '); qp_i++)', ENDL]);
    % write the set_to_zero function call
    VarName = Geo_CODE(ind).Var_Name(1).line;
    fprintf(fid, [TAB2, VarName, '[qp_i]', '.Set_To_Zero();', ENDL]);
end
fprintf(fid, ['}', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
status = fprintf(fid, ['', ENDL]);

end