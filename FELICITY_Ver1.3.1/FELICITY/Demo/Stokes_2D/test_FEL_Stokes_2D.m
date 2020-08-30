function status = test_FEL_Stokes_2D()
%test_FEL_Stokes_2D
%
%   Demo code for FELICITY.

% Copyright (c) 06-30-2012,  Shawn W. Walker

m_handle = @MatAssem_Stokes_2D;
MEX_File = 'DEMO_mex_Stokes_2D_assemble';

[status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_handle,{},MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% compile DoF allocation
Elem = lagrange_deg2_dim2();
MEX_File_DoF = 'DEMO_mex_DoF_Lagrange_P2_Allocator_2D';
Main_Dir = fileparts(mfilename('fullpath'));
[status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(Elem,MEX_File_DoF,Main_Dir);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = Execute_Stokes_2D();

% % remove the mex file
% delete([Path_To_Mex, '.*']);

end