function status = FEL_Execute_Assemble_Refined_Square_Codim_1(mexName)
%FEL_Execute_Assemble_Refined_Square_Codim_1
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 06-25-2012,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% get test mesh
[Omega_P1_Vtx, Omega_Tri] = Standard_Triangle_Mesh_Test_Data();
% domain is a square [0, 2] X [0, 2]
% refine it!
for ind = 1:3
    Marked_Tri = (1:1:size(Omega_Tri,1))';
    [Omega_P1_Vtx, Omega_Tri] = Refine_Entire_Mesh(Omega_P1_Vtx,Omega_Tri,[],Marked_Tri);
end
Omega_P1_DoFmap = uint32(Omega_Tri);
U_Space_DoFmap = Omega_P1_DoFmap;
%Num_P1_Nodes = size(Omega_P1_Vtx,1);

% BEGIN: define subdomain of codim = 1
% get all mesh edges
Global_Edges = Get_Global_Edge_List(Omega_Tri);
% get coordinates of mid points
Mid_Vtx = 0.5 * (Omega_P1_Vtx(Global_Edges(:,1),:) + Omega_P1_Vtx(Global_Edges(:,2),:));
% find all edges that lie on [0, 1] X {1} (horizontal midline)
Horiz_Mask = (Mid_Vtx(:,2) > 1-1e-8) & (Mid_Vtx(:,2) < 1+1e-8);
Gamma_Edges = Global_Edges(Horiz_Mask,:);
% Gamma vertex coordinates
Gamma_P1_Nodes = unique(Gamma_Edges(:));
% adjust ordering of P1 DoFmap (i.e. the orientation of the Gamma curve should be toward the right)
FLIP_mask = Omega_P1_Vtx(Gamma_Edges(:,2),1) < Omega_P1_Vtx(Gamma_Edges(:,1),1);
Gamma_Edges(FLIP_mask,:) = Gamma_Edges(FLIP_mask,[2 1]);
% get codimension 1 data
[Codim_1_Pos, Codim_1_Neg] = Get_Triangle_Containing_Edge_Info(Omega_Tri,Gamma_Edges);
% there is more than one way to choose which triangle borders the given edge
% for this test take a random assortment
Pos_Mask = rand(size(Gamma_Edges,1),1) > -0.5;
Neg_Mask = ~Pos_Mask;
Codim_1_Data = 0*Codim_1_Pos;
Codim_1_Data(Pos_Mask,:) = Codim_1_Pos(Pos_Mask,:);
Codim_1_Data(Neg_Mask,:) = Codim_1_Neg(Neg_Mask,:);
Codim_1_Data = int32(Codim_1_Data);
% need temp mesh
Temp_Mesh = MeshTriangle(Omega_Tri, Omega_P1_Vtx, 'Omega');
% manually add the subdomain embedding for Gamma
Temp_Mesh.Subdomain.Name = 'Gamma';
Temp_Mesh.Subdomain.Dim  = 1;
Temp_Mesh.Subdomain.Data = Codim_1_Data;
% create embedding data
DoI_Names = {'Gamma'};
Subdomain_Embed = Temp_Mesh.Generate_Subdomain_Embedding_Data(DoI_Names);
clear Temp_Mesh;

% construct P1 DoFmap on Gamma
Gamma_Num_P1_Nodes = length(Gamma_P1_Nodes);
Gamma_P1_Ind     = (1:1:Gamma_Num_P1_Nodes)';
GtoL             = zeros(max(Gamma_Edges(:)),1);
GtoL(Gamma_P1_Nodes) = Gamma_P1_Ind;
Gamma_P1_DoFmap      = Gamma_Edges;
Gamma_P1_DoFmap(:)   = GtoL(Gamma_P1_DoFmap(:));

% Gamma P2 vertices
Gamma_P1_Vtx   = Omega_P1_Vtx(Gamma_P1_Nodes,:);
Gamma_Edge_Mid_Vtx = 0.5*(Gamma_P1_Vtx(Gamma_P1_DoFmap(:,1),:) + Gamma_P1_Vtx(Gamma_P1_DoFmap(:,2),:));
Gamma_P2_Vtx     = [Gamma_P1_Vtx; Gamma_Edge_Mid_Vtx];

% construct P2 DoFmap on Gamma
Gamma_P1_DoFmap = uint32(Gamma_P1_DoFmap); % NOTE! unsigned integer
P2_Extra_Ind = (1:1:size(Gamma_Edges,1))' + Gamma_Num_P1_Nodes;
M_Space_DoFmap = uint32([Gamma_P1_DoFmap, P2_Extra_Ind]);
E_Space_DoFmap = M_Space_DoFmap(:,1:2);
% END: define subdomain of codim = 1

% define external coefficient functions
my_v     = exp(Omega_P1_Vtx(:,1)); % exp(x)
my_mu    = exp(Gamma_P2_Vtx(:,1)); % exp(x)
my_theta = Gamma_P1_Vtx(:,1).*Gamma_P1_Vtx(:,2).^2; % x*y^2
old_soln_Values = sin(Omega_P1_Vtx(:,1) + Omega_P1_Vtx(:,2).^2); % the function sin(x + y^2)

% assemble
tic
FEM = feval(str2func(mexName),[],Omega_P1_Vtx,Omega_P1_DoFmap,[],Subdomain_Embed,E_Space_DoFmap,M_Space_DoFmap,U_Space_DoFmap,old_soln_Values);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_Assemble_Refined_Square_Codim_1.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the P2 mass matrix should be the length of the horizontal curve.  Error is:');
abs(sum(sum(FEM(3).MAT)) - 2)

disp('Integrating  exp(x)^2  over the horizontal curve.  Error is:');
abs((my_v' * FEM(3).MAT * my_mu) - 0.5*(exp(4) - exp(0)))

disp('Summing the mixed boundary "mass" matrix should be the length of the horizontal curve.  Error is:');
sum(sum(FEM(1).MAT)) - 2

disp('Integrating  x*y^2*exp(x)  over the horizontal curve.  Error is:');
abs((my_theta' * FEM(1).MAT * my_mu) - (1 + exp(2)))

disp('Integrating  (d/dy sin(x + y^2) * d/ds exp(x(s)))  over the horizontal curve.  Error is:');
ANSWER = exp(2)*(cos(3) + sin(3)) - (cos(1) + sin(1));
abs((my_mu' * FEM(2).MAT) - ANSWER)

disp('Summing the boundary vector should be 0.  Error is:');
abs(sum(sum(FEM(2).MAT)) - 0)

figure;
p1 = trimesh(Omega_Tri,Omega_P1_Vtx(:,1),Omega_P1_Vtx(:,2),0*old_soln_Values(:,1));
view(2);
shading interp;
set(p1,'edgecolor','k'); % make mesh black
hold on;
plot(Gamma_P1_Vtx(:,1),Gamma_P1_Vtx(:,2),'m','LineWidth',2.5);
hold off;
axis equal
title('Omega Mesh with Gamma Boundary in magenta');

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