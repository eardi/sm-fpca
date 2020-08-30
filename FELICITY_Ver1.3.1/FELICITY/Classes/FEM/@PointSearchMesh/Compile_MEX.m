function Path_To_Mex = Compile_MEX(obj)
%Compile_MEX
%
%   This compiles the mex file for the heavy lifting in searching the mesh.
%
%   Path_To_Mex = obj.Compile_MEX();
%
%   Path_To_Mex = string containing the full-path filename for mex file.

% Copyright (c) 04-02-2017,  Shawn W. Walker

% get mex filename
MEX_FileName = func2str(obj.mex_Search_Func);

FT           = FELtest(MEX_FileName);
% [status, Snippet_Dir] = FT.Recreate_SubDir(obj.Main_Dir,Snippet_SubDir);
% if (status~=0)
%     disp('Problem making sub-directory...'); return;
% end
Snippet_Dir = '';
GenCode_SubDir = 'PtSearch_AutoGen';

% only compile if the file does not exist
if ~exist(MEX_FileName,'file')
    
    [status, GenCode_Dir] = FT.Recreate_SubDir(obj.mex_Dir,GenCode_SubDir);
    if (status~=0)
        disp('Problem making sub-directory...'); return;
    end
    
    Gen_Library = Generic_L1toExecutable(Snippet_Dir,GenCode_Dir,obj.mex_Dir);
    
    % generate code
    Type_STR   = 'Point Search';
    L1toL3_FH  = @PtSearch_L1toL3;
    GenCode_FH = @GenFELPtSearchCode;
    Gen_Library.Convert_Mscript_to_CPP_Code(obj.mex_Dir,obj.Search_Handle,obj.Search_Args,Type_STR,L1toL3_FH,GenCode_FH);
    
    % compile machine code!
    cppFileName = 'mexPoint_Search.cpp'; % default .cpp name
    [status, Path_To_Mex] = Gen_Library.Convert_CPP_Code_to_MEX_File(cppFileName,MEX_FileName,Type_STR);
else
    Path_To_Mex = obj.mex_Dir;
end

end