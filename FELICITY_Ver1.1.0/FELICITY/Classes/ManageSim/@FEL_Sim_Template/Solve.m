function Soln_Struct = Solve(obj, MAT, RHS, MISC)
%Solve
%
%   Solve the system.

% Copyright (c) 05-05-2014,  Shawn W. Walker

% EXAMPLE: (change this!)

NV = obj.Space.V.max_dof();

disp('Get Fixed and Free DoFs:');
%Fixed_V_DoFs     = obj.Space.V.Get_Fixed_DoFs(obj.Mesh,'all');
Free_V_DoFs      = obj.Space.V.Get_Free_DoFs(obj.Mesh,'all');

disp('Use backslash to solve:');
big_soln = zeros(NV,1);
big_soln(Free_V_DoFs,1) = MAT(Free_V_DoFs,Free_V_DoFs) \ RHS(Free_V_DoFs,1);

Soln_Struct.y    = zeros(NV,1);
Soln_Struct.y(:) = big_soln(1:NV,1);

end