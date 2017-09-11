function status = test_FEL_Multiple_Subdomain_Embed_Dim_1()
%test_FEL_Multiple_Subdomain_Embed_Dim_1
%
%   Test code for FELICITY class.

% Copyright (c) 06-26-2012,  Shawn W. Walker

m_script = 'Multiple_Subdomain_Embed_Dim_1';
MEX_File = 'UNIT_TEST_mex_Multiple_Subdomain_Embed_Dim_1';

% get directory that this mfile lives in
Main_Dir = fileparts(mfilename('fullpath'));

[status, Path_To_Mex] = Convert_Mscript_to_MEX(Main_Dir,m_script,MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_Multiple_Subdomain_Embed_Dim_1(MEX_File);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end