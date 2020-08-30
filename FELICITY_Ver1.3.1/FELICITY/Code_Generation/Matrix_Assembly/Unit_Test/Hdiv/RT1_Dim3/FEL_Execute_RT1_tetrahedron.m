function status = FEL_Execute_RT1_tetrahedron(mexName_DoF,mexName_assembly)
%FEL_Execute_RT1_tetrahedron
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 10-17-2016,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% BEGIN: create mesh

% get standard example mesh
nn = (2^2)+1; % max (2^4)+1
[Tet, Vtx] = regular_tetrahedral_mesh(nn,nn,nn);
% domain is a cube [0, 1]^3

% compute circum-centers
MT = MeshTetrahedron(Tet,Vtx,'Omega');
CC = MT.circumcenter;
Faces = MT.faces;

[Tet_Face, Omega_Orient] = MT.Get_Facet_Info(Faces);
% a true entry means the local face of the given tet is contained in the
% Tet_Face array (possibly with an even permutation);
% false means it appears with an odd permutation.
clear MT;
% find closest triangle to the x-axis
[Y, Ind] = min(CC(:,2));
Fixed_Pressure_Node = Ind;

Omega_Vtx = Vtx;
Omega_DoFmap = uint32(Tet);
% END: create mesh

% BEGIN: define some stuff

% allocate DoFs
tic
RT1_DoFmap = feval(str2func(mexName_DoF),Omega_DoFmap);
toc
% there are three distinct DoFs associated with each global mesh face
% plus 3 interior DoFs per element
Num_RT1_Nodes = 3*size(Faces,1) + 3*size(Tet,1);
if (Num_RT1_Nodes~=max(RT1_DoFmap(:)))
    error('RT_1 DoFmap is not formed correctly!');
end
% DoF_indices = (1:1:Num_RT1_Nodes)';

Num_P1_Nodes = size(Omega_Vtx,1);
P1_DoFmap = Omega_DoFmap;

% END: define some stuff

% pre-assemble to get matrices
tic
FEM = feval(str2func(mexName_assembly),[],Omega_Vtx,Omega_DoFmap,Omega_Orient,[],P1_DoFmap,RT1_DoFmap,...
                                          zeros(Num_P1_Nodes,1),zeros(Num_RT1_Nodes,1));
toc
RT1_Mats = FEMatrixAccessor('RT1 Matrices',FEM);
M = RT1_Mats.Get_Matrix('Mass_Matrix');
R1 = RT1_Mats.Get_Matrix('RT1_Proj_Mat_1');
R2 = RT1_Mats.Get_Matrix('RT1_Proj_Mat_2');
R3 = RT1_Mats.Get_Matrix('RT1_Proj_Mat_3');

% define some coefficient functions
F1 = @(X) [X(:,1), X(:,2), X(:,3)];
F2 = @(X) [exp(-X(:,1)), X(:,2).^2, sin(X(:,3))];
P1_Interp_F1 = F1(Omega_Vtx);
P1_Interp_F2 = F2(Omega_Vtx);

% compute coefficients in RT1 by projection
RHS_1 = (R1 * P1_Interp_F1(:,1)) + (R2 * P1_Interp_F1(:,2)) + (R3 * P1_Interp_F1(:,3));
RHS_2 = (R1 * P1_Interp_F2(:,1)) + (R2 * P1_Interp_F2(:,2)) + (R3 * P1_Interp_F2(:,3));
Proj_Funcs = M \ [RHS_1, RHS_2];
uu_VEC  = Proj_Funcs(:,1);
old_vel = Proj_Funcs(:,2);

% set to zero
old_p = zeros(Num_P1_Nodes,1);

% assemble
tic
FEM = feval(str2func(mexName_assembly),[],Omega_Vtx,Omega_DoFmap,Omega_Orient,[],P1_DoFmap,RT1_DoFmap,...
                                          old_p,old_vel);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_RT1_tetrahedron_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the RT1 mass matrix should be close to (1.775193029926082e+05).  Error is:');
sum(sum(FEM(3).MAT)) - 1.775193029926082e+05

disp('Compute integral of (x^2 + y^2 + z^2) over [0, 1]^3 with RT1 mass matrix.  Error is:');
uu_VEC' * FEM(3).MAT * uu_VEC - (1)

disp('Compute integral of div([x, y, z]) over [0, 1]^3 with RT1/P1 div-pressure matrix.  Error is:');
sum(uu_VEC' * FEM(1).MAT) - (3)

disp('Compute integral of div([exp(-x), y^2, sin(z)]) over [0, 1]^3 with small matrix.  Error is:');
FEM(8).MAT - (exp(-1) + sin(1))

disp('Solve Mixed-Laplace Problem with RHS Body_Force_Matrix');
MAT = [ FEM(3).MAT, -FEM(1).MAT;
       -FEM(1).MAT', sparse(Num_P1_Nodes,Num_P1_Nodes)];
RHS = [zeros(Num_RT1_Nodes,1); -FEM(4).MAT];
Soln = zeros(size(MAT,1),1);
All_Nodes = (1:1:size(Soln,1))';
Free_Nodes = setdiff(All_Nodes,Fixed_Pressure_Node+Num_RT1_Nodes);
Soln(Free_Nodes,1) = MAT(Free_Nodes,Free_Nodes) \ RHS(Free_Nodes,1);
P1_Soln = Soln(end-(Num_P1_Nodes-1):end,1); % extract pressure solution
disp(' ');
disp('L^2 *error* of pressure solution (less than 1.0):');

FEM_P1 = feval(str2func(mexName_assembly),[],Omega_Vtx,Omega_DoFmap,Omega_Orient,[],P1_DoFmap,RT1_DoFmap,P1_Soln,0*old_vel);
L2_Error_Sq = full(FEM_P1(2).MAT);
sqrt(L2_Error_Sq) % yes, you need the sqrt!

% would be nice to have some kind of plot of the solution

status = 0; % init
% compare to reference data
ERRORS = zeros(length(FEM),1);
for ind = 1:length(FEM)
    ERRORS(ind) = max(abs(FEM(ind).MAT(:) - FEM_REF(ind).MAT(:)));
    if (ERRORS(ind) > 1e-13)
        ERRORS
        disp(['Test Failed for FEM(', num2str(ind), ').MAT...']);
        status = 1;
    end
end

end