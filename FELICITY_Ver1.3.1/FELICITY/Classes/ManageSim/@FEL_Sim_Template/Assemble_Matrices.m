function my_matrices = Assemble_Matrices(obj,MISC)
%Assemble_Matrices
%
%   Assemble matrices on the mesh obj.Mesh.

% Copyright (c) 01-27-2017,  Shawn W. Walker

% call the auto-generated matrix assembly MEX file here...

% EXAMPLE: assemble (change this!)
FEM = mex_Assemble_INSERT([],obj.Mesh.X,uint32(obj.Mesh.Triangulation),[],...
                          [],obj.Space.V.DoFmap,MISC);
%

my_matrices = FEMatrixAccessor('INSERT_NAME',FEM);
%A = my_matrices.Get_Matrix('A');

end