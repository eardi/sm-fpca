function [status, Path_To_Mex, Elems_DoF_Alloc] =...
                  Compile_Matrix_Assembly(obj,Form_Handle,Form_Args,MEX_FileName,MEX_Dir,Snippet_SubDir,GenCode_SubDir)
%Compile_Matrix_Assembly
%
%   This will convert a FELICITY abstract form definition m-file into a
%   stand-alone C++ matrix assembly code, and then compile it into a MEX file.
%
%   [status, Path_To_Mex, Elems_DoF_Alloc] = obj.Compile_Matrix_Assembly(...
%            Form_Handle,Form_Args,MEX_FileName,MEX_Dir,Snippet_SubDir,GenCode_SubDir);
%
%   inputs:
%   Form_Handle  = direct function handle to the form definition m-file that
%                  defines the forms (matrices) to assemble; this is *not*
%                  an anonymous function handle.
%   Form_Args    = cell array of input arguments to supply to 'Form_Handle'.
%   MEX_FileName = (string) desired name of the MEX file (without extension).
%   MEX_Dir = (string) full directory in which to hold the MEX file.
%   Snippet_SubDir = (string) name of sub-dir of obj.Main_Dir to store
%                    temporary snippets of c-code.
%   GenCode_SubDir = (string) name of sub-dir of obj.Main_Dir to store the
%                    generated c++ code that implements the matrix assembly.
%
%   outputs:
%   status      = success == 0 or failure ~= 0.
%   Path_To_Mex = (string) full path to the MEX file.
%   Elems_DoF_Alloc = collection of finite element definition structs used
%                     for autogenerating mex files for DoF allocation.
%                     Note: this is used by the routine: "Create_DoF_Allocator".

% Copyright (c) 11-06-2017,  Shawn W. Walker

if or(isempty(MEX_FileName),~ischar(MEX_FileName))
    error('MEX_FileName must be a string!');
end
if or(isempty(MEX_Dir),~ischar(MEX_Dir))
    error('MEX_Dir must be a string!');
end
if or(isempty(Snippet_SubDir),~ischar(Snippet_SubDir))
    error('Snippet_SubDir must be a string!');
end
if or(isempty(GenCode_SubDir),~ischar(GenCode_SubDir))
    error('GenCode_SubDir must be a string!');
end

Path_To_Mex    = ''; % initialize

FT             = FELtest(func2str(Form_Handle));
[status, Snippet_Dir] = FT.Recreate_SubDir(obj.Main_Dir,Snippet_SubDir);
if (status~=0)
    disp('Problem making sub-directory...'); return;
end
[status, GenCode_Dir] = FT.Recreate_SubDir(obj.Main_Dir,GenCode_SubDir);
if (status~=0)
    disp('Problem making sub-directory...'); return;
end

Gen_Library = Generic_L1toExecutable(Snippet_Dir,GenCode_Dir,MEX_Dir);

% generate code
Type_STR   = 'Form (Matrix) Assembly';
L1toL3_FH  = @L1toL3;
GenCode_FH = @GenMatrixAssemblyCode;
[~, Elems_DoF_Alloc] = Gen_Library.Convert_Mscript_to_CPP_Code(obj.Main_Dir,Form_Handle,Form_Args,Type_STR,L1toL3_FH,GenCode_FH);

% compile machine code!
cppFileName = 'mexAssemble_FEM.cpp'; % default .cpp name
[status, Path_To_Mex] = Gen_Library.Convert_CPP_Code_to_MEX_File(cppFileName,MEX_FileName,Type_STR);

end