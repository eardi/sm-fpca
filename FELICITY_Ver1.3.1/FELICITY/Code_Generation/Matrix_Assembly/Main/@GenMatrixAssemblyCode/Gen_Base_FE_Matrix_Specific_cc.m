function Gen_Base_FE_Matrix_Specific_cc(obj,FS,FM,MAT_Name,GeomFunc,BasisFunc,CoefFunc)
%Gen_Base_FE_Matrix_Specific_cc
%
%   This generates the file: "Single_FE_Matrix_Specific.cc", except with a more
%   specific filename!

% Copyright (c) 03-23-2018,  Shawn W. Walker

% get everything we need for this matrix
Specific = FM.Get_Specific_Matrix_Data(FS,MAT_Name);
% also need this (sometimes)
FE_Matrix = FM.Matrix(MAT_Name);

% parse out basis function and element info
% we just need some general info like the number of basis functions, which is
% the same over all integration domains
% Note: one can have multiple Specific(s) if there is more than one
%       integration domain in defining the matrix!

Test_Func_Valid  = true;
Trial_Func_Valid = true;
if isempty(Specific(1).RowFunc)
    % there is no Row Space
    Row_Func = Specific(1).MAT.row_func;
    Test_Func_Valid = false;
    % get the correct number of components in the row
    if isfield(FE_Matrix,'Num_Row')
        Row_Space_Tuple = [FE_Matrix.Num_Row, 1];
    else
        Row_Space_Tuple = [1 1];
    end
else
    Row_Func = Specific(1).RowFunc;
    Row_Space = FS.Space(Row_Func.Space_Name);
    Row_Space_Tuple = Row_Space.Num_Comp;
end
if isempty(Specific(1).ColFunc)
    Col_Func = Specific(1).MAT.col_func;
    Trial_Func_Valid = false;
    % get the correct number of components in the col
    if isfield(FE_Matrix,'Num_Col')
        Col_Space_Tuple = [FE_Matrix.Num_Col, 1];
    else
        Col_Space_Tuple = [1 1];
    end
else
    Col_Func = Specific(1).ColFunc;
    Col_Space = FS.Space(Col_Func.Space_Name);
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
File1 = MAT_CPP_Info.Base_File_Name;
WRITE_File = fullfile(obj.Output_Dir, obj.Sub_Dir.Matrix_Classes, File1);
FEL_CopyFile(fullfile(obj.Skeleton_Dir, 'Local_FE_Matrix_Specific_Hdr.cc'),WRITE_File);

% open file for writing
fid = fopen(WRITE_File, 'a');

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // FEM matrix is:
% //
% // \int v * u
% //
% /*------------   END: Auto Generate ------------*/

% get all integrals for given matrix
Integrand = FM.Get_All_Matrix_Integrals(MAT_Name);
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['// FE matrix is:', ENDL]);
fprintf(fid, ['//', ENDL]);
Num_Integrand = length(Integrand);
for ind = 1:Num_Integrand
    Int_STR = ['// \\int_{', Integrand(ind).Domain.Integration_Domain.Name, '}  ', Integrand(ind).Str];
    if (ind < Num_Integrand)
        fprintf(fid, [Int_STR, ' + ', ENDL]);
    else
        fprintf(fid, [Int_STR, ENDL]);
    end
end
fprintf(fid, ['//', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // define the name of the FEM matrix (should be the same as the filename of this file)
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
fprintf(fid, ['// define the name of the FEM matrix (should be the same as the filename of this file)', ENDL]);
fprintf(fid, ['#define SpecificFEM        ', MAT_CPP_Info.Base_Data_Type_Name, ENDL]);
fprintf(fid, ['#define SpecificFEM_str   "', MAT_CPP_Info.Matrix_Name, '"', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// the row function space is Type = ',...
                  Row_Func.Elem.Element_Type, ', Name = "', Row_Func.Elem.Element_Name, '"' ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// set the number of cartesian tuple components (m*n) = ',...
              num2str(Row_Space_Tuple(1)), ' * ', num2str(Row_Space_Tuple(2)), ENDL]);
fprintf(fid, ['#define ROW_NC  ', num2str(Row_Space_Num_Comp), ENDL]);
fprintf(fid, ['// NOTE: the (i,j) tuple component is accessed by the linear index k = i + (j-1)*m', ENDL]);
fprintf(fid, ['// set the number of basis functions on each element', ENDL]);
fprintf(fid, ['#define ROW_NB  ', num2str(Row_Func.Elem.Num_Basis), ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// the col function space is Type = ',...
                  Col_Func.Elem.Element_Type, ', Name = "', Col_Func.Elem.Element_Name, '"' ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// set the number of cartesian tuple components (m*n) = ',...
              num2str(Col_Space_Tuple(1)), ' * ', num2str(Col_Space_Tuple(2)), ENDL]);
fprintf(fid, ['#define COL_NC  ', num2str(Col_Space_Num_Comp), ENDL]);
fprintf(fid, ['// NOTE: the (i,j) tuple component is accessed by the linear index k = i + (j-1)*m', ENDL]);
fprintf(fid, ['// set the number of basis functions on each element', ENDL]);
fprintf(fid, ['#define COL_NB  ', num2str(Col_Func.Elem.Num_Basis), ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% EXAMPLE:
%%%%%%%
% /***************************************************************************************/
% /* C++ (Specific) Local FE matrix class definition */
% class SpecificFEM: public Local_FE_MATRIX_Class // derive from base class
% {
% public:

% output text-lines
fprintf(fid, ['', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* C++ (Specific) Local FE matrix class definition */', ENDL]);
fprintf(fid, ['class SpecificFEM: public Base_FE_MATRIX_Class // derive from base class', ENDL]);
fprintf(fid, ['{', ENDL]);
fprintf(fid, ['public:', ENDL]);
fprintf(fid, ['', ENDL]);

%%%%%%%
% output text-lines
fprintf(fid, ['    ', '// data structure for sub-matrices of the global FE matrix:', ENDL]);
fprintf(fid, ['    ', '// row/col offsets for inserting into global FE matrix', ENDL]);
fprintf(fid, ['    ', 'int     Row_Shift[ROW_NC];', ENDL]);
fprintf(fid, ['    ', 'int     Col_Shift[COL_NC];', ENDL]);
fprintf(fid, ['', ENDL]);

% EXAMPLE:
%%%%%%%
%     /*------------ BEGIN: Auto Generate ------------*/
%     // access local mesh info
%     const CLASS_Mesh_Omega_intrinsic_Gamma*    Mesh;
%     /*------------   END: Auto Generate ------------*/

% output text-lines
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// access local mesh geometry info', ENDL]);
for ind = 1:length(GeomFunc)
    fprintf(fid, ['    ', 'const ', GeomFunc{ind}.CPP.Data_Type_Name, '*  ',...
                          GeomFunc{ind}.CPP.Identifier_Name, ';', ENDL]);
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% EXAMPLE:
%%%%%%%
%     /*------------ BEGIN: Auto Generate ------------*/
%     // pointers for accessing FE basis functions
%     const Data_Type_bN_phi_restricted_to_Omega*  bN_phi_restricted_to_Omega;
%     const Data_Type_bS_phi_restricted_to_Omega*  bS_phi_restricted_to_Omega;
%     /*------------   END: Auto Generate ------------*/

% output text-lines
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// pointers for accessing FE basis functions', ENDL]);
for ind = 1:length(BasisFunc)
    fprintf(fid, ['    ', 'const ', BasisFunc{ind}.CPP_Data_Type, '*  ',...
                          BasisFunc{ind}.CPP_Var, ';', ENDL]);
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% EXAMPLE:
%%%%%%%
%     /*------------ BEGIN: Auto Generate ------------*/
%     // pointers for accessing external functions
%     const "EXTERNAL_FEM_Class"*     Ext_FEM_Func_0;
%     /*------------   END: Auto Generate ------------*/

% get number of external functions
NUM_FUNC = length(CoefFunc);
if (NUM_FUNC > 0)
    % output text-lines
    fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
    fprintf(fid, ['    ', '// pointers for accessing coefficient functions', ENDL]);
    for ind = 1:NUM_FUNC
        fprintf(fid, ['    ', 'const ', CoefFunc{ind}.CPP_Data_Type, '*  ',...
            CoefFunc{ind}.CPP_Var, ';', ENDL]);
    end
    fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
end
fprintf(fid, ['', ENDL]);
%%%%%%%

% EXAMPLE:
%%%%%%%
%     /*------------ BEGIN: Auto Generate ------------*/
%     // data tables to hold local FE tensors (matrices)
%     double  FE_Tensor_0[ROW_NB*COL_NB];
%     double  FE_Tensor_1[ROW_NB*COL_NB];
%     double  FE_Tensor_2[ROW_NB*COL_NB];
%     double  FE_Tensor_4[ROW_NB*COL_NB];
%     double  FE_Tensor_5[ROW_NB*COL_NB];
%     double  FE_Tensor_8[ROW_NB*COL_NB];
%     /*------------   END: Auto Generate ------------*/

fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// data tables to hold local FE tensors (matrices)', ENDL]);
% get the local FE tensors to compute 
Comp_Order = Sample_MAT.SubMAT_Computation_Order;
% setup sub-matrix data arrays
for ind = 1:length(Comp_Order)
    index = Comp_Order(ind);
    SubMAT_ind = num2str(Sample_MAT.SubMAT(index).cpp_index);
    Local_Mat_Data_str = ['FE_Tensor_', SubMAT_ind];
    
    % used for tabulating tensor from scratch
    fprintf(fid, ['    ', 'double  ', Local_Mat_Data_str, '[ROW_NB*COL_NB];', ENDL]);
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% EXAMPLE:
%%%%%%%
% this will write the pre-declarations
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// constructor', ENDL]);
CONSTRUCTOR_STR = ['SpecificFEM (const ABSTRACT_FEM_Function_Class*, const ABSTRACT_FEM_Function_Class*);'];
fprintf(fid, ['    ', CONSTRUCTOR_STR, ENDL]);
fprintf(fid, ['    ', '~SpecificFEM (); // destructor', ENDL]);
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);

% EXAMPLE:
%%%%%%%
%     /*------------ BEGIN: Auto Generate ------------*/
%     void Tabulate_Tensor(const CLASS_geom_Omega_embedded_in_Omega_restricted_to_Omega&);
%     /*------------   END: Auto Generate ------------*/
% private:
% };
% output text-lines
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
% tabulate local FE matrix (for each Domain of Integration)
for ind = 1:length(Specific)
    GeoFunc = Specific(ind).GeoFunc;
    fprintf(fid, ['    ', 'void Tabulate_Tensor(const ', GeoFunc.CPP.Data_Type_Name, '&);', ENDL]);
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', 'private:', ENDL]);
fprintf(fid, ['};', ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% EXAMPLE:
%%%%%%%
% this will write the constructor routine
Row_Basis_Func_str = 'row_basis_func';
Col_Basis_Func_str = 'col_basis_func';
fprintf(fid, ['', ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', '/* constructor */', ENDL]);
fprintf(fid, ['', 'SpecificFEM::SpecificFEM (const ABSTRACT_FEM_Function_Class* ', Row_Basis_Func_str, ',', ENDL]);
fprintf(fid, ['', '                          const ABSTRACT_FEM_Function_Class* ', Col_Basis_Func_str, ') :', ENDL]);
fprintf(fid, ['', 'Base_FE_MATRIX_Class () // call the base class constructor', ENDL]);
fprintf(fid, ['', '{', ENDL]);
fprintf(fid, ['    ', '// set the ''Name'' of the form for this local FE matrix', ENDL]);
fprintf(fid, ['    ', 'Form_Name = (char*) SpecificFEM_str; // this should be similar to the Class identifier', ENDL]);
% get the type of form
Form_Type = 'invalid';
if and(Test_Func_Valid,Trial_Func_Valid)
    Form_Type = 'bilinear';
elseif and(Test_Func_Valid,~Trial_Func_Valid)
    Form_Type = 'linear';
elseif and(~Test_Func_Valid,~Trial_Func_Valid)
    Form_Type = 'real';
end
fprintf(fid, ['    ', '// record the type of form', ENDL]);
fprintf(fid, ['    ', 'Form_Type = ', Form_Type, ';', ENDL]);
% get the number of sub-matrices
fprintf(fid, ['    ', '// record the number of sub-matrices (in local FE matrix)', ENDL]);
fprintf(fid, ['    ', 'Num_Sub_Matrices = ', num2str(Specific(1).MAT.Num_SubMAT), ';', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['    ', '// BEGIN: simple error check', ENDL]);
fprintf(fid, ['    ', 'if (', Row_Basis_Func_str, '->Num_Comp!=ROW_NC)', ENDL]);
fprintf(fid, ['        ', '{', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("ERROR: The number of components for the row FE space is NOT correct!\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("The FE matrix ''%%s'' expects %%d row components.\\n",SpecificFEM_str,ROW_NC);', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("Actual number of row components is %%d.\\n",', Row_Basis_Func_str, '->Num_Comp);', ENDL]);
fprintf(fid, ['        ', 'mexErrMsgTxt("Please report this error!\\n");', ENDL]);
fprintf(fid, ['        ', '}', ENDL]);
fprintf(fid, ['    ', 'if (', Col_Basis_Func_str, '->Num_Comp!=COL_NC)', ENDL]);
fprintf(fid, ['        ', '{', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("ERROR: The number of components for the column FE space is NOT correct!\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("The FE matrix ''%%s'' expects %%d col components.\\n",SpecificFEM_str,ROW_NC);', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("Actual number of col components is %%d.\\n",', Col_Basis_Func_str, '->Num_Comp);', ENDL]);
fprintf(fid, ['        ', 'mexErrMsgTxt("Please report this error!\\n");', ENDL]);
fprintf(fid, ['        ', '}', ENDL]);
fprintf(fid, ['    ', 'if (', Row_Basis_Func_str, '->Num_Basis!=ROW_NB)', ENDL]);
fprintf(fid, ['        ', '{', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("ERROR: The number of basis functions in the row FEM space is NOT correct!\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("The FEM matrix ''%%s'' expects %%d row basis functions.\\n",SpecificFEM_str,ROW_NB);', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("Actual number of row components is %%d.\\n",', Row_Basis_Func_str, '->Num_Basis);', ENDL]);
fprintf(fid, ['        ', 'mexErrMsgTxt("Please report this error!\\n");', ENDL]);
fprintf(fid, ['        ', '}', ENDL]);
fprintf(fid, ['    ', 'if (', Col_Basis_Func_str, '->Num_Basis!=COL_NB)', ENDL]);
fprintf(fid, ['        ', '{', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("ERROR: The number of basis functions in the column FEM space is NOT correct!\\n");', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("The FEM matrix ''%%s'' expects %%d col basis functions.\\n",SpecificFEM_str,COL_NB);', ENDL]);
fprintf(fid, ['        ', 'mexPrintf("Actual number of row components is %%d.\\n",', Col_Basis_Func_str, '->Num_Basis);', ENDL]);
fprintf(fid, ['        ', 'mexErrMsgTxt("Please report this error!\\n");', ENDL]);
fprintf(fid, ['        ', '}', ENDL]);
fprintf(fid, ['    ', '//   END: simple error check', ENDL]);
fprintf(fid, ['', ENDL]);

%%%%%%%
% record global matrix dimensions
fprintf(fid, ['    ', '// record the size of the global matrix', ENDL]);
fprintf(fid, ['    ', 'global_num_row = ', Row_Basis_Func_str, '->Num_Comp*', Row_Basis_Func_str, '->Num_Nodes;', ENDL]);
fprintf(fid, ['    ', 'global_num_col = ', Col_Basis_Func_str, '->Num_Comp*', Col_Basis_Func_str, '->Num_Nodes;', ENDL]);
fprintf(fid, ['', ENDL]);

% EXAMPLE:
%%%%%%%
%     /*------------ BEGIN: Auto Generate ------------*/
%     // input information for offsetting the sub-matrices
%     Row_Shift[0] = 0*row_basis_func->Num_Nodes;
%     Row_Shift[1] = 1*row_basis_func->Num_Nodes;
%     Row_Shift[2] = 2*row_basis_func->Num_Nodes;
%     Col_Shift[0] = 0*col_basis_func->Num_Nodes;
%     Col_Shift[1] = 1*col_basis_func->Num_Nodes;
%     Col_Shift[2] = 2*col_basis_func->Num_Nodes;
%     /*------------   END: Auto Generate ------------*/

% output text-lines
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// input information for offsetting the sub-matrices', ENDL]);
for index = 0:Row_Space_Num_Comp-1
    offset_str = num2str(index);
    Sub_Row_str = ['Row_Shift[', offset_str, '] = ', offset_str, '*', Row_Basis_Func_str, '->Num_Nodes;'];
    fprintf(fid, ['    ', Sub_Row_str, ENDL]);
end
for index = 0:Col_Space_Num_Comp-1
    offset_str = num2str(index);
    Sub_Row_str = ['Col_Shift[', offset_str, '] = ', offset_str, '*', Col_Basis_Func_str, '->Num_Nodes;'];
    fprintf(fid, ['    ', Sub_Row_str, ENDL]);
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
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
%fprintf(fid, ['', '', ENDL]);
fprintf(fid, ['', '}', ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', ENDL]);

% now generate the tabulate tensor routines
for ind = 1:length(Specific)
    status = obj.Write_Tabulate_Tensor_routine(fid,Specific(ind));
end

% EXAMPLE:
%%%%%%%
% close up the file
fprintf(fid, ['', '// remove those macros!', ENDL]);
fprintf(fid, ['', '#undef SpecificFEM', ENDL]);
fprintf(fid, ['', '#undef SpecificFEM_str', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['', '#undef ROW_NC', ENDL]);
fprintf(fid, ['', '#undef ROW_NB', ENDL]);
fprintf(fid, ['', '#undef COL_NC', ENDL]);
fprintf(fid, ['', '#undef COL_NB', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['/***/', ENDL]);
fprintf(fid, ['', ENDL]);

% DONE!
fclose(fid);

end