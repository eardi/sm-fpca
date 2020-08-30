function Gen_FEM_Matrix_Specific_cc(obj,FS,FM,MAT_Name,GeomFunc,BasisFunc,CoefFunc)
%Gen_FEM_Matrix_Specific_cc
%
%   This generates the file: "FEM_Matrix_Specific.cc", except with a more
%   specific filename!

% Copyright (c) 06-10-2016,  Shawn W. Walker

error('do not use!!!');

% get everything we need for this matrix
Specific = FM.Get_Specific_Matrix_Data(FS,MAT_Name);

% parse out basis function and element info
% we just need some general info like the number of basis functions, which is
% the same over all integration domains
% Note: one can have multiple Specific(s) if there is more than one
% integration domain in defining the matrix!

if isempty(Specific(1).RowFunc)
    RowElem = Specific(1).MAT.row_func.Elem;
else
    RowElem = Specific(1).RowFunc.Elem;
end
if isempty(Specific(1).ColFunc)
    ColElem = Specific(1).MAT.col_func.Elem;
else
    ColElem = Specific(1).ColFunc.Elem;
end

% basic error checking
Sample_MAT = Specific(1).MAT;
FEM_Matrix_Specific_Consistency_Check(Sample_MAT,RowElem,ColElem);

ENDL = '\n';

% start with A part
File1 = [MAT_Name, '.cc'];
WRITE_File = fullfile(obj.Output_Dir, obj.Sub_Dir.Matrix_Classes, File1);
FEL_CopyFile(fullfile(obj.Skeleton_Dir, 'FEM_Matrix_Specific_A.cc'),WRITE_File);

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
fprintf(fid, ['// FEM matrix is:', ENDL]);
fprintf(fid, ['//', ENDL]);
for ind = 1:length(Integrand)
    fprintf(fid, ['// \\int_{', Integrand(ind).Domain.Integration_Domain.Name, '}  ',...
                   Integrand(ind).Str, ENDL]);
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
fprintf(fid, ['#define SpecificFEM        ', MAT_Name, ENDL]);
fprintf(fid, ['#define SpecificFEM_str   "', MAT_Name, '"', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// the row function space is Type = ',...
                  RowElem.Element_Type, ', Name = "', RowElem.Element_Name, '"' ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// set the number of vector components', ENDL]);
fprintf(fid, ['#define ROW_NC  ', num2str(RowElem.Num_Comp), ENDL]);
fprintf(fid, ['// set the number of basis functions on each element', ENDL]);
fprintf(fid, ['#define ROW_NB  ', num2str(RowElem.Num_Basis), ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// the col function space is Type = ',...
                  ColElem.Element_Type, ', Name = "', ColElem.Element_Name, '"' ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// set the number of vector components', ENDL]);
fprintf(fid, ['#define COL_NC  ', num2str(ColElem.Num_Comp), ENDL]);
fprintf(fid, ['// set the number of basis functions on each element', ENDL]);
fprintf(fid, ['#define COL_NB  ', num2str(ColElem.Num_Basis), ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% append the B part
Fixed_File = fullfile(obj.Skeleton_Dir, 'FEM_Matrix_Specific_B.cc');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

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
%     // pointers for accessing row and column FEM basis functions
%     const "FEM_BASIS_Class_Row"*     row_basis_func;
%     const "FEM_BASIS_Class_Col"*     col_basis_func;
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
    
    % tabulate tensor from scratch
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
CONSTRUCTOR_STR = ['SpecificFEM (const PTR_TO_SPARSE*, ', 'const ABSTRACT_FEM_Function_Class*, const ABSTRACT_FEM_Function_Class*);'];
fprintf(fid, ['    ', CONSTRUCTOR_STR, ENDL]);
fprintf(fid, ['    ', '~SpecificFEM (); // destructor', ENDL]);
fprintf(fid, ['    ', 'void Init_Matrix_Assembler_Object(bool);', ENDL]);
for ind = 1:length(Specific)
    ARG = ['(const ', Specific(ind).GeoFunc.CPP.Data_Type_Name, '&)'];
    fprintf(fid, ['    ', 'void Add_Entries_To_Global_Matrix ', ARG, ';', ENDL]);
end
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
% this will write the constructor call
fprintf(fid, ['', ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', '/* constructor */', ENDL]);
fprintf(fid, ['', obj.BEGIN_Auto_Gen, ENDL]);
ARG_1_str = ['const PTR_TO_SPARSE* Prev_Sparse_Data'];
fprintf(fid, ['', 'SpecificFEM::SpecificFEM (', ARG_1_str, ',', ENDL]);
fprintf(fid, ['', '                          const ', 'ABSTRACT_FEM_Function_Class', '* row_basis_func,', ENDL]);
fprintf(fid, ['', '                          const ', 'ABSTRACT_FEM_Function_Class', '* col_basis_func) :', ENDL]);
fprintf(fid, ['', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', 'FEM_MATRIX_Class () // call the base class constructor', ENDL]);
fprintf(fid, ['', '{', ENDL]);
fprintf(fid, ['    ', 'bool simple_assembler;', ENDL]);
fprintf(fid, ['    ', 'Sparse_Data = Prev_Sparse_Data;', ENDL]);

% EXAMPLE:
%%%%%%%
% output text-lines
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
ROW_CONST = strcmp(RowElem.Element_Type,'constant_one');
COL_CONST = strcmp(ColElem.Element_Type,'constant_one');
if or(ROW_CONST,COL_CONST)
    fprintf(fid, ['    ', 'simple_assembler = true; // better to use a full matrix', ENDL]);
else
    fprintf(fid, ['    ', 'simple_assembler = false; // use sparse matrix format', ENDL]);
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
%%%%%%%

% append the E part
Fixed_File = fullfile(obj.Skeleton_Dir, 'FEM_Matrix_Specific_E.cc');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% EXAMPLE:
%%%%%%%
%     /*------------ BEGIN: Auto Generate ------------*/
%     // input information for offsetting the sub-matrices
%     Shift_Row_Index[0] = 0*row_basis_func->Num_Nodes;
%     Shift_Row_Index[1] = 1*row_basis_func->Num_Nodes;
%     Shift_Row_Index[2] = 2*row_basis_func->Num_Nodes;
%     Shift_Col_Index[0] = 0*col_basis_func->Num_Nodes;
%     Shift_Col_Index[1] = 1*col_basis_func->Num_Nodes;
%     Shift_Col_Index[2] = 2*col_basis_func->Num_Nodes;
%     /*------------   END: Auto Generate ------------*/

% output text-lines
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// input information for offsetting the sub-matrices', ENDL]);
Row_Num_Comp = Sample_MAT.row_func.Elem.Num_Comp;
Col_Num_Comp = Sample_MAT.col_func.Elem.Num_Comp;
for index = 0:Row_Num_Comp-1
    offset_str = num2str(index);
    Sub_Row_str = ['Shift_Row_Index[', offset_str, '] = ', offset_str, '*row_basis_func->Num_Nodes;'];
    fprintf(fid, ['    ', Sub_Row_str, ENDL]);
end
for index = 0:Col_Num_Comp-1
    offset_str = num2str(index);
    Sub_Row_str = ['Shift_Col_Index[', offset_str, '] = ', offset_str, '*col_basis_func->Num_Nodes;'];
    fprintf(fid, ['    ', Sub_Row_str, ENDL]);
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% append the F part
Fixed_File = fullfile(obj.Skeleton_Dir, 'FEM_Matrix_Specific_F.cc');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% generate the call for assembling and adding the local FE matrix to the global
% FE matrix
for ind = 1:length(Specific)
    status = obj.Write_SUBRoutine_Add_Entries_To_Global_Matrix(fid,Specific(ind));
end

% now generate the tabulate tensor routines
for ind = 1:length(Specific)
    status = obj.Write_Tabulate_Tensor_routine(fid,Specific(ind));
end

% append the H part
Fixed_File = fullfile(obj.Skeleton_Dir, 'FEM_Matrix_Specific_H.cc');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% DONE!
fclose(fid);

end