addpath(genpath('FELICITY_Ver1.3.1'))


Main_Dir = fileparts(mfilename('fullpath'));

% compile matrix assembly
m_handle = @MatAssem_Laplace_Penalty_Surface;

[status, Path_To_Mex, Elems_DoF_Alloc] = Convert_Form_Definition_to_MEX(m_handle);
if status~=0
    disp('Compile did not succeed.');
    return;
end


% Older version Felicity
%mex -setup
%test_FELICITY
%Main_Dir = '.';
%[status, Path_To_Mex] = Convert_Mscript_to_MEX(Main_Dir,'MatAssem_Laplace_Penalty_Surface','Assem_Laplace_Penalty_Surface');

