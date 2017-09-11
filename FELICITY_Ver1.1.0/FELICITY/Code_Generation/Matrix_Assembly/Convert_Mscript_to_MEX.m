function [status, Path_To_Mex] = Convert_Mscript_to_MEX(Main_Dir,Mscript,MEX_FileName)
%Convert_Mscript_to_MEX
%
%   Generic compile procedure for generating MEX files that assemble finite
%   element matrices via FELICITY's code generation.
%   NO changes are necessary here.
%
%   [status, Path_To_Mex] = Convert_Mscript_to_MEX(Main_Dir,Mscript,MEX_FileName);
%
%   Main_Dir     = (string) full path to the location of interest.
%   Mscript      = FELICITY script (m-file) that defines the matrices (forms) to
%                  assemble.
%   MEX_FileName = (string) name of MEX file.
%
%   status      = success == 0 or failure ~= 0.
%   Path_To_Mex = (string) full path to the MEX file.

% Copyright (c) 08-01-2011,  Shawn W. Walker

FI                = FELInterface(Main_Dir); % do NOT change
Snippet_SubDir    = 'Scratch_Dir'; % no change necessary
GenCode_SubDir    = 'Assembly_Code_AutoGen'; % no change necessary
MEX_Dir           = Main_Dir; % where the MEX-file goes

%%%%%%%% do NOT change %%%%%%%%
[status, Path_To_Mex] = FI.Compile_Matrix_Assembly(Mscript,Snippet_SubDir,GenCode_SubDir,MEX_Dir,MEX_FileName);

end