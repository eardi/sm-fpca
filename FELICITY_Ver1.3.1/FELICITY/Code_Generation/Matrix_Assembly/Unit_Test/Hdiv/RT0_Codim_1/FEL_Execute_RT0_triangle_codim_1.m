function status = FEL_Execute_RT0_triangle_codim_1(mexName)
%FEL_Execute_RT0_triangle_codim_1
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 06-25-2012,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% BEGIN: create mesh

% get standard example mesh
[Vtx, Tri] = Standard_Triangle_Mesh_Test_Data();
% domain is a square [0, 2] X [0, 2]
% refine it!
Num_Refine = 2;
for ind = 1:Num_Refine
    Marked_Tri = (1:1:size(Tri,1))';
    [Vtx, Tri] = Refine_Entire_Mesh(Vtx,Tri,[],Marked_Tri);
end
MT = MeshTriangle(Tri,Vtx,'Omega');
BE = MT.freeBoundary();
MT = MT.Append_Subdomain('1D','Boundary',BE);
Edges = MT.edges;
[Tri_Edge, Omega_Orient] = MT.Get_Facet_Info(Edges);
% a true entry means the local edge of the given triangle is contained in the
% Tri_Edge array; false means the *reversed* edge is in the Tri_Edge array.
% END: create mesh

% BEGIN: define some stuff

% there is one distinct DoF associated with each global mesh edge
Num_RT0_Nodes = size(Edges,1);
% DoF_indices = (1:1:Num_RT_Nodes)';
RT0_DoFmap = Tri_Edge;
RT0_DoFmap = uint32(RT0_DoFmap);

Num_P0_Nodes = size(MT.Subdomain.Data,1);
P0_DoFmap = (1:1:Num_P0_Nodes)';
P0_DoFmap = uint32(P0_DoFmap);

F1 = @(X) [X(2); X(1)];
uu_VEC = Get_RT0_Interpolant_of_Function(MT.Points,MT.ConnectivityList,RT0_DoFmap,Omega_Orient,F1);
% store the coefficient function values
F2 = @(X) [X(2)^2; exp(-X(1))];
old_vel = Get_RT0_Interpolant_of_Function(MT.Points,MT.ConnectivityList,RT0_DoFmap,Omega_Orient,F2);
Boundary_Edges = MT.Get_Global_Subdomain('Boundary');
Edge_Mid_Pt = 0.5 * (MT.Points(Boundary_Edges(:,1),:) + MT.Points(Boundary_Edges(:,2),:));
old_p = exp(-Edge_Mid_Pt(:,1)); % e^{-x}
% END: define some stuff

% create embedding data
DoI_Names = {'Boundary'};
Subdomain_Embed = MT.Generate_Subdomain_Embedding_Data(DoI_Names);

% assemble
tic
FEM = feval(str2func(mexName),[],MT.Points,uint32(MT.ConnectivityList),Omega_Orient,Subdomain_Embed,P0_DoFmap,RT0_DoFmap);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_RT0_triangle_codim_1_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the RT0 normal vector matrix (over boundary of [0, 2] x [0, 2]) should be close to (8*4^Num_Refine).  Error is:');
sum(sum(FEM(2).MAT)) - (8*4^Num_Refine)

disp('Compute integral of ([y^2,exp(-x)].N)*([y,x].N) over boundary with RT0 normal vector matrix.  Error is:');
old_vel' * FEM(2).MAT * uu_VEC - (8 - 2*(3*exp(-2) - 1))

disp('Compute integral of (e^{-x} * [y, x].N) over boundary with NV_Constraint matrix.  Error is:');
old_p' * FEM(1).MAT * uu_VEC - (2*(exp(-2) - 1))

status = 0; % init
% compare to reference data
ERRORS = zeros(length(FEM),1);
for ind = 1:length(FEM)
    ERRORS(ind) = max(abs(FEM(ind).MAT(:) - FEM_REF(ind).MAT(:)));
    if (ERRORS(ind) > 1e-13)
        disp(['Test Failed for FEM(', num2str(ind), ').MAT...']);
        status = 1;
    end
end

end