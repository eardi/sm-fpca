function [status, Path_To_Mex] = Compile_Matrix_Assembly(obj,Mscript,Snippet_SubDir,GenCode_SubDir,MEX_Dir,mexFileName)
%Compile_Matrix_Assembly
%
%   This will convert a FELICITY matrix assembly script (m-file) into a
%   stand-alone C++ matrix assembly code, and then compile it into a MEX file.
%
%   [status, Path_To_Mex] = obj.Compile_Matrix_Assembly(...
%            Mscript,Snippet_SubDir,GenCode_SubDir,MEX_Dir,mexFileName);
%
%   Mscript = FELICITY script (m-file) that defines the matrices (forms) to
%             assemble.
%   Snippet_SubDir = (string) sub-dir for storing temporary code snippets.
%   GenCode_SubDir = (string) sub-dir for storing the stand-alone C++ code.
%   MEX_Dir        = (string) full path to the location of the MEX file.
%   mexFileName    = (string) name of MEX file.
%
%   status      = success == 0 or failure ~= 0.
%   Path_To_Mex = (string) full path to the MEX file.

% Copyright (c) 06-12-2014,  Shawn W. Walker

Path_To_Mex    = '';
FT             = FELtest(Mscript);
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
Type_STR   = 'Matrix/Form Assembly';
L1toL3_FH  = @L1toL3;
GenCode_FH = @GenMatrixAssemblyCode;
Gen_Library.Convert_Mscript_to_CPP_Code(obj.Main_Dir,Mscript,Type_STR,L1toL3_FH,GenCode_FH);

% compile machine code!
cppFileName = 'mexAssemble_FEM.cpp'; % default .cpp name
[status, Path_To_Mex] = Gen_Library.Convert_CPP_Code_to_MEX_File(cppFileName,mexFileName,Type_STR);

end