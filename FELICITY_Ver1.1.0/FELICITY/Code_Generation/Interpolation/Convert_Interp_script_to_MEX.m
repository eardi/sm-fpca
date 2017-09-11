function [status, Path_To_Mex] = Convert_Interp_script_to_MEX(Main_Dir,Iscript,MEX_FileName)
%Convert_Interp_script_to_MEX
%
%   Generic compile procedure for generating MEX files that interpolate FE
%   functions via FELICITY's code generation.
%   NO changes are necessary here.
%
%   [status, Path_To_Mex] = Convert_Mscript_to_MEX(Main_Dir,Iscript,MEX_FileName);
%
%   Main_Dir     = (string) full path to the location of interest.
%   Iscript      = FELICITY script (m-file) that defines the FE interpolations
%                  to perform.
%   MEX_FileName = (string) name of MEX file.
%
%   status      = success == 0 or failure ~= 0.
%   Path_To_Mex = (string) full path to the MEX file.

% Copyright (c) 01-25-2013,  Shawn W. Walker

FI                = FELInterface(Main_Dir); % do NOT change
Snippet_SubDir    = 'Scratch_Dir'; % no change necessary
GenCode_SubDir    = 'Interpolation_Code_AutoGen'; % no change necessary
MEX_Dir           = Main_Dir; % where the MEX-file goes

%%%%%%%% do NOT change %%%%%%%%
[status, Path_To_Mex] = FI.Compile_Interpolation_Code(Iscript,Snippet_SubDir,GenCode_SubDir,MEX_Dir,MEX_FileName);

end