function status = test_Stokes_2D()
%test_Stokes_2D
%
%   Demo code for FELICITY.

% Copyright (c) 06-30-2012,  Shawn W. Walker

m_script = 'MatAssem_Stokes_2D';
MEX_File = 'DEMO_mex_Stokes_2D_assemble';

% get directory that this mfile lives in
Main_Dir = fileparts(mfilename('fullpath'));

[status, Path_To_Mex] = Convert_Mscript_to_MEX(Main_Dir,m_script,MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% compile DoF allocation
MEX_File_DoF = 'DEMO_mex_DoF_Lagrange_P2_Allocator_2D';
Elem    = lagrange_deg2_dim2();
[status, Path_To_Mex_DoF_alloc] = FEL_Compile_DoF_Allocate(Main_Dir,MEX_File_DoF,Elem);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = Execute_Stokes_2D();

% % remove the mex file
% delete([Path_To_Mex, '.*']);

end