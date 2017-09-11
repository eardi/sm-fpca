function status = test_Image_Proc()
%test_Image_Proc
%
%   Demo code for FELICITY.

% Copyright (c) 09-26-2011,  Shawn W. Walker

m_script = 'Image_Proc_Demo_assemble';
MEX_File = 'DEMO_mex_Image_Proc_assemble';

% get directory that this mfile lives in
Main_Dir = fileparts(mfilename('fullpath'));

[status, Path_To_Mex] = Convert_Mscript_to_MEX(Main_Dir,m_script,MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = Run_Image_Processing_Demo();

% % remove the mex file
% delete([Path_To_Mex, '.*']);

end