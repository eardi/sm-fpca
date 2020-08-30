function status = FEL_Execute_Assemble_Hessian_Ex_2D(mexName)
%FEL_Execute_Assemble_Hessian_Ex_2D
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 08-14-2014,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% get standard example mesh
[Vtx, Tri] = Standard_Triangle_Mesh_Test_Data();
% domain is a square [0, 2] X [0, 2]
Mesh = MeshTriangle(Tri,Vtx,'Omega');
% refine it!
for ind = 1:2
    Mesh = Mesh.Refine;
end
P1_Mesh_DoFmap = uint32(Mesh.ConnectivityList);
P1_Mesh_Nodes = Mesh.Points;
P2_DoFmap = uint32(Setup_Lagrange_P2_DoFmap(Mesh.ConnectivityList,[]));

% define function spaces (i.e. the DoFmaps)
Ref_P2_Elem = ReferenceFiniteElement(lagrange_deg2_dim2);
Space = FiniteElementSpace('Vector_P2',Ref_P2_Elem,Mesh,'Omega',2);
Space = Space.Set_DoFmap(Mesh,P2_DoFmap);
P2_Mesh_Nodes  = Space.Get_DoF_Coord(Mesh);
P2_Mesh_DoFmap = P2_DoFmap;

% define coefficient functions
% [y*exp(x) - 1, y*exp(-x)]
Vector_Values = [(P2_Mesh_Nodes(:,2).*exp(P2_Mesh_Nodes(:,1))-1), P2_Mesh_Nodes(:,2).*exp(-P2_Mesh_Nodes(:,1))];

% assemble
tic
FEM = feval(str2func(mexName),[],P1_Mesh_Nodes,P1_Mesh_DoFmap,[],[],...
                              Space.DoFmap,Vector_Values);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_Assemble_Hessian_Ex_2D_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the rows of the vector hessian matrix and dsds matrix should be the same!');
disp('        And close to zero.  Max error is:');
max(abs(sum(FEM(2).MAT,2))) - 0

disp('Compute integrals of the hessian of known functions and compare to true values.  Relative error is:');
V1 = (sinh(4)/2) * (16/3 + 8);
REL_ERR = (Vector_Values(:)' * FEM(2).MAT * Vector_Values(:) - V1) / V1;
REL_ERR

disp('The Integral of (d^2/dx^2 e^{-x}) from 0 to 1 should be (1 - e^{-1}).  Error is:')
FEM(1).MAT - ((1 - exp(-2))*2)

status = 0; % init
% compare to reference data
ERRORS = zeros(length(FEM),1);
for ind = 1:length(FEM)
    ERRORS(ind) = max(abs(FEM(ind).MAT(:) - FEM_REF(ind).MAT(:)));
    if (ERRORS(ind) > 1e-6)
        disp(['Test Failed for FEM(', num2str(ind), ').MAT...']);
        status = 1;
    end
end

end