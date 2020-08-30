function status = Clear_MEX(obj)
%Clear_MEX
%
%   This deletes the mex file created by "Compile_MEX".
%
%   status = obj.Clear_MEX();

% Copyright (c) 04-06-2018,  Shawn W. Walker

% get mex filename
MEX_FileName = func2str(obj.mex_Search_Func);

% remove the mex file
ME = mexext;
DEL_Path_To_Mex = fullfile(obj.mex_Dir, [MEX_FileName, '.', ME]);
delete(DEL_Path_To_Mex);

% delete the generated code
DDir = FELtest('delete PtSearch_AutoGen');
GenCode_SubDir = 'PtSearch_AutoGen';

status = DDir.Remove_Dir(fullfile(obj.mex_Dir, GenCode_SubDir));

end