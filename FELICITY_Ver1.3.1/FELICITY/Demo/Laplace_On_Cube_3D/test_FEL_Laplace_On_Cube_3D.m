function status = test_FEL_Laplace_On_Cube_3D()
%test_FEL_Laplace_On_Cube_3D
%
%   Demo code for FELICITY.

% Copyright (c) 06-30-2012,  Shawn W. Walker

m_handle = @MatAssem_Laplace_On_Cube_3D;
MEX_File = 'DEMO_mex_Laplace_On_Cube_3D_assemble';

[status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_handle,{},MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = Execute_Laplace_On_Cube_3D();

% % remove the mex file
% delete([Path_To_Mex, '.*']);

end