function status = FEL_Execute_Mixed_Geometry_1(mexName)
%FEL_Execute_Mixed_Geometry_1
%
%   test FELICITY Auto-Generated Assembly Code.

% Copyright (c) 01-24-2014,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% get test mesh
[Gamma_Vtx, Gamma_Tri] = Standard_Triangle_Mesh_Test_Data();
Gamma_Vtx = [Gamma_Vtx, zeros(size(Gamma_Vtx,1),1)]; % make it in 3-D
Mesh = MeshTriangle(Gamma_Tri, Gamma_Vtx, 'Gamma');

% append the Sigma subdomain (edge of square along x-axis)
Mesh = Mesh.Append_Subdomain('1D','Sigma',[1, 2; 2, 3]);

% uniform refinement
for ind = 1:3
    Mesh = Mesh.Refine;
end

% deform mesh
X = Mesh.Points;
X(:,3) = X(:,1) .* X(:,2); % z = x*y
% domain is a square sheet that is deformed in the Z direction
Mesh = Mesh.Set_Points(X);
clear X;

% create embedding data
DoI_Names = {'Gamma'; 'Sigma'};
Subdomain_Embed = Mesh.Generate_Subdomain_Embedding_Data(DoI_Names);

Sigma_Mesh = Mesh.Output_Subdomain_Mesh('Sigma');
V_Space_DoFmap = uint32(Sigma_Mesh.ConnectivityList);
% note: the Nodes of this DoFmap correspond to the vertices of Sigma_Mesh
%V_Space_DoFmap

% assemble
tic
FEM = feval(str2func(mexName),[],Mesh.Points,uint32(Mesh.ConnectivityList),[],Subdomain_Embed,V_Space_DoFmap);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_Mixed_Geometry_1_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

%       OUTPUTS (in consecutive order) 
%       ---------------------------------------- 
%       Chi 
%       Mass_Matrix 

% make an L^2 projection of the normal vector of Gamma onto a piecewise linear
% vector function on Sigma
Num_V_Nodes = max(V_Space_DoFmap(:));
Proj_Normal = zeros(Num_V_Nodes,3);
Proj_Normal(:) = FEM(2).MAT \ FEM(1).MAT;

% compute the "exact" normal
Exact_Normal = zeros(Num_V_Nodes,3); % x-component is zero
XC = Sigma_Mesh.Points;
theta = atan2(XC(:,1),1);
Exact_Normal(:,2) = -sin(theta); % y-component
Exact_Normal(:,3) = cos(theta); % z-component

% compute the L^2 norm of the error
%   (approximately, since we are interpolating the exact solution)
disp('Compute difference between "exact" normal and the L^2(Sigma) projection.');
disp('L^2 error is:');
Normal_Error = Exact_Normal - Proj_Normal;
L2_Error = sqrt(Normal_Error(:)' * FEM(2).MAT * Normal_Error(:));
L2_Error

figure;
Mesh.Plot;
hold on;
Mesh.Plot_Subdomain('Sigma');
quiver3(XC(:,1),XC(:,2),XC(:,3),Proj_Normal(:,1),Proj_Normal(:,2),Proj_Normal(:,3),'b');
hold off;
AX = [-0.5 2.5 -0.5 2.5 -0.5 4.5];
axis(AX);
title('Black edge denotes Sigma.  Blue arrows denote normal vector (of Gamma) on Sigma.');

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