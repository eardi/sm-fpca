function status = test_FEL_RTk_surface()
%test_FEL_RTk_surface
%
%   Test code for FELICITY class.

% Copyright (c) 02-16-2018,  Shawn W. Walker

% set polynomial degree
deg_surf = 2;
deg_sig  = 1;
deg_p    = 1;

Main_Dir = fileparts(mfilename('fullpath'));

% remove the mex file for G_Space interpolation (to be sure)
delete(fullfile(Main_Dir, 'mex_RTk_Surface_G_Space_Interpolation.*'));

m_handle = @MatAssem_RTk_surface;
MEX_File = 'UNIT_TEST_mex_Assemble_FEL_RTk_surface';

[status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_handle,{deg_surf, deg_sig, deg_p},MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% compile DoF allocators
deg_surf_str = num2str(deg_surf);
P_Surf_Gamma = eval(['lagrange_deg', deg_surf_str, '_dim2();']);
[status, Path_To_Mex] = Create_DoF_Allocator(P_Surf_Gamma,'mex_RTk_Surf_G_Space_DoF_Alloc',Main_Dir);
if status~=0
    disp('Compile did not succeed.');
    return;
end

deg_p_str = num2str(deg_p);
P_Lag_Gamma = eval(['lagrange_deg', deg_p_str, '_dim2(''DG'');']);
[status, Path_To_Mex] = Create_DoF_Allocator(P_Lag_Gamma,'mex_RTk_Surf_Pk_DG_DoF_Alloc',Main_Dir);
if status~=0
    disp('Compile did not succeed.');
    return;
end

deg_sig_str = num2str(deg_sig);
Sigma_RT_Gamma = eval(['raviart_thomas_deg', deg_sig_str, '_dim2();']);
[status, Path_To_Mex] = Create_DoF_Allocator(Sigma_RT_Gamma,'mex_RTk_Surf_Sigma_DoF_Alloc',Main_Dir);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_RTk_surface(deg_surf, deg_sig, deg_p);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end