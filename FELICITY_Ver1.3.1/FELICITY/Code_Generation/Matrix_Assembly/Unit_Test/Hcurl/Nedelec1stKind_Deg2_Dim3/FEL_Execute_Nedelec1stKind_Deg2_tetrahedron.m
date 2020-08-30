function status = FEL_Execute_Nedelec1stKind_Deg2_tetrahedron(mexName_DoF,mexName_assembly,mexName_Interp)
%FEL_Execute_Nedelec1stKind_Deg2_tetrahedron
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 11-13-2016,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% BEGIN: create mesh

% get standard example mesh
nn = (2^1)+1; % max (2^4)+1
[Tet, Vtx] = regular_tetrahedral_mesh(nn,nn,nn);
% domain is a cube [0, 1]^3

MT = MeshTetrahedron(Tet,Vtx,'Omega');
%MT = MT.Remove_Unused_Vertices();

% do special ordering for 3-D H(curl)
MT  = MT.Order_Cell_Vertices_For_Hcurl();
Tet = MT.ConnectivityList;
%MT.Plot;

% get mesh edges and faces (error check)
Edges = MT.edges;
Faces = MT.faces;
Bdy = MT.freeBoundary;
MT = MT.Append_Subdomain('2D','d_Omega',Bdy);

Omega_Vtx = MT.Points;
Omega_DoFmap = uint32(Tet);
% END: create mesh

% BEGIN: define some stuff

% allocate DoFs
tic
Ned2_DoFmap = feval(str2func(mexName_DoF),Omega_DoFmap);
toc
% there are two distinct DoFs associated with each global mesh edge
% and two with each face
Num_Ned2_Nodes = 2*size(Edges,1) + 2*size(Faces,1);
if (Num_Ned2_Nodes~=max(Ned2_DoFmap(:)))
    error('Nedelec_2 DoFmap is not formed correctly!');
end
% DoF_indices = (1:1:Num_Ned2_Nodes)';

%Ned2_DoFmap

%Num_P1_Nodes = size(Omega_Vtx,1);
P1_DoFmap = Omega_DoFmap;
% END: define some stuff

% pre-assemble to get matrices
tic
FEM = feval(str2func(mexName_assembly),[],Omega_Vtx,Omega_DoFmap,[],[],Ned2_DoFmap,P1_DoFmap,...
                                       zeros(Num_Ned2_Nodes,1),zeros(Num_Ned2_Nodes,1));
toc
Ned2_Mats = FEMatrixAccessor('Ned2 Matrices',FEM);
M = Ned2_Mats.Get_Matrix('Mass_Matrix');
RHS_Proj_1 = Ned2_Mats.Get_Matrix('Ned2_Proj_Mat_1');
RHS_Proj_2 = Ned2_Mats.Get_Matrix('Ned2_Proj_Mat_2');
RHS_Proj_3 = Ned2_Mats.Get_Matrix('Ned2_Proj_Mat_3');

% define some coefficient functions
u_soln_func = @(X) [sin(pi*X(:,1)), sin(pi*X(:,2)), sin(pi*X(:,3))];
P1_Interp_u_soln = u_soln_func(Omega_Vtx);

% compute coefficients in Ned2 by projection
disp('Compute L^2 projection...');
tic
Proj_Soln  = M \ [RHS_Proj_1, RHS_Proj_2, RHS_Proj_3];
toc
uu_VEC = Proj_Soln(:,1);
u_old  = Proj_Soln(:,2);
u_soln = Proj_Soln(:,3);

% assemble
tic
FEM = feval(str2func(mexName_assembly),[],Omega_Vtx,Omega_DoFmap,[],[],Ned2_DoFmap,P1_DoFmap,u_old,u_soln);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_Nedelec1stKind_Deg2_tetrahedron_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the Ned2 mass matrix should be close to (9.488741375049965).  Error is:');
sum(sum(FEM(4).MAT)) - 9.488741375049965

disp('Compute integral of (x^2 + y^2 + z^2) over [0, 1]^3 with Ned2 mass matrix.  Error is:');
uu_VEC' * FEM(4).MAT * uu_VEC - (1)

disp('Compute integral of |curl([-y, z, x])|^2 over [0, 1]^3 with Ned2 curl-curl matrix.  Error is:');
uu_VEC' * FEM(1).MAT * uu_VEC - (3)

disp('Compute integral of sum(curl([exp(-y), x^2, z^3])) over [0, 1]^3 with small matrix.  Error is:');
FEM(9).MAT - (2 - exp(-1))

disp('Compute L^2 error between Ned2 projection of exact solution, and exact solution u_soln.  Error is:');
L2_sq = FEM(3).MAT;
sqrt(L2_sq)

% setup finite element space
Ref_Ned2    = ReferenceFiniteElement(nedelec_1stkind_deg2_dim3());
Ned2_Space  = FiniteElementSpace('Ned2 Space',Ref_Ned2,MT,'Omega');
Ned2_Space  = Ned2_Space.Set_DoFmap(MT,Ned2_DoFmap);
Ned2_Space  = Ned2_Space.Append_Fixed_Subdomain(MT,'d_Omega');
Fixed_Nodes = Ned2_Space.Get_Fixed_DoFs(MT);
Free_Nodes  = Ned2_Space.Get_Free_DoFs(MT);

% disp('Condition # of')
% FEM(1)
% disp('is (after removing DoFs)')
% cond(FEM(1).MAT(Free_Nodes,Free_Nodes))
% 
% disp('Condition # of')
% FEM(4)
% disp('is')
% cond(FEM(4).MAT)

disp('Solve Plain-Vanilla Maxwell Problem with RHS_CC Matrix');
MAT = FEM(1).MAT + FEM(4).MAT;
RHS = FEM(8).MAT;
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
FEM_Soln = feval(str2func(mexName_assembly),[],Omega_Vtx,Omega_DoFmap,[],[],Ned2_DoFmap,P1_DoFmap,0*u_old,u_soln_numerical);
FEM_Soln = full(FEM_Soln(3).MAT);
sqrt(FEM_Soln) % yes, you need the sqrt!

% interpolate the Nedelec2 solution

% define the interpolation points (interpolate at the vertices)
Vtx_Indices = (1:1:MT.Num_Vtx)';
[TF1, LOC1] = ismember(Vtx_Indices,Omega_DoFmap(:,1));
[TF2, LOC2] = ismember(Vtx_Indices,Omega_DoFmap(:,2));
[TF3, LOC3] = ismember(Vtx_Indices,Omega_DoFmap(:,3));
[TF4, LOC4] = ismember(Vtx_Indices,Omega_DoFmap(:,4));

Cell_Omega_Indices = zeros(MT.Num_Vtx,1);
Cell_Omega_Indices(TF1,1) = LOC1(TF1);
Cell_Omega_Indices(TF2,1) = LOC2(TF2);
Cell_Omega_Indices(TF3,1) = LOC3(TF3);
Cell_Omega_Indices(TF4,1) = LOC4(TF4);

% coordinates
Ref_Coord = zeros(MT.Num_Vtx,3);
Ref_Coord(TF2,1) = 1;
Ref_Coord(TF3,2) = 1;
Ref_Coord(TF4,3) = 1;
Omega_Interp_Data = {uint32(Cell_Omega_Indices), Ref_Coord};

% interpolate!
tic
INTERP = feval(str2func(mexName_Interp),Omega_Vtx,Omega_DoFmap,[],[],...
                                        Omega_Interp_Data,Ned2_DoFmap,u_soln_numerical);
toc

% extract interpolant
I_u_soln = [INTERP.DATA{1,1}, INTERP.DATA{2,1}, INTERP.DATA{3,1}];
Diff_u_soln = abs(P1_Interp_u_soln - I_u_soln);
disp('L_inf error:');
max(Diff_u_soln(:))



% need to take a slice.......

% disp('Plot the vector solution:');
% figure;
% quiver(Omega_Vtx(:,1),Omega_Vtx(:,2),I_u_soln(:,1),I_u_soln(:,2));
% title('Solution of Simple Maxwell Problem with Ned_2 (Interpolated Solution)');
% axis([0 2 0 2]);
% grid;
% axis equal;
% axis([0 2 0 2]);



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