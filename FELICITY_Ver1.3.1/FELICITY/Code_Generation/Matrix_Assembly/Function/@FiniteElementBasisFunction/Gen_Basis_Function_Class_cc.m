function status = Gen_Basis_Function_Class_cc(obj,Output_Dir,Data_Type,Space_Num_Tensor_Comp)
%Gen_Basis_Function_Class_cc
%
%   This generates the file: "Gen_FEM_Basis_Function_Specific.cc", except with a
%   more specific filename!

% Copyright (c) 03-23-2018,  Shawn W. Walker

% start with A part
File1 = [Data_Type, '.cc'];
WRITE_File = fullfile(Output_Dir, File1);
obj.Copy_File('Basis_Function_Specific_A.cc',WRITE_File);

% open file for writing
fid = fopen(WRITE_File, 'a');

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // define the name of the FEM function (should be the same as the filename of this file)
% #define SpecificFUNC        FEM_Basis_Function_Specific
% #define SpecificFUNC_str   "FEM_Basis_Function_Specific"
% 
% // set the type of function space
% #define SPACE_type    "lagrange, degree = 1"
% // set the topological dimension
% #define TD  1
% // set the geometric dimension
% #define GD  3
% // set the number of vector components
% #define NC  1
% // set the number of quad points
% #define NQ  12
% // set the number of basis functions on each element
% #define NB  2
% /*------------   END: Auto Generate ------------*/

Num_Quad  = obj.GeomFunc.Domain.Num_Quad;

ENDL = '\n';
%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['// define the name of the FE basis function (should be the same as the filename of this file)', ENDL]);
fprintf(fid, ['#define SpecificFUNC        ', Data_Type, ENDL]);
fprintf(fid, ['#define SpecificFUNC_str   "', Data_Type, '"', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// set the type of function space', ENDL]);
TYPE_str = [obj.Elem.Element_Type, ' - ', obj.Elem.Element_Name];
fprintf(fid, ['#define SPACE_type  "', TYPE_str, '"', ENDL]);
fprintf(fid, ['// set the name of function space', ENDL]);
fprintf(fid, ['#define SPACE_name  "', obj.Space_Name, '"', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// set the Subdomain topological dimension', ENDL]);
fprintf(fid, ['#define SUB_TD  ', num2str(obj.GeomFunc.Domain.Subdomain.Top_Dim), ENDL]);
fprintf(fid, ['// set the Domain of Integration (DoI) topological dimension', ENDL]);
fprintf(fid, ['#define DOI_TD  ', num2str(obj.GeomFunc.Domain.Integration_Domain.Top_Dim), ENDL]);
fprintf(fid, ['// set the geometric dimension', ENDL]);
fprintf(fid, ['#define GD  ', num2str(obj.GeomFunc.Domain.Integration_Domain.GeoDim), ENDL]);
fprintf(fid, ['// set the number of cartesian tuple components (m*n) = ',...
              num2str(Space_Num_Tensor_Comp(1)), ' * ', num2str(Space_Num_Tensor_Comp(2)), ENDL]);
fprintf(fid, ['#define NC  ', num2str(prod(Space_Num_Tensor_Comp)), ENDL]);
fprintf(fid, ['// NOTE: the (i,j) tuple component is accessed by the linear index k = i + (j-1)*m', ENDL]);
fprintf(fid, ['// set the number of quad points', ENDL]);
fprintf(fid, ['#define NQ  ', num2str(Num_Quad), ENDL]);
fprintf(fid, ['// set the number of basis functions', ENDL]);
fprintf(fid, ['#define NB  ', num2str(obj.Elem.Num_Basis), ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
%%%%%%%

% create C++ code for evaluating various basis function quantities
[obj, Basis_Func_CODE] = obj.Gen_Basis_Func_Code_Snippets;
% you should not need to update the basis function object OUTSIDE this routine.

[status, Premap_CODE] = obj.Gen_Basis_Function_Class_Defn(fid,Basis_Func_CODE);
status = obj.Gen_Basis_Function_Class_Constructor(fid,Basis_Func_CODE);

% append the B part
status = obj.Append_File(fid,'Basis_Function_Specific_B.cc');

status = obj.Gen_Premap_Subroutine(fid,Premap_CODE);

status = obj.Gen_All_Local_Transformations(fid,Basis_Func_CODE,Premap_CODE);

% append the D part
status = obj.Append_File(fid,'Basis_Function_Specific_D.cc');

% DONE!
fclose(fid);

end