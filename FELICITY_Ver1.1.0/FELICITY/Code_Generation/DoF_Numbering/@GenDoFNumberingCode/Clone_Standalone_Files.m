function Clone_Standalone_Files(obj)
%Clone_Standalone_Files
%
%   This just copies over the files that do NOT change.

% Copyright (c) 12-01-2010,  Shawn W. Walker

File1     = 'Misc_Files.h';
SK_FILE1  = fullfile(obj.Skeleton_Dir, File1);
OUT_FILE1 = fullfile(obj.Output_Dir, File1);
FEL_CopyFile(SK_FILE1,OUT_FILE1);

if and(obj.Elem(1).Dim==1,strcmp(obj.Elem(1).Domain,'interval'))
    File1     = 'Edge_Point_Search.cc';
    SK_FILE1  = fullfile(obj.Skeleton_Dir, File1);
    OUT_FILE1 = fullfile(obj.Output_Dir, File1);
    FEL_CopyFile(SK_FILE1,OUT_FILE1);
elseif and(obj.Elem(1).Dim==2,strcmp(obj.Elem(1).Domain,'triangle'))
    File1     = 'Triangle_Edge_Search.cc';
    SK_FILE1  = fullfile(obj.Skeleton_Dir, File1);
    OUT_FILE1 = fullfile(obj.Output_Dir, File1);
    FEL_CopyFile(SK_FILE1,OUT_FILE1);
elseif and(obj.Elem(1).Dim==3,strcmp(obj.Elem(1).Domain,'tetrahedron'))
    File1     = 'Tetrahedron_Data.cc';
    SK_FILE1  = fullfile(obj.Skeleton_Dir, File1);
    OUT_FILE1 = fullfile(obj.Output_Dir, File1);
    FEL_CopyFile(SK_FILE1,OUT_FILE1);
else
    err = FELerror;
    err = err.Add_Comment(['There is a problem in this Element Definition m-file:  ''', obj.Elem(1).Name, '''']);
    err = err.Add_Comment('The combination:');
    err = err.Add_Comment(['Element.Dim    = ', num2str(obj.Elem(1).Dim,'%d')]);
    err = err.Add_Comment(' and ');
    err = err.Add_Comment(['Element.Domain = ', obj.Elem(1).Domain]);
    err = err.Add_Comment('is not valid or has not been implemented!');
    err.Error;
    error('stop!');
end

end