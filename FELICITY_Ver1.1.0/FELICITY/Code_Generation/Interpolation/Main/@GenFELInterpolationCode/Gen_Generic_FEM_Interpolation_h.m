function Gen_Generic_FEM_Interpolation_h(obj,GeomFunc,FS,FI)
%Gen_Generic_FEM_Interpolation_h
%
%   This generates the file: "Generic_FEM_Interpolation.h".

% Copyright (c) 01-29-2013,  Shawn W. Walker

ENDL = '\n';

% start with A part
File1 = 'Generic_FEM_Interpolation.h';
WRITE_File = fullfile(obj.Output_Dir, File1);
FEL_CopyFile(fullfile(obj.Skeleton_Dir, 'Generic_FEM_Interpolation_A.h'),WRITE_File);

% open file for writing
fid = fopen(WRITE_File, 'a');

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% // set the number of FEM interpolations to evaluate
% #define NUM_FEM_INTERP    1
% 
% // In MATLAB, the output (INTERP) interpolation data should look like:
% //            INTERP.DATA
% //                  .Name
% //
% // Here, we define the strings that makes these variable names
% #define OUT_DATA_str     "DATA"
% #define OUT_NAME_str     "Name"
% /*------------   END: Auto Generate ------------*/

% get number of FEM interpolations
Interp_Names = FI.keys;
NUM_INTERP   = length(Interp_Names);
% get number of external functions
CoefFunc = FS.Get_Unique_Array_Of_CoefFuncs;
NUM_FUNC = length(CoefFunc);

%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['// set the number of FEM interpolations to evaluate', ENDL]);
fprintf(fid, ['#define NUM_FEM_INTERP    ', num2str(NUM_INTERP), ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['// In MATLAB, the output (INTERP) interpolation data should look like:', ENDL]);
fprintf(fid, ['//            INTERP.DATA', ENDL]);
fprintf(fid, ['//                  .Name', ENDL]);
fprintf(fid, ['//', ENDL]);
fprintf(fid, ['// Here, we define the strings that makes these variable names', ENDL]);
fprintf(fid, ['#define OUT_DATA_str    "DATA"', ENDL]);
fprintf(fid, ['#define OUT_NAME_str    "Name"', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
%%%%%%%

% append the B part
Fixed_File = fullfile(obj.Skeleton_Dir, 'Generic_FEM_Interpolation_B.h');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% EXAMPLE:
%%%%%%%
%     const "EXTERNAL_FEM_Class"* Get_Ext_Func_0_ptr() { return &(Ext_FEM_Func_0); }
%%%%%%%
if (NUM_FUNC > 0)
    fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
    fprintf(fid, ['    ', '// create access routines', ENDL]);
    for ind=1:NUM_FUNC
        % output text-lines
        FUNC_RETURN_str = [CoefFunc{ind}.CPP_Data_Type, '* Get_', CoefFunc{ind}.CPP_Var, '_ptr() const ',...
                           '{ return &(', CoefFunc{ind}.CPP_Var, '); }'];
        fprintf(fid, ['    ', 'const ', FUNC_RETURN_str, ENDL]);
    end
end
%%%%%%%

% EXAMPLE:
%%%%%%%
%     basic routines
%%%%%%%
fprintf(fid, ['', ENDL]);
fprintf(fid, ['    ', 'void Setup_Data (const mxArray*[]);', ENDL]);
fprintf(fid, ['    ', 'void Evaluate_Interpolations ();', ENDL]);
fprintf(fid, ['    ', 'void Output_Interpolations (mxArray*[]);', ENDL]);
fprintf(fid, ['    ', 'void Init_Output_Data (mxArray*[]);', ENDL]);
fprintf(fid, ['    ', 'void Output_Single_Interpolation (mwIndex, mxArray*, mxArray*, mxArray*);', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['', 'private:', ENDL]);
fprintf(fid, ['    ', '// these variables are defined from inputs coming from MATLAB', ENDL]);
fprintf(fid, ['', ENDL]);

% subdomain classes
fprintf(fid, ['    ', '// classes for (sub)domain(s) and topological entities', ENDL]);
Num_GeomFunc = length(GeomFunc);
for ind=1:Num_GeomFunc
    Domain_CPP = GeomFunc{ind}.Domain.Determine_CPP_Info;
    fprintf(fid, ['    ', Domain_CPP.Data_Type_Name, '    ', Domain_CPP.Identifier_Name, ';', ENDL]);
end
fprintf(fid, ['', ENDL]);

% interpolation point classes
fprintf(fid, ['    ', '// classes for accessing interpolation points on subdomains', ENDL]);
Interp_Domains = FI.Get_Distinct_Domains;
for di = 1:length(Interp_Domains)
    CPP_DOM = FI.Get_CPPdefine_Domain_Name(Interp_Domains{di}.Name);
    fprintf(fid, ['    ', 'Unstructured_Interpolation_Class', '    ', CPP_DOM.Interp_Data, ';', ENDL]);
end
fprintf(fid, ['', ENDL]);

% mesh geometry classes
fprintf(fid, ['    ', '// mesh geometry classes (can be higher order)', ENDL]);
for ind = 1:Num_GeomFunc
    DECLARE_str = [GeomFunc{ind}.CPP.Data_Type_Name, '   ', GeomFunc{ind}.CPP.Identifier_Name, ';'];
    fprintf(fid, ['    ', DECLARE_str, ENDL]);
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
% FEM interpolations
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// pointers to each specific FEM interpolation', ENDL]);
for mi = 1:NUM_INTERP
    CPP = FI.Get_Interpolation_CPP_Info(Interp_Names{mi});
    fprintf(fid, ['    ', CPP.Data_Type_Name, '*    ', CPP.Var_Name, ';', ENDL]);
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);

% EXAMPLE:
%%%%%%%
%     "Basis_Function_FEM_Class"     Basis_FEM_Func_0; // FEM Space basis function data structure
%%%%%%%
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// create variables for accessing and evaulating FEM (local) basis functions', ENDL]);
for int_index = 1:length(FS.Integration)
    BF_Set = FS.Integration(int_index).BasisFunc;
    BF_Names = BF_Set.keys;
    for index = 1:length(BF_Names)
        FUNC_DECLARE_str = [BF_Set(BF_Names{index}).CPP_Data_Type, '      ', BF_Set(BF_Names{index}).CPP_Var, ';'];
        fprintf(fid, ['    ', FUNC_DECLARE_str, ENDL]);
    end
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

% % EXAMPLE:
% %%%%%%%
% %     Data_Type_CONST_ONE_phi   "CONST_ONE_phi"; // dummy basis function
% %%%%%%%
% fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
% fprintf(fid, ['    ', '// create variables for accessing CONSTANT basis functions', ENDL]);
% Array_Const_Space = FI.Get_Unique_Array_of_Constant_Spaces;
% for ind = 1:length(Array_Const_Space)
%     % output text-lines
%     FUNC_DECLARE_str = ['Data_Type_CONST_ONE_phi', '      ', Array_Const_Space{ind}.CPP_Var, ';'];
%     fprintf(fid, ['    ', FUNC_DECLARE_str, ENDL]);
% end
% fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
% fprintf(fid, ['', ENDL]);
% %%%%%%%

% EXAMPLE:
%%%%%%%
%     "EXTERNAL_FEM_Class"     Ext_FEM_Func_0; // external FEM function data structure
%%%%%%%
fprintf(fid, ['    ', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['    ', '// create variables for accessing external functions', ENDL]);
% loop through all the specific coef function names
for int_index = 1:length(FS.Integration)
    CF_Set = FS.Integration(int_index).CoefFunc;
    CF_Names = CF_Set.keys;
    for index = 1:length(CF_Names)
        % output text-lines
        FUNC_DECLARE_str = [CF_Set(CF_Names{index}).CPP_Data_Type, '      ', CF_Set(CF_Names{index}).CPP_Var, ';'];
        fprintf(fid, ['    ', FUNC_DECLARE_str, ENDL]);
    end
end
fprintf(fid, ['    ', obj.END_Auto_Gen, ENDL]);
%%%%%%%

% append the D part
Fixed_File = fullfile(obj.Skeleton_Dir, 'Generic_FEM_Interpolation_C.h');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% DONE!
fclose(fid);

end