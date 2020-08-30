function status = FEL_Execute_Multiple_Subdomain_Embed_Dim_3(mexName)
%FEL_Execute_Multiple_Subdomain_Embed_Dim_3
%
%   test FELICITY Auto-Generated Assembly Code.

% Copyright (c) 06-28-2012,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% get test mesh
[Global_Vtx, Global_Tet] = Standard_Tet_Mesh_Test_Data();
Mesh = MeshTetrahedron(Global_Tet, Global_Vtx, 'Global');
% domain is a pyramid

% define subdomains
Mesh = Mesh.Append_Subdomain('3D','Omega',[3;4]);
Mesh = Mesh.Append_Subdomain('3D','Omega_1',[3]);
Mesh = Mesh.Append_Subdomain('3D','Omega_2',[4]);
Mesh = Mesh.Append_Subdomain('2D','Gamma',[3 6 5; 1 5 6]);
Mesh = Mesh.Append_Subdomain('1D','Sigma',[5, 6]);

% create embedding data
DoI_Names = {'Omega'; 'Omega_1'; 'Omega_2'; 'Gamma'; 'Sigma'};
Subdomain_Embed = Mesh.Generate_Subdomain_Embedding_Data(DoI_Names);

Omega_Mesh = Mesh.Output_Subdomain_Mesh('Omega');
U_Space_DoFmap = uint32(Omega_Mesh.ConnectivityList);
%U_Space_DoFmap

Gamma_Mesh = Mesh.Output_Subdomain_Mesh('Gamma');
M_Space_DoFmap = uint32(Gamma_Mesh.ConnectivityList);
%M_Space_DoFmap

Sigma_Mesh = Mesh.Output_Subdomain_Mesh('Sigma');
E_Space_DoFmap = uint32(Sigma_Mesh.ConnectivityList);
%E_Space_DoFmap

my_v  = Omega_Mesh.Points(:,1) + Omega_Mesh.Points(:,2) + Omega_Mesh.Points(:,3);   % x + y + z
my_u  = 2*Omega_Mesh.Points(:,3) - Omega_Mesh.Points(:,1) + Omega_Mesh.Points(:,2); % 2z - x + y
my_p  = (1/sqrt(2))*(Gamma_Mesh.Points(:,1) + Gamma_Mesh.Points(:,2)) - Gamma_Mesh.Points(:,3); % (1/sqrt(2)) * (x + y) - z
my_q1 = Gamma_Mesh.Points(:,1) - Gamma_Mesh.Points(:,2); % x - y
my_q2 = Gamma_Mesh.Points(:,3); % z
my_lam = Sigma_Mesh.Points(:,1).*Sigma_Mesh.Points(:,2).*Sigma_Mesh.Points(:,3); % x*y*z
old_soln_values = Omega_Mesh.Points(:,1).*Omega_Mesh.Points(:,2).*Omega_Mesh.Points(:,3); % the function x*y*z

% assemble
tic
FEM = feval(str2func(mexName),[],Mesh.Points,uint32(Mesh.ConnectivityList),[],Subdomain_Embed,...
                                 E_Space_DoFmap,M_Space_DoFmap,U_Space_DoFmap,old_soln_values);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_Multiple_Subdomain_Embed_Dim_3_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the stiffness matrix should be zero.  Error is:');
sum(sum(FEM(4).MAT)) - (0)

disp('Summing the weigted mass matrix should be (1/4).  Error is:');
sum(sum(FEM(5).MAT)) - (1/4)

BASE = 1;
HEIGHT = 1;
Vol_Omega = (1/2) * (BASE * HEIGHT * (1/3));
disp('Integrating grad(x+y+z).grad(2z-x+y) on \Omega should give (2 * Vol(\Omega)).  Error is:');
(my_v' * FEM(4).MAT * my_u) - (2*Vol_Omega)

disp('Integrating v.u with weighted mass matrix should give (0.2375).  Error is:');
(my_v' * FEM(5).MAT * my_u) - (0.2375)

disp('Integrating grad(v).surf_grad(p) on \Gamma should give ( (sqrt(2)-1)/sqrt(2) ).  Error is:');
(my_v' * FEM(1).MAT * my_p) - ((sqrt(2)-1)/sqrt(2))

disp('Integrating surf_grad(q1).tan d/ds(\lambda) on \Sigma should give zero.  Error is:');
(my_q1' * FEM(3).MAT * my_lam) - (0)

disp('Integrating surf_grad(q2).tan d/ds(\lambda) on \Sigma should give (1/4).  Error is:');
(my_q2' * FEM(3).MAT * my_lam) - (1/4)

disp('Integrating x*y*z over \Sigma should give (1/8).  Error is:');
FEM(2).MAT(1,1) - (1/8)

figure;
subplot(2,2,1);
Mesh.Plot;
AZ = -15;
EL = 15;
view(AZ,EL);
AX = [0 1 0 1 0 1];
axis equal;
axis(AX);

subplot(2,2,2);
Mesh.Plot_Subdomain('Omega');
view(AZ,EL);
AX = [0 1 0 1 0 1];
axis equal;
axis(AX);
title('Subdomain \Omega');

subplot(2,2,3);
Mesh.Plot_Subdomain('Gamma');
view(AZ,EL);
AX = [0 1 0 1 0 1];
axis equal;
axis(AX);
title('Subdomain \Gamma in red');

subplot(2,2,4);
p1 = Mesh.Plot_Subdomain('Sigma');
set(p1,'Color','m');
view(AZ,EL);
AX = [0 1 0 1 0 1];
axis equal;
axis(AX);
title('Subdomain \Sigma in magenta');

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