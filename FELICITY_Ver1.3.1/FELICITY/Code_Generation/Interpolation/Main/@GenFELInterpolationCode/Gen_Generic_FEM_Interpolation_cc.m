function Gen_Generic_FEM_Interpolation_cc(obj,DEFINES,GeomFunc,FS,FI)
%Gen_Generic_FEM_Assembly_cc
%
%   This generates the file: "Generic_FEM_Interpolation.cc".

% Copyright (c) 01-20-2018,  Shawn W. Walker

ENDL = '\n';

% start with A1 part
File1 = 'Generic_FEM_Interpolation.cc';
WRITE_File = fullfile(obj.Output_Dir, File1);
FEL_CopyFile(fullfile(obj.Skeleton_Dir, 'Generic_FEM_Interpolation_A.cc'),WRITE_File);

% open file for writing
fid = fopen(WRITE_File, 'a');

% EXAMPLE:
%%%%%%%
%     /*------------ BEGIN: Auto Generate ------------*/
%     // setup inputs
%     Mesh_XXX.Setup_Mesh_Geometry(prhs[PRHS_Mesh_Node_Values], prhs[PRHS_Mesh_DoFmap], prhs[PRHS_Mesh_Orient]);
%     Setup_Data(prhs);
%     /*------------   END: Auto Generate ------------*/

%%%%%%%
% output text-lines
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// setup inputs', ENDL]);
fprintf(fid, ['    ', 'const mxArray *PRHS_EMPTY = NULL;', ENDL]);
Num_GeomFunc = length(GeomFunc);
for gi=1:Num_GeomFunc
    Domain_CPP = GeomFunc{gi}.Domain.Determine_CPP_Info;
    fprintf(fid, ['    ', Domain_CPP.Identifier_Name,...
                  '.Setup_Data(prhs[', DEFINES.MESH_SUBDOMAIN.Struct_List, '], ',...
                  'prhs[', DEFINES.MESH.DoFmap, '], ', 'PRHS_EMPTY', ');', ENDL]);
end
fprintf(fid, ['', ENDL]);
% interpolation point classes
Interp_Domains = FI.Get_Distinct_Domains;
for di = 1:length(Interp_Domains)
    CPP_DOM = FI.Get_CPPdefine_Domain_Name(Interp_Domains{di}.Name);
    Cell_TD = Interp_Domains{di}.Top_Dim;
    fprintf(fid, ['    ', CPP_DOM.Interp_Data, '.Setup("', Interp_Domains{di}.Name, '", ',...
                                                num2str(Cell_TD), ', ',...
                                               'prhs[', CPP_DOM.MEX_Interp_Data, ']', ');', ENDL]);
end
fprintf(fid, ['', ENDL]);
% mesh geometry data
for gi = 1:Num_GeomFunc
    Mesh_Name_str = GeomFunc{gi}.CPP.Identifier_Name;
    fprintf(fid, ['    ', Mesh_Name_str, '.Setup_Mesh_Geometry(prhs[', DEFINES.MESH.Node_Value, '], ',...
                                                              'prhs[', DEFINES.MESH.DoFmap, '], ',...
                                                              'prhs[', DEFINES.MESH.Orient, ']', ');', ENDL]);
    Domain_CPP = GeomFunc{gi}.Domain.Determine_CPP_Info;
    fprintf(fid, ['    ', Mesh_Name_str, '.Domain = &', Domain_CPP.Identifier_Name, ';', ENDL]);
end
fprintf(fid, ['', ENDL]);
fprintf(fid, ['    ', 'Setup_Data(prhs);', ENDL]);
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', '}', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['', ENDL]);

% write destructor
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* destructor */', ENDL]);
fprintf(fid, ['GFI::~GFI ()', ENDL]);
fprintf(fid, ['{', ENDL]);
% fprintf(fid, ['    ', '// clear it', ENDL]);
fprintf(fid, ['}', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% write Setup_Data
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* setup data into a nice struct for internal use */', ENDL]);
fprintf(fid, ['void GFI::Setup_Data(const mxArray *prhs[]) // input from MATLAB', ENDL]);
fprintf(fid, ['{', ENDL]);

% EXAMPLE:
%%%%%%%
%     /*------------ BEGIN: Auto Generate ------------*/
%     // setup access to FEM basis functions
%     Scalar_P2_phi.Setup_Function_Space(prhs[PRHS_Func_Values_0], prhs[PRHS_Func_DoFmap_0]);
%     /*------------   END: Auto Generate ------------*/

%%%%%%%
% output text-lines
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// setup access to FE basis functions', ENDL]);
for int_index = 1:length(FS.Integration)
    BF_Set = FS.Integration(int_index).BasisFunc;
    BF_Names = BF_Set.keys;
    for bi = 1:length(BF_Names)
        BF_Specific = BF_Set(BF_Names{bi});
        SN = BF_Specific.Space_Name;
        % if the space consists of a single *global constant*,
        if strcmp(FS.Space(SN).Elem.Element_Name,'constant_one')
            % then we can use a simple default DoFmap
            MEX_DoFmap = [BF_Specific.CPP_Var, '.CONST_DoFmap'];
        else
            % we need the DoFmap from MATLAB
            CPP_SPACE = FS.Get_CPPdefine_Space_Name(SN);
            MEX_DoFmap = ['prhs[', CPP_SPACE.MEX_DoFmap, ']'];
        end
        fprintf(fid, ['    ', BF_Specific.CPP_Var,...
                      '.Setup_Function_Space(', MEX_DoFmap, ');', ENDL]);
        fprintf(fid, ['    ', BF_Specific.CPP_Var,...
                      '.Mesh = &', BF_Specific.GeomFunc.CPP.Identifier_Name, ';', ENDL]);
    end
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% EXAMPLE:
%%%%%%%
%     /*------------ BEGIN: Auto Generate ------------*/
%     // setup access to external FEM functions
%     Ext_FEM_Func_0.Setup_Function_Space(prhs[PRHS_Func_Values_0], prhs[PRHS_Func_DoFmap_0]);
%     /*------------   END: Auto Generate ------------*/

%%%%%%%
% output text-lines
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// setup access to external FE functions', ENDL]);
% loop through all the specific coef function names
for int_index = 1:length(FS.Integration)
    BF_Set = FS.Integration(int_index).BasisFunc;
    CF_Set = FS.Integration(int_index).CoefFunc;
    CF_Names = CF_Set.keys;
    for index = 1:length(CF_Names)
        CPP_FUNC = FS.Get_CPPdefine_Func_Name(CF_Names{index});
        CF_Specific = CF_Set(CF_Names{index});
        % output text-lines
        fprintf(fid, ['    ', CF_Specific.CPP_Var,...
                      '.Setup_Function_Space(prhs[', CPP_FUNC.MEX_Node_Value, '], &',...
                       BF_Set(CF_Specific.Space_Name).CPP_Var,  ');', ENDL]);
        % if the coefficient function is a global *constant*
        SN = CF_Specific.Space_Name;
        if strcmp(FS.Space(SN).Elem.Element_Name,'constant_one')
            % then read in the global constant ONCE
            C_Val_str = CF_Specific.FuncTrans.Output_CPP_Var_Name('Val');
            fprintf(fid, ['    ', '// read in the external constant data (once!)', ENDL]);
            fprintf(fid, ['    ', 'for (int nc_i = 0; (nc_i < ', CF_Specific.CPP_Var, '.Num_Comp); nc_i++)', ENDL]);
            fprintf(fid, ['        ', CF_Specific.CPP_Var, '.', C_Val_str, '[nc_i].a',...
                          ' = ', CF_Specific.CPP_Var, '.Node_Value[nc_i][0];', ENDL]);
        end
    end
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% EXAMPLE:
%%%%%%%
%     /*------------ BEGIN: Auto Generate ------------*/
%     // setup the desired interpolations to evaluate
%     Fobj_I_v = new FEM_Interpolation_Specific(prhs[Omega_Interp_Data]);
%     /*------------   END: Auto Generate ------------*/

%%%%%%%
% output text-lines
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// setup the desired interpolations to evaluate', ENDL]);
Interp_Names = FI.keys;
NUM_INTERP = length(Interp_Names);
for index = 1:NUM_INTERP
    INT_CPP = FI.Get_Interpolation_CPP_Info(Interp_Names{index});
    FEM_Interp_ARG_str = [INT_CPP.Var_Name, ' = new ', INT_CPP.Data_Type_Name,...
                         '(', INT_CPP.Interp_Data, '.Num_Pts);'];
    fprintf(fid, ['    ', FEM_Interp_ARG_str, ENDL]);
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);

%%%%%%%
% output text-lines
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// pass pointers around', ENDL]);
%Basis_Func = FS.Get_Unique_Array_Of_BasisFuncs;
Coef_Func  = FS.Get_Unique_Array_Of_CoefFuncs;
for index = 1:NUM_INTERP
    INT_CPP = FI.Get_Interpolation_CPP_Info(Interp_Names{index});
    
    for gi = 1:Num_GeomFunc
        Geom_CPP = GeomFunc{gi}.CPP;
        fprintf(fid, ['    ', INT_CPP.Var_Name, '->', Geom_CPP.Identifier_Name, ' = &', Geom_CPP.Identifier_Name, ';', ENDL]);
    end
%     for bi = 1:length(Basis_Func)
%         BF_Var_Name = Basis_Func{bi}.CPP_Var;
%         fprintf(fid, ['    ', INT_CPP.Var_Name, '->', BF_Var_Name, ' = &', BF_Var_Name, ';', ENDL]);
%     end
    for ci = 1:length(Coef_Func)
        CF_Var_Name = Coef_Func{ci}.CPP_Var;
        fprintf(fid, ['    ', INT_CPP.Var_Name, '->', CF_Var_Name, ' = &', CF_Var_Name, ';', ENDL]);
    end
    fprintf(fid, ['', ENDL]);
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['}', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

status = obj.Write_SUBRoutine_Evaluate_Interpolations(fid,FS,FI);

status = obj.Write_SUBRoutine_Output_Interpolations(fid,FI);

% append the D part
Fixed_File = fullfile(obj.Skeleton_Dir, 'Generic_FEM_Interpolation_B.cc');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% DONE!
fclose(fid);

end