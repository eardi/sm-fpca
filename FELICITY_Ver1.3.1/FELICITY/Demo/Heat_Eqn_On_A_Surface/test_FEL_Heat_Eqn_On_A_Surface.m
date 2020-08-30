function status = test_FEL_Heat_Eqn_On_A_Surface()
%test_FEL_Heat_Eqn_On_A_Surface
%
%   Demo code for FELICITY.

% Copyright (c) 02-02-2015,  Shawn W. Walker

m_handle = @MatAssem_Heat_Eqn_On_A_Surface;
MEX_File = 'DEMO_mex_Heat_Eqn_On_A_Surface';

[status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_handle,{},MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = Execute_Heat_Eqn_On_A_Surface();

% % remove the mex file
% delete([Path_To_Mex, '.*']);

end