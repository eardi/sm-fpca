function [status, Path_To_Mex] = Compile_DoF_Numbering(obj,GenCode_SubDir,MEX_Dir,mexFileName,Elem)
%Compile_DoF_Numbering
%
%   This will generate a stand-alone C++ DoF allocation code, and then compile
%   it into a MEX file.
%
%   [status, Path_To_Mex] =
%            obj.Compile_DoF_Numbering(GenCode_SubDir,MEX_Dir,mexFileName,Elem);
%
%   GenCode_SubDir = (string) sub-dir for storing the stand-alone C++ code.
%   MEX_Dir        = (string) full path to the location of the MEX file.
%   mexFileName    = (string) name of MEX file.
%   Elem           = array of element structs (as in the ./FELICITY/Elem_Defn
%                    directory) that represent the finite element spaces we want
%                    to allocate DoFs for.
%
%   status         = success == 0 or failure ~= 0.
%   Path_To_Mex    = (string) full path to the MEX file.

% Copyright (c) 01-01-2011,  Shawn W. Walker

Path_To_Mex    = '';
FT             = FELtest(GenCode_SubDir);
[status, GenCode_Dir] = FT.Recreate_SubDir(obj.Main_Dir,GenCode_SubDir);
if (status~=0)
    disp('Problem making sub-directory...'); return;
end

GenDoFCode = GenDoFNumberingCode(GenCode_Dir,Elem);
CODE_SUCCESS = GenDoFCode.Generate_CPP_Code;
if ~CODE_SUCCESS
    disp('There was a problem generating the DoF numbering code...');
    status = -1; return;
end

% see if it compiles
[status, Path_To_Mex] = GenDoFCode.Compile_CPP_Code(MEX_Dir,mexFileName);

end