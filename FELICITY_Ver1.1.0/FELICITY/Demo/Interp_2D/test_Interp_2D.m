function status = test_Interp_2D()
%test_Interp_2D
%
%   Test code for FELICITY class.

% Copyright (c) 02-11-2013,  Shawn W. Walker

m_script = 'Interpolate_Grad_P_X_2D';
MEX_File = 'DEMO_mex_Interp_Grad_P_X_2D';

% get directory that this mfile lives in
Main_Dir = fileparts(mfilename('fullpath'));

[status, Path_To_Mex] = Convert_Interp_script_to_MEX(Main_Dir,m_script,MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = Execute_Interp_2D();
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% % remove the mex file
% delete([Path_To_Mex, '.*']);

end