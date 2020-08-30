function status = test_FEL_Image_Proc()
%test_FEL_Image_Proc
%
%   Demo code for FELICITY.

% Copyright (c) 09-26-2011,  Shawn W. Walker

m_handle = @Image_Proc_Demo_assemble;
MEX_File = 'DEMO_mex_Image_Proc_assemble';

[status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_handle,{},MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = Run_Image_Processing_Demo();

% % remove the mex file
% delete([Path_To_Mex, '.*']);

end