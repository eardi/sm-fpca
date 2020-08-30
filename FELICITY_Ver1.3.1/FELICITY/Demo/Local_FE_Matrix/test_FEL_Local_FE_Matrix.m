function status = test_FEL_Local_FE_Matrix()
%test_FEL_Local_FE_Matrix
%
%   Demo code for FELICITY.

% Copyright (c) 08-10-2017,  Shawn W. Walker

% abstract bilinear form file
m_func = @MatAssem_Local_FE_Matrix;

Domain_Types = {'interval', 'triangle', 'tetrahedron'};
for ii = 1:3
    [status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_func,Domain_Types(ii),...
                                  ['DEMO_mex_MatAssem_Local_FE_Matrix_', Domain_Types{ii}],[],...
                                   'Scratch_Dir',['MatAssem_Local_FE_Matrix_CodeGen_', Domain_Types{ii}]);
    if status~=0
        disp('Compile did not succeed.');
        return;
    end
end

% execute elementary code
status = Execute_Local_FE_Matrix();

% % remove the mex file
% delete([Path_To_Mex, '.*']);

end