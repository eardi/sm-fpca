function FN = Make_FileName_Static(obj)
%Make_FileName_Static
%
%   Make a valid filename for the static data.
%
%   FN = obj.Make_FileName_Static;

% Copyright (c) 09-17-2014,  Shawn W. Walker

Subdir = obj.Main_Dir;
Prefix = obj.File_Prefix;

FN = fullfile(Subdir, [Prefix, '_static', '.mat']);

end