function DEFINES = Gen_mexAssemble_FEM_cpp(obj,FS,FM)
%Gen_mexAssemble_FEM_cpp
%
%   This generates the file: "mexAssemble_FEM.cpp".

% Copyright (c) 06-04-2012,  Shawn W. Walker

% start with A part
File1 = 'mexAssemble_FEM.cpp';
WRITE_File = fullfile(obj.Output_Dir, File1);
FEL_CopyFile(fullfile(obj.Skeleton_Dir, 'mexAssemble_FEM_A.cpp'),WRITE_File);

% open file for writing
fid = fopen(WRITE_File, 'a');

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // define input indices
% #define PRHS_OLD_FEM            0
% #define PRHS_Mesh_Node_Values   1
% #define PRHS_Mesh_DoFmap        2
% #define PRHS_Orient             3
% #define PRHS_???              XXX
% #define PRHS_ROW_Space_DoFmap   4
% #define PRHS_COL_Space_DoFmap   5
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

fprintf(fid, ['#define ', ALIGNED.OLD.FEM,         ENDL]);
fprintf(fid, ['#define ', ALIGNED.MESH.Node_Value, ENDL]);
fprintf(fid, ['#define ', ALIGNED.MESH.DoFmap,     ENDL]);
fprintf(fid, ['#define ', ALIGNED.MESH.Orient,     ENDL]);
LAST_IND = 3;

% if we are assembling over a domain of co-dimension > 0, then output links to
% extra mesh pointer info
if ~isempty(ALIGNED.MESH_SUBDOMAIN)
    fprintf(fid, ['#define ', ALIGNED.MESH_SUBDOMAIN.Struct_List, ENDL]);
    LAST_IND = LAST_IND + 1;
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

% output links to subset of element indices
LAST_IND = LAST_IND + 1;
fprintf(fid, ['#define ', [obj.Pad_With_Whitespace('PRHS_Subset_Elem_Indices',SPACE_LEN), ' ', num2str(LAST_IND)], ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
%%%%%%%

% append the B part
Fixed_File = fullfile(obj.Skeleton_Dir, 'mexAssemble_FEM_B.cpp');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% EXAMPLE:
%%%%%%%
%     /*------------ BEGIN: Auto Generate ------------*/
%     /* BEGIN: Error Checking */
%     if (nrhs!=6)
%         {
%         printf("ERROR: 6 inputs required!\n");
%         printf("\n");
%         printf("      INPUT                 ORDER   \n");
%         printf("      -------------------   -----   \n");
%         printf("      Mesh_Node_Values        0     \n");
%         printf("      Mesh_DoFmap             1     \n");
%         printf("      Orient                  2     \n");
%         printf("      ROW_Space_Values        3     \n");
%         printf("      ROW_Space_DoFmap        4     \n");
%         printf("      COL_Space_Values        5     \n");
%         printf("      COL_Space_DoFmap        6     \n");
%         printf("\n");
%         mexErrMsgTxt("Check the number of input arguments!");
%         }
%     if (nlhs!=1) mexErrMsgTxt("1 output is required!");
%     /* END: Error Checking */
%     /*------------   END: Auto Generate ------------*/

% NUM_ARG = LAST_IND + 1; % ignore!
NUM_ARG = LAST_IND;

%%%%%%%
% output text-lines
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '/* BEGIN: Error Checking */', ENDL]);
fprintf(fid, ['    ', 'if ( (nrhs < ', num2str(NUM_ARG), ') || (nrhs > ', num2str(NUM_ARG+1), ') )', ENDL]);
fprintf(fid, ['        ', '{', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("ERROR: ', num2str(NUM_ARG), ' inputs required!\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      INPUTS                                                          ORDER \\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      -------------------                                             ----- \\n");', ENDL]);
%%%%%
fprintf(fid, ['        ', 'mexPrintf("      ', ALIGNED.OLD.FEM(6:end), ' \\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      ', ALIGNED.MESH.Node_Value(6:end), ' \\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      ', ALIGNED.MESH.DoFmap(6:end),     ' \\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      ', ALIGNED.MESH.Orient(6:end),     ' \\n");', ENDL]);
% extra mesh pointer info
fprintf(fid, ['        ', 'mexPrintf("      ', ALIGNED.MESH_SUBDOMAIN.Struct_List(6:end),      ' \\n");', ENDL]);
for si = 1:NUM_SPACES
    if ALIGNED.SPACE(si).Valid
        fprintf(fid, ['        ', 'mexPrintf("      ', ALIGNED.SPACE(si).DoFmap(6:end),     ' \\n");', ENDL]);
    end
end
for fi = 1:NUM_FUNC
    fprintf(fid, ['        ', 'mexPrintf("      ', ALIGNED.FUNC(fi).Node_Value(6:end), ' \\n");', ENDL]);
end
% can pass extra info on subset of elements to assemble
fprintf(fid, ['        ', 'mexPrintf("      ', '(optional) ', 'subset of element indices (array of structs):          ', num2str(NUM_ARG), '\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      ', '     SUB(i).DoI_Name = string containing name of', '\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      ', '                       Domain of Integration (DoI).', '\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      ', '     SUB(i).Elem_Indices = uint32 array of ''local'' element', '\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      ', '                 indices that index into the DoI''s embedding', '\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      ', '                 data.', '\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      OUTPUTS (in consecutive order) \\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("      ---------------------------------------- \\n");', ENDL]);
Matrix_Names = FM.Matrix.keys;
NUM_MATRIX = length(Matrix_Names);
for mi = 1:NUM_MATRIX
    fprintf(fid, ['        ', 'mexPrintf("      ', Matrix_Names{mi}, ' \\n");', ENDL]);
end
fprintf(fid, ['        ', 'mexPrintf("\\n");', ENDL]);
fprintf(fid, ['        ', 'mexErrMsgTxt("Check the number of input arguments!");', ENDL]);
fprintf(fid, ['        ', '}', ENDL]);
fprintf(fid, ['    ', 'if (nlhs!=1) mexErrMsgTxt("1 output is required!");', ENDL]);
fprintf(fid, ['    ', '/* END: Error Checking */', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['    ', 'const mxArray* Subset_Elem;', ENDL]);
fprintf(fid, ['    ', 'if (nrhs==', num2str(NUM_ARG), ')', ENDL]);
fprintf(fid, ['    ', '    ', 'Subset_Elem = NULL; // assemble over *all* elements', ENDL]);
fprintf(fid, ['    ', 'else', ENDL]);
fprintf(fid, ['    ', '    ', 'Subset_Elem = prhs[PRHS_Subset_Elem_Indices]; // assemble over a subset', ENDL]);
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
%%%%%%%

% append the C part
Fixed_File = fullfile(obj.Skeleton_Dir, 'mexAssemble_FEM_C.cpp');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% generate code for outputing matrices back to MATLAB
fprintf(fid, ['    ', 'FEM_Assem_obj->Output_Matrices(plhs);', ENDL]);
fprintf(fid, ['', ENDL]);

% convenient test code...
% fprintf(fid, ['    ', 'SCALAR sc_uninit;', ENDL]);
% fprintf(fid, ['    ', 'mexPrintf("sc_uninit = %%1.5f\\n",sc_uninit.a);', ENDL]);
% %fprintf(fid, ['    ', 'SCALAR sc_init();', ENDL]);
% %fprintf(fid, ['    ', 'mexPrintf("sc_init = %%1.5f\\n",sc_init.a);', ENDL]);
% fprintf(fid, ['    ', 'SCALAR sc_val(3.3);', ENDL]);
% fprintf(fid, ['    ', 'mexPrintf("sc_val = %%1.5f\\n",sc_val.a);', ENDL]);

fprintf(fid, ['    ', 'delete(FEM_Assem_obj);', ENDL]);
fprintf(fid, ['}', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['/***/', ENDL]);
%fprintf(fid, ['', ENDL]);

% DONE!
fclose(fid);

end