function Gen_Block_Assemble_FE_Matrix_Specific_cc(obj,FS,FM,MAT_Name)
%Gen_Block_Assemble_FE_Matrix_Specific_cc
%
%   This generates the file: "Block_Assemble_FE_Matrix_Specific.cc", except with a more
%   specific filename!

% Copyright (c) 06-15-2016,  Shawn W. Walker

% get everything we need for this matrix
Specific = FM.Get_Specific_Matrix_Data(FS,MAT_Name);
% also need this (sometimes)
FE_Matrix = FM.Matrix(MAT_Name);

% parse out basis function and element info
% we just need some general info like the number of basis functions, which is
% the same over all integration domains
% Note: one can have multiple Specific(s) if there is more than one
%       integration domain in defining the matrix!

if isempty(Specific(1).RowFunc)
    RowElem = Specific(1).MAT.row_func.Elem;
    % get the correct number of components in the row
    if isfield(FE_Matrix,'Num_Row')
        Row_Space_Tuple = [FE_Matrix.Num_Row, 1];
    else
        Row_Space_Tuple = [1, 1];
    end
else
    RowElem = Specific(1).RowFunc.Elem;
    Row_Space = FS.Space(Specific(1).RowFunc.Space_Name);
    Row_Space_Tuple = Row_Space.Num_Comp;
end
if isempty(Specific(1).ColFunc)
    ColElem = Specific(1).MAT.col_func.Elem;
    % get the correct number of components in the col
    if isfield(FE_Matrix,'Num_Col')
        Col_Space_Tuple = [FE_Matrix.Num_Col, 1];
    else
        Col_Space_Tuple = [1, 1];
    end
else
    ColElem = Specific(1).ColFunc.Elem;
    Col_Space = FS.Space(Specific(1).ColFunc.Space_Name);
    Col_Space_Tuple = Col_Space.Num_Comp;
end
Row_Space_Num_Comp = prod(Row_Space_Tuple);
Col_Space_Num_Comp = prod(Col_Space_Tuple);

% basic error checking
Sample_MAT = Specific(1).MAT;
FEM_Matrix_Specific_Consistency_Check(Sample_MAT,Row_Space_Num_Comp,Col_Space_Num_Comp);

% get C++ name information
MAT_CPP_Info = FM.Get_Matrix_CPP_Info(MAT_Name);

ENDL = '\n';

% start with Hdr part
File1 = MAT_CPP_Info.Block_Assemble_File_Name;
WRITE_File = fullfile(obj.Output_Dir, obj.Sub_Dir.Matrix_Classes, File1);
FEL_CopyFile(fullfile(obj.Skeleton_Dir, 'Block_Global_FE_Matrix_Specific_Hdr.cc'),WRITE_File);

% open file for writing
fid = fopen(WRITE_File, 'a');

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // Block Global matrix contains:
% //
% // delta_nn_Anchoring
% //
% /*------------   END: Auto Generate ------------*/

% get all block matrices (only one for now!)
Block_Matrices.Name = MAT_CPP_Info.Matrix_Name;
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['// Block Global matrix contains:', ENDL]);
fprintf(fid, ['//', ENDL]);
for ind = 1:length(Block_Matrices)
    fprintf(fid, ['//', Block_Matrices(ind).Name, ENDL]);
end
fprintf(fid, ['//', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // define the name of the block FE matrix (should be the same as the filename of this file)
% #define SpecificFEM        Stiff_Matrix
% #define SpecificFEM_str   "Stiff_Matrix"
% 
% // the row function space is Type = CG, Name = "lagrange_deg2_dim1"
% 
% // set the number of vector components
% #define ROW_NC  1
% // set the number of basis functions on each element
% #define ROW_NB  3
% 
% // the col function space is Type = CG, Name = "lagrange_deg2_dim1"
% 
% // set the number of vector components
% #define COL_NC  1
% // set the number of basis functions on each element
% #define COL_NB  3
% 
% // set the number of quad points
% #define NQ  8
% /*------------   END: Auto Generate ------------*/

% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['// define the name of the block FE matrix (should be the same as the filename of this file)', ENDL]);
fprintf(fid, ['#define SpecificFEM        ', MAT_CPP_Info.Block_Assemble_Data_Type_Name, ENDL]);
% SWW: this will need to change when we have more than one block in the matrix
fprintf(fid, ['#define SpecificFEM_str   "', MAT_CPP_Info.Matrix_Name, '"', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// the row function space is Type = ',...
                  RowElem.Element_Type, ', Name = "', RowElem.Element_Name, '"' ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// set the number of blocks along the row dimension', ENDL]);
fprintf(fid, ['#define ROW_Num_Block  ', num2str(1), ENDL]);
fprintf(fid, ['// set the number of basis functions on each element', ENDL]);
fprintf(fid, ['#define ROW_NB         ', num2str(RowElem.Num_Basis), ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// the col function space is Type = ',...
                  ColElem.Element_Type, ', Name = "', ColElem.Element_Name, '"' ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// set the number of blocks along the col dimension', ENDL]);
fprintf(fid, ['#define COL_Num_Block  ', num2str(1), ENDL]);
fprintf(fid, ['// set the number of basis functions on each element', ENDL]);
fprintf(fid, ['#define COL_NB  ', num2str(ColElem.Num_Basis), ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% EXAMPLE:
%%%%%%%
% /***************************************************************************************/
% /* C++ (Specific) Block Global FE matrix class definition */
% class SpecificFEM: public Block_Global_FE_MATRIX_Class // derive from base class
% {
% public:
%     // data structure for sub-matrices of the main block FE matrix:
% 	  //      vector component offsets for inserting into global block matrix
% 	  int     Block_Row_Shift[ROW_Num_Block];
% 	  int     Block_Col_Shift[COL_Num_Block];

% output text-lines
fprintf(fid, ['', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* C++ (Specific) Block Global FE matrix class definition */', ENDL]);
fprintf(fid, ['class SpecificFEM: public Block_Assemble_FE_MATRIX_Class // derive from base class', ENDL]);
fprintf(fid, ['{', ENDL]);
fprintf(fid, ['public:', ENDL]);
fprintf(fid, ['    ', '// data structure for sub-blocks of the block FE matrix:', ENDL]);
fprintf(fid, ['    ', '//      offsets for inserting sub-blocks into the global block matrix', ENDL]);
fprintf(fid, ['    ', 'int     Block_Row_Shift[ROW_Num_Block];', ENDL]);
fprintf(fid, ['    ', 'int     Block_Col_Shift[COL_Num_Block];', ENDL]);
fprintf(fid, ['', ENDL]);

% EXAMPLE:
%%%%%%%
% this will write the pre-declarations
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// constructor', ENDL]);
Num_Blocks = 1;
[~, ~, Block_Matrix_Arg_0] = Get_Assemble_Matrix_Call(Num_Blocks,MAT_CPP_Info,[]);
CONSTRUCTOR_STR = ['SpecificFEM (const PTR_TO_SPARSE*, ', Block_Matrix_Arg_0, ');'];
fprintf(fid, ['    ', CONSTRUCTOR_STR, ENDL]);
fprintf(fid, ['    ', '~SpecificFEM (); // destructor', ENDL]);
fprintf(fid, ['    ', 'void Init_Matrix_Assembler_Object(bool);', ENDL]);
for ind = 1:length(Specific)
    % SWW: need to modify this when we have more than one block!
    DoI = Specific(ind).GeoFunc.Domain.Integration_Domain.Name;
    %ARG = ['(const ', Specific(ind).GeoFunc.CPP.Data_Type_Name, '&', Block_Matrix_Arg, ')'];
    ARG = ['(', Block_Matrix_Arg_0, ')'];
    fprintf(fid, ['    ', 'void Add_Entries_To_Global_Matrix_', DoI, ' ', ARG, ';', ENDL]);
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', 'private:', ENDL]);
fprintf(fid, ['};', ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% EXAMPLE:
%%%%%%%
% this will write the constructor call
fprintf(fid, ['', ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', '/* constructor */', ENDL]);
fprintf(fid, ['', obj.BEGIN_Auto_Gen, ENDL]);
ARG_1_str = ['const PTR_TO_SPARSE* Prev_Sparse_Data'];
fprintf(fid, ['', 'SpecificFEM::SpecificFEM (', ARG_1_str, ',', ENDL]);
for ind = 1:Num_Blocks
    if (ind==Num_Blocks)
        fprintf(fid, ['', '                          ', 'const ', MAT_CPP_Info.Base_Data_Type_Name, '* Block_00', ENDL]);
    else
        fprintf(fid, ['', '                          ', 'const ', MAT_CPP_Info.Base_Data_Type_Name, '* XXXXX,', ENDL]);
    end
end
fprintf(fid, ['', '                          ) :', ENDL]);
fprintf(fid, ['', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', 'Block_Assemble_FE_MATRIX_Class () // call the base class constructor', ENDL]);
fprintf(fid, ['', '{', ENDL]);
fprintf(fid, ['    ', '// set the ''Name'' of this Global matrix', ENDL]);
fprintf(fid, ['    ', 'Name = (char*) SpecificFEM_str; // this should be similar to the Class identifier', ENDL]);
% get the number of block matrices
fprintf(fid, ['    ', '// record the number of block matrices (in the global matrix)', ENDL]);
% SWW: this will change once we allow for block matrices!
fprintf(fid, ['    ', 'Num_Blocks = ', num2str(Num_Blocks), ';', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['    ', 'Sparse_Data = Prev_Sparse_Data;', ENDL]);
fprintf(fid, ['    ', 'bool simple_assembler;', ENDL]);
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
ROW_CONST = strcmp(RowElem.Element_Type,'constant_one');
COL_CONST = strcmp(ColElem.Element_Type,'constant_one');
if or(ROW_CONST,COL_CONST)
    fprintf(fid, ['    ', 'simple_assembler = true; // better to use a full matrix', ENDL]);
else
    fprintf(fid, ['    ', 'simple_assembler = false; // use sparse matrix format', ENDL]);
end
fprintf(fid, ['', ENDL]);

%%%%%%%
% record global matrix dimensions
fprintf(fid, ['    ', '// record the size of the block global matrix (only for ONE block)', ENDL]);
fprintf(fid, ['    ', 'global_num_row = Block_00->get_global_num_row();', ENDL]);
fprintf(fid, ['    ', 'global_num_col = Block_00->get_global_num_col();', ENDL]);
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);

% EXAMPLE:
%%%%%%%
%     /*------------ BEGIN: Auto Generate ------------*/
%     // input information for offsetting the sub-blocks
%     Block_Row_Shift[0] = 0*XXXX;
%     Block_Col_Shift[0] = 0*XXXXX;
%     /*------------   END: Auto Generate ------------*/

% output text-lines
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// input information for offsetting the sub-blocks', ENDL]);
ROW_Num_Block = 1;
COL_Num_Block = 1;
for index = 0:ROW_Num_Block-1
    offset_str = num2str(index);
    Sub_Row_str = ['Block_Row_Shift[', offset_str, '] = ', offset_str, '*', 'Block_00->get_global_num_row();'];
    fprintf(fid, ['    ', Sub_Row_str, ENDL]);
end
for index = 0:COL_Num_Block-1
    offset_str = num2str(index);
    Sub_Row_str = ['Block_Col_Shift[', offset_str, '] = ', offset_str, '*', 'Block_00->get_global_num_col();'];
    fprintf(fid, ['    ', Sub_Row_str, ENDL]);
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['    ', 'Init_Matrix_Assembler_Object(simple_assembler);', ENDL]);
fprintf(fid, ['', '}', ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['', ENDL]);

% EXAMPLE:
%%%%%%%
% this will write the destructor routine
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', '/* destructor: should not usually need to be modified */', ENDL]);
fprintf(fid, ['', 'SpecificFEM::~SpecificFEM ()', ENDL]);
fprintf(fid, ['', '{', ENDL]);
fprintf(fid, ['    ', 'delete(MAT);', ENDL]);
fprintf(fid, ['', '}', ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['', ENDL]);

% EXAMPLE:
%%%%%%%
% this is a general init routine
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', '/* this initializes the object that handles matrix assembly */', ENDL]);
fprintf(fid, ['', 'void SpecificFEM::Init_Matrix_Assembler_Object(bool use_simple_assembler)', ENDL]);
fprintf(fid, ['', '{', ENDL]);
fprintf(fid, ['    ', 'if (use_simple_assembler)', ENDL]);
fprintf(fid, ['        ', '// create SimpleMatrixAssembler object', ENDL]);
fprintf(fid, ['        ', 'MAT = new SimpleMatrixAssembler(global_num_row,global_num_col); // assemble from scratch', ENDL]);
fprintf(fid, ['    ', 'else if (Sparse_Data->valid)', ENDL]);
fprintf(fid, ['        ', '{', ENDL]);
fprintf(fid, ['        ', 'int str_diff = strcmp(Sparse_Data->name,Name);', ENDL]);
fprintf(fid, ['        ', 'if (str_diff!=0)', ENDL]);
fprintf(fid, ['            ', '{', ENDL]);
fprintf(fid, ['            ', 'mexPrintf("Matrix names do not match!\\n");', ENDL]);
fprintf(fid, ['            ', 'mexPrintf("Previously assembled matrix name is:  %%s.\\n", Sparse_Data->name);', ENDL]);
fprintf(fid, ['            ', 'mexPrintf("The name SHOULD have been:            %%s.\\n", Name);', ENDL]);
fprintf(fid, ['            ', 'mexErrMsgTxt("Check the previously assembled matrix structure!\\n");', ENDL]);
fprintf(fid, ['            ', '}', ENDL]);
fprintf(fid, ['        ', 'if (Sparse_Data->m!=global_num_row)', ENDL]);
fprintf(fid, ['            ', '{', ENDL]);
fprintf(fid, ['            ', 'mexPrintf("Error with this matrix:   %%s.\\n", Name);', ENDL]);
fprintf(fid, ['            ', 'mexErrMsgTxt("Number of rows in previous matrix does not match what the new matrix should be.\\n");', ENDL]);
fprintf(fid, ['            ', '}', ENDL]);
fprintf(fid, ['        ', 'if (Sparse_Data->n!=global_num_col)', ENDL]);
fprintf(fid, ['            ', '{', ENDL]);
fprintf(fid, ['            ', 'mexPrintf("Error with this matrix:   %%s.\\n", Name);', ENDL]);
fprintf(fid, ['            ', 'mexErrMsgTxt("Number of columns in previous matrix does not match what the new matrix should be.\\n");', ENDL]);
fprintf(fid, ['            ', '}', ENDL]);
fprintf(fid, ['        ', '// create MatrixReassembler object (cf. David Bindel)', ENDL]);
fprintf(fid, ['        ', 'MAT = new MatrixReassembler(Sparse_Data->jc,Sparse_Data->ir,Sparse_Data->pr,global_num_row,global_num_col);', ENDL]);
fprintf(fid, ['        ', '// use previous sparse structure', ENDL]);
fprintf(fid, ['        ', '}', ENDL]);
fprintf(fid, ['    ', 'else // create MatrixAssembler object (cf. David Bindel)', ENDL]);
fprintf(fid, ['        ', 'MAT = new MatrixAssembler(global_num_row,global_num_col); // assemble from scratch', ENDL]);
fprintf(fid, ['', '}', ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', ENDL]);

% generate the call for assembling and adding the local FE matrix to the
% block global FE matrix
for ind = 1:length(Specific)
    status = obj.Write_SUBRoutine_Add_Entries_To_Block_Global_Matrix(fid,Specific(ind),MAT_CPP_Info,Row_Space_Num_Comp,Col_Space_Num_Comp);
end

% EXAMPLE:
%%%%%%%
% close up the file
fprintf(fid, ['', '// remove those macros!', ENDL]);
fprintf(fid, ['', '#undef SpecificFEM', ENDL]);
fprintf(fid, ['', '#undef SpecificFEM_str', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['', '#undef ROW_Num_Block', ENDL]);
fprintf(fid, ['', '#undef ROW_NB', ENDL]);
fprintf(fid, ['', '#undef COL_Num_Block', ENDL]);
fprintf(fid, ['', '#undef COL_NB', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['/***/', ENDL]);
fprintf(fid, ['', ENDL]);

% DONE!
fclose(fid);

end