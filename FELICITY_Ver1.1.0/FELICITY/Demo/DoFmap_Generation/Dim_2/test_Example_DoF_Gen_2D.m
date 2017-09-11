function status = test_Example_DoF_Gen_2D()
%test_Example_DoF_Gen_2D
%
%   Test code for FELICITY.

% Copyright (c) 04-21-2011,  Shawn W. Walker

% BEGIN: user specified code
MEX_FileName = 'mexDoF_Example_2D';

% define finite elements
Elem    = lagrange_deg1_dim2(); % P1 space
Elem(2) = lagrange_deg2_dim2(); % P2 space
% END: user specified code

%%%%%%%% do NOT change anything below this line %%%%%%%%

% get directory that this mfile lives in
Main_Dir = fileparts(mfilename('fullpath'));

% you can look in 'FEL_Compile_DoF_Allocate' to see the interface for generating
% and compiling code;  it is straightforward to understand.
[status, Path_To_Mex] = FEL_Compile_DoF_Allocate(Main_Dir,MEX_FileName,Elem);

% look in 'Execute_Example_DoF_Gen_2D' to see how you USE the code.
% here, a pre-made 2-D mesh is loaded and we allocate DoFs for both of the
% above listed finite elements.  Feel free to look at and modify this code to
% see how it works.
status = Execute_Example_DoF_Gen_2D(MEX_FileName);

end