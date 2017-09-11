function status = code_gen_delete_temp_files()
%code_gen_delete_temp_files
%
%   Delete files.

% Copyright (c) 01-01-2011,  Shawn W. Walker

status = 0; % init
stat_dof_number = dof_numbering_delete_temp_files();
stat_mat_assem  = matrix_assembly_delete_temp_files();
stat_pt_search  = fel_pt_search_delete_temp_files();
stat_interp     = fel_interpolation_delete_temp_files();

stat = abs(stat_dof_number) + abs(stat_mat_assem) + abs(stat_pt_search) + abs(stat_interp);

if stat~=0
    disp('Delete directory failed!');
    status = -1;
    return;
end

end