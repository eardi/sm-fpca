function status = dof_numbering_delete_temp_files()
%dof_numbering_delete_temp_files
%
%   Delete files.

% Copyright (c) 01-01-2011,  Shawn W. Walker

DDir = FELtest('deleting dirs');
status = 0; % init

% get the main directory that this class is in!
MFN = mfilename('fullpath');
Main_Dir = fileparts(MFN);

% list dirs to delete
Dirs_to_Delete(1).str = fullfile(Main_Dir, 'Unit_Test', 'Dim_1', 'AutoGen_DoFNumbering');
Dirs_to_Delete(2).str = fullfile(Main_Dir, 'Unit_Test', 'Dim_2', 'AutoGen_DoFNumbering');
Dirs_to_Delete(3).str = fullfile(Main_Dir, 'Unit_Test', 'Dim_3', 'AutoGen_DoFNumbering');

% delete them!
for ind = 1:length(Dirs_to_Delete)
    stat1 = DDir.Remove_Dir(Dirs_to_Delete(ind).str);
    if (stat1~=0)
        disp('Delete directory failed!');
        status = -1;
        return;
    end
end

% % delete some remaining files
% Files_to_Delete(1).str = fullfile(Main_Dir, 'Samples', 'mexDoF_Example_2D');
% 
% % delete them!
% for ind = 1:length(Files_to_Delete)
%     stat1 = DDir.Delete_File_All_Ext(Files_to_Delete(ind).str);
%     if (stat1~=0)
%         disp('Delete File failed!');
%         status = -1;
%         return;
%     end
% end

end