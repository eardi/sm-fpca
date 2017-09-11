function Delete_Plots(obj)
%Delete_Plots
%
%   Delete all of the files in the obj.Plot_Dir directory.
%
%   obj.Delete_Plots();

% Copyright (c) 05-05-2014,  Shawn W. Walker

File_Del = FELtest('Clear out old plots and movies');
File_Del.Delete_Files_In_Dir(obj.Plot_Dir);

end