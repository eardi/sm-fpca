function Gen_FEM_Interpolation_Specific_cc(obj,FS,FI,INT_Name,GeomFunc,BasisFunc,CoefFunc)
%Gen_FEM_Interpolation_Specific_cc
%
%   This generates the file: "FEM_Interpolation_Specific.cc", except with a more
%   specific filename!

% Copyright (c) 01-30-2013,  Shawn W. Walker

% get specific interpolation information
Specific = FI.Interp(INT_Name);

ENDL = '\n';

% start with A part
File1 = [INT_Name, '.cc'];
WRITE_File = fullfile(obj.Output_Dir, obj.Sub_Dir.Interpolation_Classes, File1);
FEL_CopyFile(fullfile(obj.Skeleton_Dir, 'FEM_Interpolation_Specific_A.cc'),WRITE_File);

% open file for writing
fid = fopen(WRITE_File, 'a');

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // FEM interpolation is:
% //
% //    p_v1_t1_grad1, on Omega.
% //
% /*------------   END: Auto Generate ------------*/

% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['// FEM interpolation is:', ENDL]);
fprintf(fid, ['//', ENDL]);
    fprintf(fid, ['//    ', char(Specific.Expression), ', on ', Specific.Domain.Name, '.', ENDL]);
fprintf(fid, ['//', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // define the name of the FEM interpolation (should be the same as the filename of this file)
% #define SpecificFEM        I_p
% #define SpecificFEM_str   "I_p"
% 
% // set the number of rows of the expression
% #define ROW_NC  1
% // set the number of columns of the expression
% #define COL_NC  1
% /*------------   END: Auto Generate ------------*/

% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['// define the name of the FEM interpolation (should be the same as the filename of this file)', ENDL]);
fprintf(fid, ['#define SpecificFEM        ', INT_Name, ENDL]);
fprintf(fid, ['#define SpecificFEM_str   "', INT_Name, '"', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// set the number of rows of the expression', ENDL]);
fprintf(fid, ['#define ROW_NC  ', num2str(size(Specific.Expression,1)), ENDL]);
fprintf(fid, ['// set the number of columns of the expression', ENDL]);
fprintf(fid, ['#define COL_NC  ', num2str(size(Specific.Expression,2)), ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% append the next part
Fixed_File = fullfile(obj.Skeleton_Dir, 'FEM_Interpolation_Specific_B.cc');
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
% this will write the pre-declarations
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// constructor', ENDL]);
CONSTRUCTOR_STR = ['SpecificFEM (const unsigned int);'];
fprintf(fid, ['    ', CONSTRUCTOR_STR, ENDL]);
fprintf(fid, ['    ', '~SpecificFEM (); // destructor', ENDL]);
fprintf(fid, ['    ', 'void Init_Interpolation_Data_Arrays(const unsigned int);', ENDL]);
fprintf(fid, ['    ', 'void Eval_All_Interpolations (const unsigned int&);', ENDL]);
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', 'private:', ENDL]);

% EXAMPLE:
%%%%%%%
%     /*------------ BEGIN: Auto Generate ------------*/
%     void Eval_Interp_00(double&);
%     /*------------   END: Auto Generate ------------*/
% };
% output text-lines
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
for ir = 1:Specific.NumRow_SubINT
    for ic = 1:Specific.NumCol_SubINT
        INT = Specific.SubINT(ir,ic);
        fprintf(fid, ['    ', 'void Eval_Interp_',...
                              num2str(INT.Row_Shift), num2str(INT.Col_Shift), '(double&);', ENDL]);
    end
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
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
fprintf(fid, ['', 'SpecificFEM::SpecificFEM (const unsigned int Num_Interp_Points) :', ENDL]);
fprintf(fid, ['', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', 'FEM_Interpolation_Class () // call the base class constructor', ENDL]);
fprintf(fid, ['', '{', ENDL]);

% append the next part
Fixed_File = fullfile(obj.Skeleton_Dir, 'FEM_Interpolation_Specific_C.cc');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% append the next part
Fixed_File = fullfile(obj.Skeleton_Dir, 'FEM_Interpolation_Specific_D.cc');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% generate the call for evaluating all the (component-wise) FEM interpolations
status = obj.Eval_All_Interpolations(fid,Specific);

% now generate the individual (component-wise) interpolation evaluation routines
for ir = 1:Specific.NumRow_SubINT
    for ic = 1:Specific.NumCol_SubINT
        INT = Specific.SubINT(ir,ic);
        status = obj.Write_Eval_Interp_routine(fid,INT);
    end
end

% append the next part
Fixed_File = fullfile(obj.Skeleton_Dir, 'FEM_Interpolation_Specific_E.cc');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% DONE!
fclose(fid);

end