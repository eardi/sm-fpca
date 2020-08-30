function status = test_FEL_Interp_2D()
%test_FEL_Interp_2D
%
%   Test code for FELICITY class.

% Copyright (c) 02-11-2013,  Shawn W. Walker

Interp_Handle = @Interpolate_Grad_P_X_2D;
MEX_File_Interp = 'DEMO_mex_Interp_Grad_P_X_2D';

[status, Path_To_Mex] = Convert_Interp_Definition_to_MEX(Interp_Handle,{},MEX_File_Interp);
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