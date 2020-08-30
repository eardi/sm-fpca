function status = Gen_Coef_Function_Class_cc(obj,Output_Dir,BasisFunc,Space_Num_Tensor_Comp)
%Gen_Coef_Function_Class_cc
%
%   This generates the file: "Gen_FEM_Basis_Function_Specific.cc", except with a
%   more specific filename!

% Copyright (c) 03-23-2018,  Shawn W. Walker

% start with A part
Data_Type = obj.CPP_Data_Type;
File1 = [Data_Type, '.cc'];
WRITE_File = fullfile(Output_Dir, File1);
obj.Copy_File('FEM_Function_Specific_A.cc',WRITE_File);

% open file for writing
fid = fopen(WRITE_File, 'a');

% parse out Element info
Elem = BasisFunc.Elem;

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // define the name of the FEM function (should be the same as the filename of this file)
% #define SpecificNAME       "old_soln"
% #define SpecificFUNC        FEM_Function_Specific
% #define SpecificFUNC_str   "FEM_Function_Specific"
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

Num_Quad  = BasisFunc.GeomFunc.Domain.Num_Quad;

%%%%%%%
ENDL = '\n';
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['// define the name of the FEM function (should be the same as the filename of this file)', ENDL]);
fprintf(fid, ['#define SpecificNAME       "', obj.Func_Name, '"', ENDL]);
fprintf(fid, ['#define SpecificFUNC        ', Data_Type, ENDL]);
fprintf(fid, ['#define SpecificFUNC_str   "', Data_Type, '"', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// set the type of function space', ENDL]);
TYPE_str = [Elem.Element_Type, ' - ', Elem.Element_Name];
fprintf(fid, ['#define SPACE_type  "', TYPE_str, '"', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// set the number of cartesian tuple components (m*n) = ',...
              num2str(Space_Num_Tensor_Comp(1)), ' * ', num2str(Space_Num_Tensor_Comp(2)), ENDL]);
fprintf(fid, ['#define NC  ', num2str(prod(Space_Num_Tensor_Comp)), ENDL]);
fprintf(fid, ['// NOTE: the (i,j) tuple component is accessed by the linear index k = i + (j-1)*m', ENDL]);
fprintf(fid, ['// set the number of quad points', ENDL]);
fprintf(fid, ['#define NQ  ', num2str(Num_Quad), ENDL]);
fprintf(fid, ['// set the number of basis functions', ENDL]);
fprintf(fid, ['#define NB  ', num2str(Elem.Num_Basis), ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% create C++ code for evaluating various coef function quantities
[obj, Coef_Func_CODE] = obj.Gen_Coef_Func_Code_Snippets;
% you should not need to update the coef function object OUTSIDE this routine.

status = obj.Gen_Coef_Function_Class_Defn(fid,BasisFunc,Coef_Func_CODE);
status = obj.Gen_Coef_Function_Class_Constructor(fid,Coef_Func_CODE);

% append the B1 part
status = obj.Append_File(fid,'FEM_Function_Specific_B1.cc');

status = obj.Gen_Coef_Function_Setup_Function_Space_HDR(fid,BasisFunc);

% append the B2 part
status = obj.Append_File(fid,'FEM_Function_Specific_B2.cc');

% now insert the external coefficient function computation code
status = obj.Gen_All_Local_Transformations(fid,Coef_Func_CODE);

% append the C part
status = obj.Append_File(fid,'FEM_Function_Specific_C.cc');

% DONE!
fclose(fid);

end