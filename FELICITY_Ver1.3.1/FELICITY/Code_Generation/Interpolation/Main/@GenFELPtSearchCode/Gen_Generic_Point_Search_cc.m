function Gen_Generic_Point_Search_cc(obj,DEFINES,FPS)
%Gen_Generic_Point_Search_cc
%
%   This generates the file: "Generic_Point_Search.cc".

% Copyright (c) 06-16-2014,  Shawn W. Walker

ENDL = '\n';

% start with A part
File1 = 'Generic_Point_Search.cc';
WRITE_File = fullfile(obj.Output_Dir, File1);
FEL_CopyFile(fullfile(obj.Skeleton_Dir, 'Generic_Point_Search_A.cc'),WRITE_File);

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
GeomFunc = FPS.GeomFuncs.values;
Num_GeomFunc = length(GeomFunc);
for gi=1:Num_GeomFunc
    Domain_CPP = GeomFunc{gi}.Domain.Determine_CPP_Info;
    fprintf(fid, ['    ', Domain_CPP.Identifier_Name,...
                  '.Setup_Data(prhs[', DEFINES.MESH_SUBDOMAIN.Struct_List, '], ',...
                  'prhs[', DEFINES.MESH.DoFmap, '], ', 'PRHS_EMPTY', ');', ENDL]);
end
fprintf(fid, ['', ENDL]);
% "given point" classes
Search_Domains = FPS.Get_Distinct_Domains;
NUM_Domains = length(Search_Domains);
for di = 1:NUM_Domains
    Dom_Name = Search_Domains{di}.Name;
    CPP_PTS = FPS.Get_CPP_Point_Search_Vars(Dom_Name);
    Cell_GD = Search_Domains{di}.GeoDim;
    fprintf(fid, ['    ', CPP_PTS.Search_Data_Var, '.Setup("', Search_Domains{di}.Name, '", ',...
                                                num2str(Cell_GD), ', ',...
                                               'prhs[', CPP_PTS.MEX_Point_Search_Data, ']', ');', ENDL]);
end
fprintf(fid, ['', ENDL]);
%%%%%%%

% "found point" classes
for di = 1:NUM_Domains
    Dom_Name = Search_Domains{di}.Name;
    CPP_PTS  = FPS.Get_CPP_Point_Search_Vars(Dom_Name);
    Cell_TD  = Search_Domains{di}.Top_Dim;
    fprintf(fid, ['    ', CPP_PTS.Found_Points_Var, '.Setup(&', CPP_PTS.Search_Data_Var, ', ',...
                                                num2str(Cell_TD), ');', ENDL]);
end
fprintf(fid, ['', ENDL]);
%%%%%%%

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
fprintf(fid, ['GPS::~GPS ()', ENDL]);
fprintf(fid, ['{', ENDL]);
fprintf(fid, ['    ', '// clear it', ENDL]);
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
% domain point search classes
for di = 1:NUM_Domains
    Dom_Name = Search_Domains{di}.Name;
    CPP_PTS  = FPS.Get_CPP_Point_Search_Vars(Dom_Name);
    fprintf(fid, ['    ', 'delete(', CPP_PTS.Search_Obj_Var, ');', ENDL]);
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['}', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% write Setup_Data
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* setup point search objects and pass domain and geometry pointers around */', ENDL]);
fprintf(fid, ['void GPS::Setup_Data(const mxArray *prhs[]) // input from MATLAB', ENDL]);
fprintf(fid, ['{', ENDL]);

% EXAMPLE:
%%%%%%%
%     /*------------ BEGIN: Auto Generate ------------*/
%     // setup the desired domain point searches
%     Omega_Search_Obj = new CLASS_Search_Omega(&Omega_Search_Data, &Omega_Found_Points);
%     /*------------   END: Auto Generate ------------*/

%%%%%%%
% output text-lines
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// setup the desired domain point searches', ENDL]);
% domain point search classes
for di = 1:NUM_Domains
    Dom_Name = Search_Domains{di}.Name;
    CPP_PTS  = FPS.Get_CPP_Point_Search_Vars(Dom_Name);
    
    Pt_Search_ARG_str = [CPP_PTS.Search_Obj_Var, ' = new ', CPP_PTS.Search_Obj_CPP_Type,...
                         '(&', CPP_PTS.Search_Data_Var, ', &', CPP_PTS.Found_Points_Var,...
                         ');'];
    fprintf(fid, ['    ', Pt_Search_ARG_str, ENDL]);
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);

%%%%%%%
% output text-lines
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// pass pointers around', ENDL]);
for di = 1:NUM_Domains
    Dom_Name = Search_Domains{di}.Name;
    CPP_PTS  = FPS.Get_CPP_Point_Search_Vars(Dom_Name);
    
    GF = FPS.GeomFuncs(Dom_Name);
    Domain_CPP = GF.Domain.Determine_CPP_Info;
    fprintf(fid, ['    ', CPP_PTS.Search_Obj_Var, '->Domain', ' = &', Domain_CPP.Identifier_Name, ';', ENDL]);
    fprintf(fid, ['    ', CPP_PTS.Search_Obj_Var, '->GeomFunc', ' = &', GF.CPP.Identifier_Name, ';', ENDL]);
    fprintf(fid, ['    ', CPP_PTS.Search_Obj_Var, '->Consistency_Check();', ENDL]);
    fprintf(fid, ['', ENDL]);
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['}', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

status = obj.Write_SUBRoutine_Find_Points(fid,FPS);

status = obj.Write_SUBRoutine_Output_Points(fid,FPS);

% append the B part
Fixed_File = fullfile(obj.Skeleton_Dir, 'Generic_Point_Search_B.cc');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% DONE!
fclose(fid);

end