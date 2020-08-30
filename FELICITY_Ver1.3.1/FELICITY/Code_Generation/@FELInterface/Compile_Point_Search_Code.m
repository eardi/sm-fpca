function [status, Path_To_Mex] = Compile_Point_Search_Code(obj,Search_Handle,Search_Args,MEX_FileName,MEX_Dir,GenCode_SubDir)
%Compile_Point_Search_Code
%
%   This will convert a FELICITY point search script (m-file) into a
%   stand-alone C++ point search code, and then compile it into a MEX file.
%
%   [status, Path_To_Mex] = obj.Compile_Point_Search_Code(...
%            Search_Handle,Search_Args,MEX_FileName,MEX_Dir,GenCode_SubDir);
%
%   inputs:
%   Search_Handle = direct function handle to the point search definition
%                   m-file that defines the type of mesh to search;
%                   this is *not* an anonymous function handle.
%                   e.g. are you searching a piecewise quadratic triangular mesh?
%   Search_Args   = cell array of input arguments to supply to 'Search_Handle'.
%   MEX_FileName = (string) desired name of the MEX file (without extension).
%   MEX_Dir = (string) full directory in which to hold the MEX file.
%   GenCode_SubDir = (string) name of sub-dir of obj.Main_Dir to store the
%                    generated c++ code that implements the mesh pt. search.
%
%   outputs:
%   status      = success == 0 or failure ~= 0.
%   Path_To_Mex = (string) full path to the MEX file.

% Copyright (c) 03-31-2017,  Shawn W. Walker

if or(isempty(MEX_FileName),~ischar(MEX_FileName))
    error('MEX_FileName must be a string!');
end
if or(isempty(MEX_Dir),~ischar(MEX_Dir))
    error('MEX_Dir must be a string!');
end
if or(isempty(GenCode_SubDir),~ischar(GenCode_SubDir))
    error('GenCode_SubDir must be a string!');
end

Path_To_Mex    = ''; % initialize

FT             = FELtest(func2str(Search_Handle));
% [status, Snippet_Dir] = FT.Recreate_SubDir(obj.Main_Dir,Snippet_SubDir);
% if (status~=0)
%     disp('Problem making sub-directory...'); return;
% end
Snippet_Dir = '';

[status, GenCode_Dir] = FT.Recreate_SubDir(obj.Main_Dir,GenCode_SubDir);
if (status~=0)
    disp('Problem making sub-directory...'); return;
end

Gen_Library = Generic_L1toExecutable(Snippet_Dir,GenCode_Dir,MEX_Dir);

% generate code
Type_STR   = 'Point Search';
L1toL3_FH  = @PtSearch_L1toL3;
GenCode_FH = @GenFELPtSearchCode;
Gen_Library.Convert_Mscript_to_CPP_Code(obj.Main_Dir,Search_Handle,Search_Args,Type_STR,L1toL3_FH,GenCode_FH);

% compile machine code!
cppFileName = 'mexPoint_Search.cpp'; % default .cpp name
[status, Path_To_Mex] = Gen_Library.Convert_CPP_Code_to_MEX_File(cppFileName,MEX_FileName,Type_STR);

end