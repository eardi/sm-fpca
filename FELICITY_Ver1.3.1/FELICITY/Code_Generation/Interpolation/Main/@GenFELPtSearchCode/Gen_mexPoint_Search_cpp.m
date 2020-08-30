function DEFINES = Gen_mexPoint_Search_cpp(obj,FPS)
%Gen_mexPoint_Search_cpp
%
%   This generates the file: "mexPoint_Search.cpp".

% Copyright (c) 06-15-2014,  Shawn W. Walker

% start with A part
File1 = 'mexPoint_Search.cpp';
WRITE_File = fullfile(obj.Output_Dir, File1);
FEL_CopyFile(fullfile(obj.Skeleton_Dir, 'mexPoint_Search_A.cpp'),WRITE_File);

% open file for writing
fid = fopen(WRITE_File, 'a');

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // define input indices
% #define PRHS_Omega_Mesh_Vertices                                               0
% #define PRHS_Omega_Mesh_DoFmap                                                 1
% #define PRHS_Subdomain_Embedding (or EMPTY!)                                   2
% #define PRHS_EMPTY_2                                                           3
% #define PRHS_Omega_Given_Points                                                4
% etc...
% /*------------   END: Auto Generate ------------*/

ENDL = '\n';
SPACE_LEN = 70;
mex_strings = obj.Get_MEX_Gateway_Arguments(FPS);

%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['// define input indices', ENDL]);
[DEFINES, ALIGNED] = obj.Setup_Main_MEX_Input_DEFINES(SPACE_LEN,mex_strings);

fprintf(fid, ['#define ', ALIGNED.MESH.Node_Value, ENDL]);
fprintf(fid, ['#define ', ALIGNED.MESH.DoFmap,     ENDL]);
fprintf(fid, ['#define ', ALIGNED.MESH.Orient,     ENDL]);
LAST_IND = 2;

% if we are assembling over a domain of co-dimension > 0, then output links to
% extra mesh pointer info
if ~isempty(ALIGNED.MESH_SUBDOMAIN)
    fprintf(fid, ['#define ', ALIGNED.MESH_SUBDOMAIN.Struct_List, ENDL]);
    LAST_IND = LAST_IND + 1;
end

% output links to points to search (on certain domains)
Search_Domains = FPS.Get_Distinct_Domains;
NUM_Domains = length(Search_Domains);
for di = 1:NUM_Domains
    Dom_Name = Search_Domains{di}.Name;
    CPP_DOM  = FPS.Get_CPP_Point_Search_Vars(Dom_Name);
    LAST_IND = LAST_IND + 1;
    ALIGNED.SEARCH(di).Domain = [obj.Pad_With_Whitespace(CPP_DOM.MEX_Point_Search_Data, SPACE_LEN), ' ', num2str(LAST_IND)];
    fprintf(fid, ['#define ', ALIGNED.SEARCH(di).Domain,     ENDL]);
end
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
%%%%%%%

% append the B part
Fixed_File = fullfile(obj.Skeleton_Dir, 'mexPoint_Search_B.cpp');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% EXAMPLE:
%%%%%%%
%     /*------------ BEGIN: Auto Generate ------------*/
%     /* BEGIN: Error Checking */
%     if (nrhs!=5)
%         {
%         mexPrintf("ERROR: 5 inputs required!\n");
%         mexPrintf("\n");
%         mexPrintf("      INPUTS                                                          ORDER \n");
%         mexPrintf("      -------------------                                             ----- \n");
%         mexPrintf("      Omega_Mesh_Vertices                                               0 \n");
%         mexPrintf("      Omega_Mesh_DoFmap                                                 1 \n");
%         mexPrintf("      EMPTY_1                                                           2 \n");
%         mexPrintf("      EMPTY_2                                                           3 \n");
%         mexPrintf("      Omega_Given_Points                                                4 \n");
%         mexPrintf("\n");
%         mexPrintf("      ---------------------------------------- \n");
%         mexPrintf("      Output is an array of structs:\n");
%         mexPrintf("      POINTS(:).DATA = {Cell_Indices, Local_Ref_Coord}\n");
%         mexPrintf("      POINTS(:).Name = 'name of Domain that was searched'\n");
%         mexPrintf("\n");
%         mexPrintf("      OUTPUTS For Domains (in consecutive order) \n");
%         mexPrintf("      ---------------------------------------- \n");
%         mexPrintf("      Omega \n");
%         mexPrintf("\n");
%         mexErrMsgTxt("Check the number of input arguments!");
%         }
%     if (nlhs!=1) mexErrMsgTxt("1 output is required!");
%     /* END: Error Checking */
%     /*------------   END: Auto Generate ------------*/

NUM_ARG = LAST_IND + 1;

%%%%%%%
% output text-lines
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '/* BEGIN: Error Checking */', ENDL]);
fprintf(fid, ['    ', 'if (nrhs!=', num2str(NUM_ARG), ')', ENDL]);
fprintf(fid, ['        ', '{', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("ERROR: ', num2str(NUM_ARG), ' inputs required!\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      INPUTS                                                          ORDER \\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      -------------------                                             ----- \\n");', ENDL]);
%%%%%
fprintf(fid, ['        ', 'mexPrintf("      ', ALIGNED.MESH.Node_Value(6:end), ' \\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      ', ALIGNED.MESH.DoFmap(6:end),     ' \\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      ', ALIGNED.MESH.Orient(6:end),     ' \\n");', ENDL]);
% extra mesh pointer info
fprintf(fid, ['        ', 'mexPrintf("      ', ALIGNED.MESH_SUBDOMAIN.Struct_List(6:end),      ' \\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      ', 'The following inputs are 1x3 cell arrays: {Cell_Indices, Global_Coord, Neighbors}', ' \\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      ', '   Cell_Indices = initial guess for the enclosing cells of Global_Coord.', ' \\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      ', '                  (this can be an empty matrix)', ' \\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      ', '   Global_Coord = global coordinates of points to search for in the sub-Domain.', ' \\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      ', '   Neighbors    = neighbor data structure for the sub-Domain.', ' \\n");', ENDL]);
for di = 1:NUM_Domains
    fprintf(fid, ['        ', 'mexPrintf("      ', ALIGNED.SEARCH(di).Domain(6:end), ' \\n");', ENDL]);
end
fprintf(fid, ['        ', 'mexPrintf("\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      -------------------------------------------------\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      Output is an array of structs:\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      POINTS(:).DATA = {Cell_Indices, Local_Ref_Coord}\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      POINTS(:).Name = ''name of sub-Domain where points were found''\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      OUTPUTS For sub-Domains (in consecutive order) \\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      -------------------------------------------------\\n");', ENDL]);
for di = 1:NUM_Domains
    fprintf(fid, ['        ', 'mexPrintf("      ', Search_Domains{di}.Name, ' \\n");', ENDL]);
end
fprintf(fid, ['        ', 'mexPrintf("\\n");', ENDL]);
fprintf(fid, ['        ', 'mexErrMsgTxt("Check the number of input arguments!");', ENDL]);
fprintf(fid, ['        ', '}', ENDL]);
fprintf(fid, ['    ', 'if (nlhs!=1) mexErrMsgTxt("1 output is required!");', ENDL]);
fprintf(fid, ['    ', '/* END: Error Checking */', ENDL]);
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
%%%%%%%

% generate code for outputing interpolation data back to MATLAB
fprintf(fid, ['', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['    ', '// declare the point search object', ENDL]);
fprintf(fid, ['    ', 'Generic_Point_Search*   Pt_Search_obj;', ENDL]);
fprintf(fid, ['    ', 'Pt_Search_obj = new Generic_Point_Search(prhs);', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['    ', '/*** search for points! ***/', ENDL]);
fprintf(fid, ['    ', 'Pt_Search_obj->Find_Points();', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['    ', '// output found points back to MATLAB', ENDL]);
fprintf(fid, ['    ', 'Pt_Search_obj->Init_Output_Data(plhs);', ENDL]);
fprintf(fid, ['    ', 'Pt_Search_obj->Output_Points(plhs);', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['    ', 'delete(Pt_Search_obj);', ENDL]);
fprintf(fid, ['}', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['/***/', ENDL]);

% DONE!
fclose(fid);

end