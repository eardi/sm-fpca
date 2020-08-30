function status = test_FEL_Curved_Domain_2D()
%test_FEL_Curved_Domain_2D
%
%   Demo code for FELICITY.

% Copyright (c) 04-14-2017,  Shawn W. Walker

% compile matrix assembly
m_handle = @MatAssem_Curved_Domain_2D;
MEX_File = 'DEMO_mex_MatAssem_Curved_Domain_2D';

[status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_handle,{},MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% compile DoF allocators
Main_Dir = fileparts(mfilename('fullpath'));

MEX_File_DoF = 'DEMO_Curved_Domain_mex_V_Space_DoF_Allocator';
[status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(lagrange_deg2_dim2(),MEX_File_DoF,Main_Dir);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = Execute_Curved_Domain_2D();

% % remove the mex file
% delete([Path_To_Mex, '.*']);

end