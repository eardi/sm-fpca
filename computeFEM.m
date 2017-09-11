function [R0,R1] = computeFEM(manifold)

% Mesh in the form 
Mesh = MeshTriangle(double(manifold.faces), double(manifold.vertices), 'Gamma');

% define function spaces (i.e. the DoFmaps)
Vh_DoFmap = uint32(Mesh.Triangulation);

% assemble
tic
FEM = feval(str2func('Assem_Laplace_Penalty_Surface'),[], ...
            Mesh.X,uint32(Mesh.Triangulation),[],[],Vh_DoFmap);
toc

% How matrices are stored
R0  = FEM(1).MAT;
R1 = FEM(2).MAT;
end