function status = FEL_Execute_Mesh_Size_1D(mexName)
%FEL_Execute_Mesh_Size_1D
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 06-25-2012,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% BEGIN: define 1-D mesh
Num_P1_Nodes = 101;
P1_Ind = (1:1:Num_P1_Nodes)';
P1_Mesh_DoFmap = uint32([P1_Ind(1:end-1,1), P1_Ind(2:end,1)]); % NOTE! unsigned integer

P2_Extra_Ind = (1:1:Num_P1_Nodes-1)' + Num_P1_Nodes;
P2_Mesh_DoFmap = [P1_Mesh_DoFmap, P2_Extra_Ind];

P1_t = linspace(0,1,Num_P1_Nodes)';
mid_t = 0.5*(P1_t(P1_Ind(1:end-1),1) + P1_t(P1_Ind(2:end),1));
P2_t = [P1_t; mid_t];
% domain is a circle
X1 = sin(2*pi*P2_t);
Y1 = cos(2*pi*P2_t);
P2_Mesh_Nodes = [X1, Y1];
P1_Mesh_Nodes = P2_Mesh_Nodes(1:Num_P1_Nodes,:);
% END: define 1-D mesh

% define function spaces (i.e. the DoFmaps)
P0_DoFmap = (1:1:size(P1_Mesh_DoFmap,1))';
P0_DoFmap = uint32(P0_DoFmap);
%P1_DoFmap = P1_Mesh_DoFmap;
%P2_DoFmap = P2_Mesh_DoFmap;

% assemble
tic
FEM = feval(str2func(mexName),[],P1_Mesh_Nodes,P1_Mesh_DoFmap,[],[],P0_DoFmap);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_Mesh_Size_1D_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the P0 mass matrix should be close to the circumference of the circle.  Error is:');
sum(sum(FEM(1).MAT)) - 2*pi

disp('Project mesh size to a P0 function.');
Mesh_Size = full(FEM(1).MAT \ FEM(2).MAT);
% compute mesh size manually
Edge_Vec = P1_Mesh_Nodes(P1_Mesh_DoFmap(:,2),:) - P1_Mesh_Nodes(P1_Mesh_DoFmap(:,1),:);
Mesh_Size_Manual = sqrt(sum(Edge_Vec.^2,2));
Mesh_Size_Error = norm(Mesh_Size - Mesh_Size_Manual,inf);

disp('The error in computing the mesh size should be machine precision.  It is:')
Mesh_Size_Error

disp('The integral of mesh size should be h*(circumference of circle).  Error is:')
Int_Value = full(FEM(3).MAT(1,1));
Int_Value - Mesh_Size(1)*(2*pi)

figure;
p1 = plot(P1_Mesh_Nodes(:,1),P1_Mesh_Nodes(:,2),'b-*','LineWidth',2.0);
axis equal;
title('Circle Mesh');

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