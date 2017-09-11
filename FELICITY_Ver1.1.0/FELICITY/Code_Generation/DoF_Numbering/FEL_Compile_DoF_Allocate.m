function [status, Path_To_Mex] = FEL_Compile_DoF_Allocate(MEX_Dir,MEX_FileName,Elem)
%FEL_Compile_DoF_Allocate_1D
%
%   Generic compile procedure for generating MEX files that allocate DoFs for
%   given finite element spaces via FELICITY's code generation.
%   NO changes are necessary here.
%
%   [status, Path_To_Mex] = FEL_Compile_DoF_Allocate(MEX_Dir,MEX_FileName,Elem);
%
%   MEX_Dir      = (string) full path to the location of the MEX file.
%   MEX_FileName = (string) name of MEX file.
%   Elem         = array of element structs (as in the ./FELICITY/Elem_Defn
%                  directory) that represent the finite element spaces we want
%                  to allocate DoFs for.
%
%   status       = success == 0 or failure ~= 0.
%   Path_To_Mex  = (string) full path to the MEX file.

% Copyright (c) 01-01-2011,  Shawn W. Walker

FI               = FELInterface(MEX_Dir);
GenCode_SubDir   = 'AutoGen_DoFNumbering';

%%%%%%%%
[status, Path_To_Mex] = FI.Compile_DoF_Numbering(GenCode_SubDir,MEX_Dir,MEX_FileName,Elem);

end