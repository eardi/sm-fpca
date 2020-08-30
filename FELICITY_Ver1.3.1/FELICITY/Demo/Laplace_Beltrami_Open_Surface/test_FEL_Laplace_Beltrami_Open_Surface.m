function status = test_FEL_Laplace_Beltrami_Open_Surface()
%test_FEL_Laplace_Beltrami_Open_Surface
%
%   Demo code for FELICITY.

% Copyright (c) 11-07-2017,  Shawn W. Walker

Main_Dir = fileparts(mfilename('fullpath'));

% compile matrix assembly
m_handle = @MatAssem_LapBel_Open_Surface;

[status, Path_To_Mex, Elems_DoF_Alloc] = Convert_Form_Definition_to_MEX(m_handle);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% compile error computation
m_handle = @Compute_Errors_LapBel_Open_Surface;

[status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_handle);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% compile DoF allocators
[status, Path_To_Mex] = Create_DoF_Allocator(Elems_DoF_Alloc,'mex_LapBel_DoF_Alloc',Main_Dir);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% run the code
status = Execute_LapBel_Open_Surface();

% % remove the mex file
% delete([Path_To_Mex, '.*']);

end