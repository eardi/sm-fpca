function status = test_Heat_Eqn_On_A_Surface()
%test_Heat_Eqn_On_A_Surface
%
%   Demo code for FELICITY.

% Copyright (c) 02-02-2015,  Shawn W. Walker

m_script = 'MatAssem_Heat_Eqn_On_A_Surface';
MEX_File = 'DEMO_mex_Heat_Eqn_On_A_Surface';

% get directory that this mfile lives in
Main_Dir = fileparts(mfilename('fullpath'));

[status, Path_To_Mex] = Convert_Mscript_to_MEX(Main_Dir,m_script,MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = Execute_Heat_Eqn_On_A_Surface();

% % remove the mex file
% delete([Path_To_Mex, '.*']);

end