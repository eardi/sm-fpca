function status = test_FEL_Mesh_Gen_With_Solving_PDE()
%test_FEL_Mesh_Gen_With_Solving_PDE
%
%   Demo code for FELICITY.

% Copyright (c) 04-24-2013,  Shawn W. Walker

m_handle = @MatAssem_Mesh_Gen_With_Solving_PDE;
MEX_File = 'DEMO_mex_Mesh_Gen_With_Solving_PDE_assemble';

[status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_handle,{},MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

S = warning('QUERY', 'MATLAB:TriRep:PtsNotInTriWarnId');
OLD_STATE = S.state;
% turn off this warning for the demo
warning('off', 'MATLAB:TriRep:PtsNotInTriWarnId');

status = Execute_Mesh_Gen_With_Solving_PDE();

% put the warning back in its original state
warning(OLD_STATE, 'MATLAB:TriRep:PtsNotInTriWarnId');

% % remove the mex file
% delete([Path_To_Mex, '.*']);

end