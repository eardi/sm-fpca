function DEFINES = Gen_mexInterpolate_FEM_cpp(obj,FS,FI)
%Gen_mexInterpolate_FEM_cpp
%
%   This generates the file: "mexInterpolate_FEM.cpp".

% Copyright (c) 01-29-2013,  Shawn W. Walker

% start with A part
File1 = 'mexInterpolate_FEM.cpp';
WRITE_File = fullfile(obj.Output_Dir, File1);
FEL_CopyFile(fullfile(obj.Skeleton_Dir, 'mexInterpolate_FEM_A.cpp'),WRITE_File);

% open file for writing
fid = fopen(WRITE_File, 'a');

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // define input indices
% #define PRHS_Mesh_Node_Values     0
% #define PRHS_Mesh_DoFmap          1
% #define PRHS_Orient               2
% #define PRHS_???                 XXX
% #define PRHS_Gamma_Interp_Data    4
% #define PRHS_Omega_Interp_Data    5
% etc...
% /*------------   END: Auto Generate ------------*/

ENDL = '\n';
SPACE_LEN = 70;
mex_strings = obj.Get_MEX_Gateway_Arguments(FS);

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

% output links to interpolation points (domains)
Interp_Domains = FI.Get_Distinct_Domains;
NUM_Interp_Domains = length(Interp_Domains);
for di = 1:NUM_Interp_Domains
    Dom_Name = Interp_Domains{di}.Name;
    CPP_DOM = FI.Get_CPPdefine_Domain_Name(Dom_Name);
    LAST_IND = LAST_IND + 1;
    ALIGNED.INTERP(di).Domain = [obj.Pad_With_Whitespace(CPP_DOM.MEX_Interp_Data, SPACE_LEN), ' ', num2str(LAST_IND)];
    fprintf(fid, ['#define ', ALIGNED.INTERP(di).Domain,     ENDL]);
end

% output links to finite element spaces
Space_Names = FS.Space.keys;
NUM_SPACES = length(Space_Names);
for si = 1:NUM_SPACES
    % only need to get DoFmaps for finite element spaces that are NOT
    % global constants!
    if ~strcmp(FS.Space(Space_Names{si}).Elem.Element_Name,'constant_one')
        CPP_SPACE = FS.Get_CPPdefine_Space_Name(Space_Names{si});
        LAST_IND = LAST_IND + 1;
        ALIGNED.SPACE(si).DoFmap = [obj.Pad_With_Whitespace(CPP_SPACE.MEX_DoFmap,    SPACE_LEN), ' ', num2str(LAST_IND)];
        ALIGNED.SPACE(si).Valid  = true;
        fprintf(fid, ['#define ', ALIGNED.SPACE(si).DoFmap,     ENDL]);
    else
        ALIGNED.SPACE(si).DoFmap = '';
        ALIGNED.SPACE(si).Valid  = false;
    end
end

% output links to external coefficient functions
CoefFunc_Names = FS.Get_Unique_CoefFunc_Names;
NUM_FUNC = length(CoefFunc_Names);
for fi = 1:NUM_FUNC
    CPP_FUNC = FS.Get_CPPdefine_Func_Name(CoefFunc_Names{fi});
    LAST_IND = LAST_IND + 1;
    ALIGNED.FUNC(fi).Node_Value = [obj.Pad_With_Whitespace(CPP_FUNC.MEX_Node_Value,SPACE_LEN), ' ', num2str(LAST_IND)];
    fprintf(fid, ['#define ', ALIGNED.FUNC(fi).Node_Value, ENDL]);
end
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
%%%%%%%

% append the B part
Fixed_File = fullfile(obj.Skeleton_Dir, 'mexInterpolate_FEM_B.cpp');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% EXAMPLE:
%%%%%%%
%     /*------------ BEGIN: Auto Generate ------------*/
%     /* BEGIN: Error Checking */
%     if (nrhs!=9)
%         {
%         mexPrintf("ERROR: 9 inputs required!\n");
%         mexPrintf("\n");
%         mexPrintf("      INPUTS                                                          ORDER \n");
%         mexPrintf("      -------------------                                             ----- \n");
%         mexPrintf("      Omega_Mesh_Vertices                                               0 \n");
%         mexPrintf("      Omega_Mesh_DoFmap                                                 1 \n");
%         mexPrintf("      EMPTY_1                                                           2 \n");
%         mexPrintf("      EMPTY_2                                                           3 \n");
%         mexPrintf("      Omega_Interp_Data                                                 4 \n");
%         mexPrintf("      Scalar_P2_DoFmap                                                  5 \n");
%         mexPrintf("      Vector_P1_DoFmap                                                  6 \n");
%         mexPrintf("      p_Values                                                          7 \n");
%         mexPrintf("      v_Values                                                          8 \n");
%         mexPrintf("\n");
%         mexPrintf("      OUTPUTS (in consecutive order) \n");
%         mexPrintf("      ---------------------------------------- \n");
%         mexPrintf("      I_p \n");
%         mexPrintf("      I_v \n");
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
for di = 1:NUM_Interp_Domains
    fprintf(fid, ['        ', 'mexPrintf("      ', ALIGNED.INTERP(di).Domain(6:end),     ' \\n");', ENDL]);
end
for si = 1:NUM_SPACES
    if ALIGNED.SPACE(si).Valid
        fprintf(fid, ['        ', 'mexPrintf("      ', ALIGNED.SPACE(si).DoFmap(6:end),     ' \\n");', ENDL]);
    end
end
for fi = 1:NUM_FUNC
    fprintf(fid, ['        ', 'mexPrintf("      ', ALIGNED.FUNC(fi).Node_Value(6:end), ' \\n");', ENDL]);
end
fprintf(fid, ['        ', 'mexPrintf("\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      OUTPUTS (in consecutive order) \\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      ---------------------------------------- \\n");', ENDL]);
Interp_Names = FI.keys;
NUM_INTERP = length(Interp_Names);
for mi = 1:NUM_INTERP
    fprintf(fid, ['        ', 'mexPrintf("      ', Interp_Names{mi}, ' \\n");', ENDL]);
end
fprintf(fid, ['        ', 'mexPrintf("\\n");', ENDL]);
fprintf(fid, ['        ', 'mexErrMsgTxt("Check the number of input arguments!");', ENDL]);
fprintf(fid, ['        ', '}', ENDL]);
fprintf(fid, ['    ', 'if (nlhs!=1) mexErrMsgTxt("1 output is required!");', ENDL]);
fprintf(fid, ['    ', '/* END: Error Checking */', ENDL]);
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
%%%%%%%

% append the C part
Fixed_File = fullfile(obj.Skeleton_Dir, 'mexInterpolate_FEM_C.cpp');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% generate code for outputing interpolation data back to MATLAB
fprintf(fid, ['    ', 'FEM_Interp_obj->Output_Interpolations(plhs);', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['    ', 'delete(FEM_Interp_obj);', ENDL]);
fprintf(fid, ['}', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['/***/', ENDL]);
%fprintf(fid, ['', ENDL]);

% DONE!
fclose(fid);

end