function status = test_Laplace_1D()
%test_Laplace_1D
%
%   Test code for FELICITY.

% Copyright (c) 06-30-2012,  Shawn W. Walker

% BEGIN: user specified code
m_script = 'MatAssem_Laplace_1D'; % ***change to your filename***
MEX_File = 'DEMO_mex_Laplace_1D'; % desired name of the MEX-file (library)
%   END: user specified code

% get directory that this mfile lives in
Main_Dir = fileparts(mfilename('fullpath')); % change to your directory

%%%%%%%% do NOT change anything below this line %%%%%%%%

% you can look in 'Convert_FML_to_MEX' to see the interface for generating and
% compiling code;  it is straightforward to understand.
[status, Path_To_Mex] = Convert_Mscript_to_MEX(Main_Dir,m_script,MEX_File);

% look in 'Execute_Example_1D' to see how you USE the code.
% here, a simple 1-D mesh is created and 2 finite element matrices are
% created (mass and stiffness).  Feel free to look at and modify this code to
% see how it works.
status = Execute_Laplace_1D();

% % remove the mex file
% delete([Path_To_Mex, '.*']);

end