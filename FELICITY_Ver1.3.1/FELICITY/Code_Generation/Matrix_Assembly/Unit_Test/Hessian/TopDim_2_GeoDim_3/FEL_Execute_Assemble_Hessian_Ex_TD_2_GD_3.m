function status = FEL_Execute_Assemble_Hessian_Ex_TD_2_GD_3(mexName)
%FEL_Execute_Assemble_Hessian_Ex_TD_2_GD_3
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 08-14-2014,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% get mesh of unit disk at origin
Center = [0, 0];
Radius = 1;
Refine_Level = 4;
[TRI, VTX] = triangle_mesh_of_disk(Center,Radius,Refine_Level);
VTX = [VTX, 0*VTX(:,1)];
Mesh = MeshTriangle(TRI,VTX,'Gamma');
BE = Mesh.freeBoundary;
Mesh = Mesh.Append_Subdomain('1D','Bdy',BE);
P1_Mesh_DoFmap = uint32(Mesh.ConnectivityList);
P2_DoFmap = uint32(Setup_Lagrange_P2_DoFmap(Mesh.ConnectivityList,[]));
P1_Node_Indices = P2_DoFmap(:,1:3);
P1_Node_Indices = unique(P1_Node_Indices(:));

% define function spaces (i.e. the DoFmaps)
Ref_P2_Elem = ReferenceFiniteElement(lagrange_deg2_dim2);
Space = FiniteElementSpace('Vector_P2',Ref_P2_Elem,Mesh,'Gamma',3);
Space = Space.Set_DoFmap(Mesh,P2_DoFmap);
%Space.max_dof
P2_Mesh_Nodes  = Space.Get_DoF_Coord(Mesh);
P2_Mesh_DoFmap = P2_DoFmap;

% project P2 boundary nodes to boundary of disk
Bdy_DoFs  = Space.Get_DoFs_On_Subdomain(Mesh,'Bdy');
Bdy_Nodes_2D = P2_Mesh_Nodes(Bdy_DoFs,1:2);
MAG1 = sqrt(sum(Bdy_Nodes_2D.^2,2));
Bdy_Nodes_2D(:,1) = Bdy_Nodes_2D(:,1) ./ MAG1;
Bdy_Nodes_2D(:,2) = Bdy_Nodes_2D(:,2) ./ MAG1;
P2_Mesh_Nodes(Bdy_DoFs,1:2) = Bdy_Nodes_2D;

% now define \Gamma to be a paraboloid
P2_Mesh_Nodes(:,3) = 1 - (P2_Mesh_Nodes(:,1).^2 + P2_Mesh_Nodes(:,2).^2);
P1_Mesh_Nodes = P2_Mesh_Nodes(P1_Node_Indices,:);
Mesh = Mesh.Set_Points(P1_Mesh_Nodes);

% define coefficient functions
% r^2 = x^2 + y^2
% x = r*cos(theta);
% y = r*sin(theta);
r = sqrt(P2_Mesh_Nodes(:,1).^2 + P2_Mesh_Nodes(:,2).^2);
% [(x.^2)*(y.^2), y*exp(-r), 0]
Vector_Values = [( (P2_Mesh_Nodes(:,1).^2) .* (P2_Mesh_Nodes(:,2).^2) ),...
                  P2_Mesh_Nodes(:,2).*exp(-r),...
                  0*P2_Mesh_Nodes(:,2)];
%

% assemble
tic
FEM = feval(str2func(mexName),[],P2_Mesh_Nodes,P2_Mesh_DoFmap,[],[],...
                              Space.DoFmap,Vector_Values);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_Assemble_Hessian_Ex_TD_2_GD_3_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the rows of the vector hessian matrix and dsds matrix should be the same!');
disp('        And close to zero.  Max error is:');
max(abs(sum(FEM(2).MAT,2))) - 0

disp('Compute integrals of the hessian of known functions and compare to true values.  Relative error is:');
V1 = 7.92791762080085;
REL_ERR = (Vector_Values(:)' * FEM(2).MAT * Vector_Values(:) - V1) / V1;
REL_ERR

disp('Compute the error in the integral of trace(hess(Vec(1))).  Error is:')
FEM(1).MAT - (1.40496294807229)

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