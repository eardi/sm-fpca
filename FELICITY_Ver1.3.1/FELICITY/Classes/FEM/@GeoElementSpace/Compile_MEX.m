function Path_To_Mex = Compile_MEX(obj)
%Compile_MEX
%
%   This compiles the mex file for the heavy lifting in interpolating.
%
%   Path_To_Mex = obj.Compile_MEX();
%
%   Path_To_Mex = string containing the full-path filename for mex file.

% Copyright (c) 04-09-2017,  Shawn W. Walker

% get mex filename
MEX_FileName = func2str(obj.mex_Interpolation);

FT           = FELtest(MEX_FileName);
Snippet_SubDir  = 'Scratch_Dir';
GenCode_SubDir = 'Interpolation_Code_AutoGen';
[status, Snippet_Dir] = FT.Recreate_SubDir(obj.mex_Dir,Snippet_SubDir);
if (status~=0)
    disp('Problem making sub-directory...'); return;
end
[status, GenCode_Dir] = FT.Recreate_SubDir(obj.mex_Dir,GenCode_SubDir);
if (status~=0)
    disp('Problem making sub-directory...'); return;
end

Gen_Library = Generic_L1toExecutable(Snippet_Dir,GenCode_Dir,obj.mex_Dir);

% generate code
Type_STR   = 'Interpolation';
L1toL3_FH  = @Interp_L1toL3;
GenCode_FH = @GenFELInterpolationCode;
Interp_Handle = @Interp_Defn_for_GeoElementSpace_INTERNAL;
Gen_Library.Convert_Mscript_to_CPP_Code(obj.mex_Dir,Interp_Handle,{obj},Type_STR,L1toL3_FH,GenCode_FH);

% compile machine code!
cppFileName = 'mexInterpolate_FEM.cpp'; % default .cpp name
[status, Path_To_Mex] = Gen_Library.Convert_CPP_Code_to_MEX_File(cppFileName,MEX_FileName,Type_STR);

end