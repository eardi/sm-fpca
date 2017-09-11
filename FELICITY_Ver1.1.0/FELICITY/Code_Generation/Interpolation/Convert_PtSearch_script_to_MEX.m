function [status, Path_To_Mex] = Convert_PtSearch_script_to_MEX(Main_Dir,Pscript,MEX_FileName)
%Convert_PtSearch_script_to_MEX
%
%   Generic compile procedure for generating MEX files that perform point searches of
%   meshes via FELICITY's code generation.
%   NO changes are necessary here.
%
%   [status, Path_To_Mex] = Convert_PtSearch_script_to_MEX(Main_Dir,Pscript,MEX_FileName);
%
%   Main_Dir     = (string) full path to the location of interest.
%   Pscript      = FELICITY script (m-file) that defines the point searching to perform.
%   MEX_FileName = (string) name of MEX file.
%
%   status      = success == 0 or failure ~= 0.
%   Path_To_Mex = (string) full path to the MEX file.

% Copyright (c) 06-13-2014,  Shawn W. Walker

FI                = FELInterface(Main_Dir); % do NOT change
GenCode_SubDir    = 'Pt_Search_Code_AutoGen'; % no change necessary
MEX_Dir           = Main_Dir; % where the MEX-file goes

%%%%%%%% do NOT change %%%%%%%%
[status, Path_To_Mex] = FI.Compile_Point_Search_Code(Pscript,GenCode_SubDir,MEX_Dir,MEX_FileName);

end