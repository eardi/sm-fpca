function status = test_FEL_Example_DoF_Gen_2D()
%test_FEL_Example_DoF_Gen_2D
%
%   Test code for FELICITY.

% Copyright (c) 04-21-2011,  Shawn W. Walker

% BEGIN: user specified code

% define finite elements
Elem    = lagrange_deg1_dim2(); % P1 space
Elem(2) = lagrange_deg2_dim2(); % P2 space

MEX_FileName = 'mexDoF_Example_2D';

% END: user specified code

%%%%%%%% do NOT change anything below this line %%%%%%%%

% get directory that this mfile lives in
Main_Dir = fileparts(mfilename('fullpath'));

% you can look in 'Create_DoF_Allocator' to see the interface for generating
% and compiling code;  it is straightforward to understand.
[status, Path_To_Mex] = Create_DoF_Allocator(Elem,MEX_FileName,Main_Dir);

% look in 'Execute_Example_DoF_Gen_2D' to see how you USE the code.
% here, a pre-made 2-D mesh is loaded and we allocate DoFs for both of the
% above listed finite elements.  Feel free to look at and modify this code to
% see how it works.
status = Execute_Example_DoF_Gen_2D(MEX_FileName);

end