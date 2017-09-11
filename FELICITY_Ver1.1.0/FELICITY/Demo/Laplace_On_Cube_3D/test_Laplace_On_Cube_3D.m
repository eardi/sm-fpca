function status = test_Laplace_On_Cube_3D()
%test_Laplace_On_Cube_3D
%
%   Demo code for FELICITY.

% Copyright (c) 06-30-2012,  Shawn W. Walker

m_script = 'MatAssem_Laplace_On_Cube_3D';
MEX_File = 'DEMO_mex_Laplace_On_Cube_3D_assemble';

% get directory that this mfile lives in
Main_Dir = fileparts(mfilename('fullpath'));

[status, Path_To_Mex] = Convert_Mscript_to_MEX(Main_Dir,m_script,MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = Execute_Laplace_On_Cube_3D();

% % remove the mex file
% delete([Path_To_Mex, '.*']);

end