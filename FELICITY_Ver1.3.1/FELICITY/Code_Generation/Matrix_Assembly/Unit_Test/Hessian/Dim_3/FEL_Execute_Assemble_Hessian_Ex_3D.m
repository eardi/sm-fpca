function status = FEL_Execute_Assemble_Hessian_Ex_3D(mexNameDoF,mexNameAssem)
%FEL_Execute_Assemble_Hessian_Ex_3D
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 08-15-2014,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% get standard example mesh
Num_Edges_1D = 5;
NP = Num_Edges_1D + 1;
[Tet, Vtx] = regular_tetrahedral_mesh(NP,NP,NP);
% domain is a cube [0, 1] X [0, 1] X [0, 1]
Mesh = MeshTetrahedron(Tet,Vtx,'Omega');
P1_Mesh_DoFmap = uint32(Mesh.ConnectivityList);
P1_Mesh_Nodes = Mesh.Points;

% define function spaces (i.e. the DoFmaps)
Ref_P2_Elem = ReferenceFiniteElement(lagrange_deg2_dim3);
Space = FiniteElementSpace('Vector_P2',Ref_P2_Elem,Mesh,'Omega',2);
P2_DoFmap = feval(str2func(mexNameDoF),P1_Mesh_DoFmap);
Space = Space.Set_DoFmap(Mesh,P2_DoFmap);
P2_Mesh_Nodes  = Space.Get_DoF_Coord(Mesh);
P2_Mesh_DoFmap = P2_DoFmap;

% define coefficient functions
% [exp(x)*y*sin(2*z) - 1, y*exp(-x)*cos(3*z), 0]
Vector_Values = [(exp(P2_Mesh_Nodes(:,1)).*P2_Mesh_Nodes(:,2).*sin(2*P2_Mesh_Nodes(:,3)) - 1),...
                  P2_Mesh_Nodes(:,2).*exp(-P2_Mesh_Nodes(:,1)).*cos(3*P2_Mesh_Nodes(:,3)),...
                  0*P2_Mesh_Nodes(:,1)];
%

% assemble
tic
FEM = feval(str2func(mexNameAssem),[],P1_Mesh_Nodes,P1_Mesh_DoFmap,[],[],...
                                   Space.DoFmap,Vector_Values);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_Assemble_Hessian_Ex_3D_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the rows of the vector hessian matrix and dsds matrix should be the same!');
disp('        And close to zero.  Max error is:');
max(abs(sum(FEM(2).MAT,2))) - 0

disp('Compute integrals of the hessian of known functions and compare to true values.  Relative error is:');
V1 = 3.985173757903920e+01;
REL_ERR = (Vector_Values(:)' * FEM(2).MAT * Vector_Values(:) - V1) / V1;
REL_ERR

disp('Compute the error in the integral of trace(hess(Vec(2))).  Error is:')
FEM(1).MAT - (-1.189398111337744e-01)

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