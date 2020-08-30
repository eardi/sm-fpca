function status = test_FEL_EWOD_FalkWalker()
%test_FEL_EWOD_FalkWalker
%
%   Demo code for FELICITY.

% Copyright (c) 11-07-2017,  Shawn W. Walker

Main_Dir = fileparts(mfilename('fullpath'));

% compile matrix assembly
m_handle = @MatAssem_EWOD_FalkWalker;

[status, Path_To_Mex, Elems_DoF_Alloc] = Convert_Form_Definition_to_MEX(m_handle);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% compile DoF allocators
[status, Path_To_Mex] = Create_DoF_Allocator(Elems_DoF_Alloc,'mex_EWOD_DoF_Alloc',Main_Dir);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = Execute_EWOD_FalkWalker();

% % remove the mex file
% delete([Path_To_Mex, '.*']);

end