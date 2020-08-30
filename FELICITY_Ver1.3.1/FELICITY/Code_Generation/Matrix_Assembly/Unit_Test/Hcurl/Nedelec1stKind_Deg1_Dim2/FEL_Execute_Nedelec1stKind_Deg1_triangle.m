function status = FEL_Execute_Nedelec1stKind_Deg1_triangle(mexName_DoF,mexName_assembly,mexName_Interp)
%FEL_Execute_Nedelec1stKind_Deg1_triangle
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 10-19-2016,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% BEGIN: create mesh

% get standard example mesh
[Vtx, Tri] = Standard_Triangle_Mesh_Test_Data();
% domain is a square [0, 2] X [0, 2]
% refine it!
for ind = 1:4
    Marked_Tri = (1:1:size(Tri,1))';
    [Vtx, Tri] = Refine_Entire_Mesh(Vtx,Tri,[],Marked_Tri);
end

% get mesh edges (error check)
MT = MeshTriangle(Tri,Vtx,'Omega');
MT = MT.Remove_Unused_Vertices();

Edges = MT.edges;
Bdy = MT.freeBoundary;
MT = MT.Append_Subdomain('1D','d_Omega',Bdy);

Omega_Vtx = MT.Points;
Omega_DoFmap = uint32(MT.ConnectivityList);
% END: create mesh

% BEGIN: define some stuff

% allocate DoFs
tic
Ned1_DoFmap = feval(str2func(mexName_DoF),Omega_DoFmap);
toc
% there are two distinct DoFs associated with each global mesh edge
Num_Ned1_Nodes = 1*size(Edges,1);
if (Num_Ned1_Nodes~=max(Ned1_DoFmap(:)))
    error('Nedelec_1 DoFmap is not formed correctly!');
end
% DoF_indices = (1:1:Num_Ned1_Nodes)';
%Ned1_DoFmap

%Num_P1_Nodes = size(Omega_Vtx,1);
P1_DoFmap = Omega_DoFmap;
% END: define some stuff

% pre-assemble to get matrices
tic
FEM = feval(str2func(mexName_assembly),[],Omega_Vtx,Omega_DoFmap,[],[],Ned1_DoFmap,P1_DoFmap,...
                                       zeros(Num_Ned1_Nodes,1),zeros(Num_Ned1_Nodes,1));
toc
Ned1_Mats = FEMatrixAccessor('Ned1 Matrices',FEM);
M = Ned1_Mats.Get_Matrix('Mass_Matrix');
Ned1 = Ned1_Mats.Get_Matrix('Ned1_Proj_Mat_1');
Ned2 = Ned1_Mats.Get_Matrix('Ned1_Proj_Mat_2');

% define some coefficient functions
uu_VEC_func = @(X) [-X(:,2), X(:,1)];
u_old_func  = @(X) [exp(-X(:,2)), X(:,1).^2];
u_soln_func = @(X) [sin(pi*X(:,1)), sin(pi*X(:,2))];
P1_Interp_uu_VEC = uu_VEC_func(Omega_Vtx);
P1_Interp_u_old  = u_old_func(Omega_Vtx);
P1_Interp_u_soln = u_soln_func(Omega_Vtx);

% compute coefficients in Ned1 by projection
RHS_Proj_1 = (Ned1 * P1_Interp_uu_VEC(:,1)) + (Ned2 * P1_Interp_uu_VEC(:,2));
RHS_Proj_2 = (Ned1 * P1_Interp_u_old(:,1))  + (Ned2 * P1_Interp_u_old(:,2));
RHS_Proj_3 = (Ned1 * P1_Interp_u_soln(:,1)) + (Ned2 * P1_Interp_u_soln(:,2));
Proj_Soln  = M \ [RHS_Proj_1, RHS_Proj_2, RHS_Proj_3];
uu_VEC = Proj_Soln(:,1);
u_old  = Proj_Soln(:,2);
u_soln = Proj_Soln(:,3);

% assemble
tic
FEM = feval(str2func(mexName_assembly),[],Omega_Vtx,Omega_DoFmap,[],[],Ned1_DoFmap,P1_DoFmap,u_old,u_soln);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_Nedelec1stKind_Deg1_triangle_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the Ned1 mass matrix should be close to (11600/3).  Error is:');
sum(sum(FEM(4).MAT)) - (11600/3)

disp('Compute integral of (x^2 + y^2) over [0, 2] x [0, 2] with Ned1 mass matrix.  Error is:');
uu_VEC' * FEM(4).MAT * uu_VEC - (32/3)

disp('Compute integral of (curl([-y, x]))^2 over [0, 2] x [0, 2] with Ned1 curl-curl matrix.  Error is:');
uu_VEC' * FEM(1).MAT * uu_VEC - (16)

disp('Compute integral of curl([exp(-y), x^2]) over [0, 2] x [0, 2] with small matrix.  Error is:');
FEM(8).MAT - (10 - 2*exp(-2))

disp('Compute L^2 error between Ned1 projection of exact solution, and exact solution u_soln.  Error is:');
L2_sq = FEM(3).MAT;
sqrt(L2_sq)

% setup finite element space
Ref_Ned1   = ReferenceFiniteElement(nedelec_1stkind_deg1_dim2());
Ned1_Space = FiniteElementSpace('Ned1 Space',Ref_Ned1,MT,'Omega');
Ned1_Space = Ned1_Space.Set_DoFmap(MT,Ned1_DoFmap);
Ned1_Space = Ned1_Space.Append_Fixed_Subdomain(MT,'d_Omega');
Fixed_Nodes = Ned1_Space.Get_Fixed_DoFs(MT);
Free_Nodes  = Ned1_Space.Get_Free_DoFs(MT);

disp('Solve Plain-Vanilla Maxwell Problem with RHS_CC Matrix');
MAT = FEM(1).MAT + FEM(4).MAT;
RHS = FEM(7).MAT;
% add in RHS data
Soln_BC = zeros(size(MAT,1),1);
Soln_BC(Fixed_Nodes,1) = u_soln(Fixed_Nodes,1);
RHS = RHS - MAT*Soln_BC;
% init Soln to include BCs
Soln = Soln_BC;
Soln(Free_Nodes,1) = MAT(Free_Nodes,Free_Nodes) \ RHS(Free_Nodes,1);
u_soln_numerical = Soln;
disp(' ');
disp('L^2 *error* of numerical solution (less than 1.0):');
FEM_Soln = feval(str2func(mexName_assembly),[],Omega_Vtx,Omega_DoFmap,[],[],Ned1_DoFmap,P1_DoFmap,0*u_old,u_soln_numerical);
FEM_Soln = full(FEM_Soln(3).MAT);
sqrt(FEM_Soln) % yes, you need the sqrt!

% interpolate the Nedelec1 solution

% define the interpolation points (interpolate at the vertices)
Vtx_Indices = (1:1:MT.Num_Vtx)';
[TF1, LOC1] = ismember(Vtx_Indices,Omega_DoFmap(:,1));
[TF2, LOC2] = ismember(Vtx_Indices,Omega_DoFmap(:,2));
[TF3, LOC3] = ismember(Vtx_Indices,Omega_DoFmap(:,3));

Cell_Omega_Indices = zeros(MT.Num_Vtx,1);
Cell_Omega_Indices(TF1,1) = LOC1(TF1);
Cell_Omega_Indices(TF2,1) = LOC2(TF2);
Cell_Omega_Indices(TF3,1) = LOC3(TF3);

% coordinates
Ref_Coord = zeros(MT.Num_Vtx,2);
Ref_Coord(TF2,1) = 1;
Ref_Coord(TF3,2) = 1;
Omega_Interp_Data = {uint32(Cell_Omega_Indices), Ref_Coord};

% interpolate!
tic
INTERP = feval(str2func(mexName_Interp),Omega_Vtx,Omega_DoFmap,[],[],...
                                        Omega_Interp_Data,Ned1_DoFmap,u_soln_numerical);
toc

% extract interpolant
I_u_soln = [INTERP.DATA{1,1}, INTERP.DATA{2,1}];
Diff_u_soln = abs(P1_Interp_u_soln - I_u_soln);
disp('L_inf error (about 1.184E-01):');
max(Diff_u_soln(:))

disp('Plot the vector solution:');
figure;
quiver(Omega_Vtx(:,1),Omega_Vtx(:,2),I_u_soln(:,1),I_u_soln(:,2));
title('Solution of Simple Maxwell Problem with Ned_1 (Interpolated Solution)');
axis([0 2 0 2]);
grid;
axis equal;
axis([0 2 0 2]);

status = 0; % init
% compare to reference data
ERRORS = zeros(length(FEM),1);
for ind = 1:length(FEM)
    ERRORS(ind) = max(abs(FEM(ind).MAT(:) - FEM_REF(ind).MAT(:)));
    if (ERRORS(ind) > 1e-13)
        ERRORS(ind)
        disp(['Test Failed for FEM(', num2str(ind), ').MAT...']);
        status = 1;
    end
end

end