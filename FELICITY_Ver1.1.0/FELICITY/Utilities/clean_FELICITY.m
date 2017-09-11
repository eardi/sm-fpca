function status = clean_FELICITY()
%clean_FELICITY
%
%   Delete temporary files created in FELICITY package.

% Copyright (c) 01-01-2011,  Shawn W. Walker

status = 0; % init

stat_mex      = static_code_delete_mex_files();
stat_code_gen = code_gen_delete_temp_files();
stat_demo     = demo_delete_temp_files();

final_status = stat_mex | stat_code_gen | stat_demo;

if final_status
    disp('Cleaning temporary files failed!');
    status = -1;
    return;
end

end