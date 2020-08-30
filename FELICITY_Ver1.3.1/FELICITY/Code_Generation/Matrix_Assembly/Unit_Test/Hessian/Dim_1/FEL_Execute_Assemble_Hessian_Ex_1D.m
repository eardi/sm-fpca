function status = FEL_Execute_Assemble_Hessian_Ex_1D(mexName)
%FEL_Execute_Assemble_Hessian_Ex_1D
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 08-12-2014,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% BEGIN: define simple 1-D mesh
Num_P1_Nodes = 201; % best relative accuracy for 4th order stiffness matrix is ~1e-6
P1_Ind = (1:1:Num_P1_Nodes)';
P1_Mesh_DoFmap = uint32([P1_Ind(1:end-1,1), P1_Ind(2:end,1)]); % NOTE! unsigned integer
P1_Mesh_Nodes = linspace(0,1,Num_P1_Nodes)';
Num_Edges = size(P1_Mesh_DoFmap,1);
Num_Current_DoF = max(P1_Mesh_DoFmap(:));
Extra_P2_Nodes = Num_Current_DoF + uint32((1:1:Num_Edges)');
P2_DoFmap = [P1_Mesh_DoFmap, Extra_P2_Nodes];
Mesh = MeshInterval(P1_Mesh_DoFmap,P1_Mesh_Nodes,'Sigma');
% END: define simple 1-D mesh

% define function spaces (i.e. the DoFmaps)
Ref_P2_Elem = ReferenceFiniteElement(lagrange_deg2_dim1);
Space = FiniteElementSpace('Scalar_P2',Ref_P2_Elem,Mesh,'Sigma');
Space = Space.Set_DoFmap(Mesh,P2_DoFmap);
P2_Mesh_Nodes  = Space.Get_DoF_Coord(Mesh);
P2_Mesh_DoFmap = P2_DoFmap;

% define coefficient functions
Scalar_Values = 0.01*sin(10*pi*P2_Mesh_Nodes(:,1));
Vector_Values = [(exp(P2_Mesh_Nodes(:,1))-1), exp(-P2_Mesh_Nodes(:,1))];

% assemble
tic
FEM = feval(str2func(mexName),[],P2_Mesh_Nodes,P2_Mesh_DoFmap,[],[],...
                              Space.DoFmap,Space.DoFmap,Scalar_Values,Vector_Values);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_Assemble_Hessian_Ex_1D_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the rows of the vector hessian matrix and dsds matrix should be the same!');
disp('        And close to zero.  Max error is:');
max(abs(sum(FEM(2).MAT,2))) - 0
max(abs(sum(FEM(3).MAT,2))) - 0

disp('Compute integrals of the hessian of known functions and compare to true values.  Relative error is:');
REL_ERR = (Scalar_Values' * FEM(3).MAT * Scalar_Values - (pi^4 / 2)) / (pi^4 / 2);
REL_ERR

V1 = (exp(2) - exp(-2)) / 2;
REL_ERR = (Vector_Values(:)' * FEM(2).MAT * Vector_Values(:) - V1) / V1;
REL_ERR

disp('The Integral of (d^2/ds^2 0.01*sin(10*pi*s)) from 0 to 1 should be zero.  Error is:')
FEM(1).MAT(1) - 0

disp('The Integral of (d^2/dx^2 e^{-x}) from 0 to 1 should be (1 - e^{-1}).  Error is:')
FEM(1).MAT(2) - (1 - exp(-1))

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