function status = test_FEL_Flat_Beam_2D()
%test_FEL_Flat_Beam_2D
%
%   Test code for FELICITY class.

% Copyright (c) 03-30-2018,  Shawn W. Walker

% set degrees
deg_geo = 1; % >= 1
deg_k   = 0; % >= 0

m_handle = @MatAssem_Flat_Beam_2D;
MEX_File = 'UNIT_TEST_mex_Assemble_Flat_Beam_2D';

[status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_handle,{deg_geo,deg_k},MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% compile DoF allocators
Main_Dir = fileparts(mfilename('fullpath'));

MEX_File_DoF = 'UNIT_TEST_mex_Flat_Beam_2D_G_Space_DoF_Allocator';
P_k_geo = eval(['lagrange_deg', num2str(deg_geo), '_dim2();']);
[status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(P_k_geo,MEX_File_DoF,Main_Dir);
if status~=0
    disp('Compile did not succeed.');
    return;
end

MEX_File_DoF = 'UNIT_TEST_mex_Flat_Beam_2D_W_Space_DoF_Allocator';
P_k_plus_1 = eval(['lagrange_deg', num2str(deg_k+1), '_dim2();']);
[status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(P_k_plus_1,MEX_File_DoF,Main_Dir);
if status~=0
    disp('Compile did not succeed.');
    return;
end

MEX_File_DoF = 'UNIT_TEST_mex_Flat_Beam_2D_V_Space_DoF_Allocator';
HHJ_k = eval(['hellan_herrmann_johnson_deg', num2str(deg_k), '_dim2();']);
[status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(HHJ_k,MEX_File_DoF,Main_Dir);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% compile interpolation for HHJ
Interp_Handle = @FEL_Interp_Flat_Beam_2D;
MEX_File_Interp = 'UNIT_TEST_mex_FEL_Interp_Flat_Beam_2D';
[status, Path_To_Mex] = Convert_Interp_Definition_to_MEX(Interp_Handle,{deg_geo,deg_k},MEX_File_Interp);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% compile point search routine
Search_Handle = @FEL_Pt_Search_Flat_Beam_2D;
MEX_File = 'UNIT_TEST_mex_FEL_Pt_Search_Flat_Beam_2D';
[status, Path_To_Mex] = Convert_PtSearch_Definition_to_MEX(Search_Handle,{deg_geo},MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_Flat_Beam_2D(deg_geo,deg_k);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end