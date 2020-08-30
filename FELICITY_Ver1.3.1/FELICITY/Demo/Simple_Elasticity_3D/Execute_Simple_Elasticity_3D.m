function status = Execute_Simple_Elasticity_3D()
%Execute_Simple_Elasticity_3D
%
%   Demo code for Elasticity 3-D.

% Copyright (c) 06-25-2012,  Shawn W. Walker

% BEGIN: define square column mesh
[Omega_Tet, Omega_Vertex] = regular_tetrahedral_mesh(2+1,2+1,10+1);
% scale it
Omega_Vertex(:,1:2) = (1/5) * Omega_Vertex(:,1:2);
Mesh = MeshTetrahedron(Omega_Tet, Omega_Vertex, 'Omega');
clear Omega_Tet Omega_Vertex;
% END: define square column mesh

% define subdomains
Bdy_Faces = Mesh.freeBoundary();
Mesh = Mesh.Append_Subdomain('2D','Bdy',Bdy_Faces);
% get centroids of boundary triangles
FF_center = (1/3) * (Mesh.Points(Bdy_Faces(:,1),:) + Mesh.Points(Bdy_Faces(:,2),:) + Mesh.Points(Bdy_Faces(:,3),:));
% find faces on top
Top_Mask = (FF_center(:,3) > 1 - 1e-5);
Top_Faces = Bdy_Faces(Top_Mask,:);
Mesh = Mesh.Append_Subdomain('2D','Top',Top_Faces);
% find faces on bottom
Bot_Mask = (FF_center(:,3) < 0 + 1e-5);
Bot_Faces = Bdy_Faces(Bot_Mask,:);
Mesh = Mesh.Append_Subdomain('2D','Bottom',Bot_Faces);

% find vertices on the edge segment: (0,0,1) - (0,0,0)
Col_Edge_Vtx_Mask = (Mesh.Points(:,1) < 0 + 1e-5) & (Mesh.Points(:,2) < 0 + 1e-5);
Col_Edge_Vtx = Mesh.Points(Col_Edge_Vtx_Mask,:);
All_Vtx_Indices = (1:1:Mesh.Num_Vtx)';
Col_Edge_Vtx_Indices = All_Vtx_Indices(Col_Edge_Vtx_Mask);
[Col_Edge_Vtx, I1] = sortrows(Col_Edge_Vtx,3); % sort in ascending order along z
Col_Edge_Vtx_Indices = Col_Edge_Vtx_Indices(I1);
% define the column edges
Col_Edge_Data = [Col_Edge_Vtx_Indices(1:end-1,1), Col_Edge_Vtx_Indices(2:end,1)];
Mesh = Mesh.Append_Subdomain('1D','Sigma',Col_Edge_Data);

% create embedding data
DoI_Names = {'Omega'; 'Sigma'};
Subdomain_Embed = Mesh.Generate_Subdomain_Embedding_Data(DoI_Names);

% define function spaces (i.e. the DoFmaps)
P1_DoFmap = uint32(Mesh.ConnectivityList);

% init values
Displace = Mesh.Points;

% assemble
tic
FEM = DEMO_mex_Simple_Elasticity_3D_assemble([],Mesh.Points,uint32(Mesh.ConnectivityList),[],Subdomain_Embed,P1_DoFmap,Displace);
toc

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);
RefFEMDataFileName = fullfile(Current_Dir,'Demo_Simple_Elasticity_3D_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the P1 vector mass matrix should be (3*0.04).  Error is:');
sum(FEM(2).MAT(:)) - (3*0.04)

disp('Summing the P1 stiffness matrix should be close to 0.  Error is:');
sum(FEM(3).MAT(:)) - 0

disp('Solve the Vector Laplace equation with Dirichlet conditions on Top and Bottom:');
Soln = zeros(Mesh.Num_Vtx,3); % init
A   = FEM(3).MAT;
disp('----> set u=(0,0,0) on bottom, and u=(0.2,0.2,0.1) on the top.');
RHS = 0*Soln(:);
% get top Degrees-of-Freedom (DoF)
Top_Nodes = unique(Top_Faces(:));
Soln(Top_Nodes,1) = 0.2;
Soln(Top_Nodes,2) = 0.2;
Soln(Top_Nodes,3) = 0.1;
Soln = Soln(:); % collapse to a single column vector
RHS = RHS - A * Soln;
% get bottom DoF
Bot_Nodes = unique(Bot_Faces(:));
% bottom nodes are already set to zero

% get the free nodes of the system
FreeNodes_X = setdiff(All_Vtx_Indices,[Top_Nodes; Bot_Nodes]);
FreeNodes_Y = [FreeNodes_X + Mesh.Num_Vtx];
FreeNodes_Z = [FreeNodes_Y + Mesh.Num_Vtx];
FreeNodes = [FreeNodes_X; FreeNodes_Y; FreeNodes_Z];

disp('Use backslash to solve:');
Soln(FreeNodes,1) = A(FreeNodes,FreeNodes) \ RHS(FreeNodes,1);
Displace = zeros(Mesh.Num_Vtx,3);
Displace(:) = Soln; % put displacement solution back into 3-D vector form
Recalc_FEM = DEMO_mex_Simple_Elasticity_3D_assemble([],Mesh.Points,uint32(Mesh.ConnectivityList),[],Subdomain_Embed,P1_DoFmap,Displace);

disp('Integrating the Displacement vector.Tangent_Vector on \Sigma should be (0.1/2).  Error is:');
Recalc_FEM(1).MAT - (0.1/2)

figure;
subplot(1,2,1);
h1 = Mesh.Plot;
title('Reference Mesh','FontSize',14);
set(gca,'FontSize',14);
AX = [0 0.4 0 0.4 0 1.2];
axis(AX);
axis equal;
axis(AX);

subplot(1,2,2);
New_Mesh = Mesh.Set_Points(Mesh.Points + Displace); % make a new displaced mesh
h2 = New_Mesh.Plot;
title('Deformed Mesh','FontSize',14);
set(gca,'FontSize',14);
axis(AX);
axis equal;
axis(AX);

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