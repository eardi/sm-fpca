function status = FEL_Execute_Multiple_Subdomain_Embed_Dim_2(mexName)
%FEL_Execute_Multiple_Subdomain_Embed_Dim_2
%
%   test FELICITY Auto-Generated Assembly Code.

% Copyright (c) 06-25-2012,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% get test mesh
[Global_Vtx, Global_Tri] = Standard_Triangle_Mesh_Test_Data();
Mesh = MeshTriangle(Global_Tri, Global_Vtx, 'Global');
% domain is a square [0, 2] X [0, 2]

% define subdomains
Mesh = Mesh.Append_Subdomain('2D','Omega',(9:1:16)');
Mesh = Mesh.Append_Subdomain('2D','Omega_1',[9; 10; 11; 12]);
Mesh = Mesh.Append_Subdomain('2D','Omega_2',[13; 14; 15; 16]);
Mesh = Mesh.Append_Subdomain('1D','Gamma',[7, 12]);
% uniform refinement
for ind = 1:1
    Mesh = Mesh.Refine;
end

% create embedding data
DoI_Names = {'Gamma'; 'Omega'};
Subdomain_Embed = Mesh.Generate_Subdomain_Embedding_Data(DoI_Names);

Omega_Mesh = Mesh.Output_Subdomain_Mesh('Omega');
U_Space_DoFmap = uint32(Omega_Mesh.ConnectivityList);
%U_Space_DoFmap

Omega_1_Mesh = Mesh.Output_Subdomain_Mesh('Omega_1');
V1_Space_DoFmap = uint32(Omega_1_Mesh.ConnectivityList);
%V1_Space_DoFmap

Omega_2_Mesh = Mesh.Output_Subdomain_Mesh('Omega_2');
V2_Space_DoFmap = uint32(Omega_2_Mesh.ConnectivityList);
%V2_Space_DoFmap

Gamma_Mesh = Mesh.Output_Subdomain_Mesh('Gamma');
M_Space_DoFmap = uint32(Gamma_Mesh.ConnectivityList);
%M_Space_DoFmap

old_soln_Values = Omega_Mesh.Points(:,1); % the function x
my_mu     = Gamma_Mesh.Points(:,2).^3; % y^3
my_lambda = sin(pi*Gamma_Mesh.Points(:,2));   % sin(pi*y)
my_v1     = sin(pi*Omega_1_Mesh.Points(:,2)); % sin(pi*y)
my_v2     = sin(pi*Omega_2_Mesh.Points(:,2)); % sin(pi*y)
my_v      = Omega_Mesh.Points(:,1).*Omega_Mesh.Points(:,2); % x*y

% assemble
tic
FEM = feval(str2func(mexName),[],Mesh.Points,uint32(Mesh.ConnectivityList),[],Subdomain_Embed,M_Space_DoFmap,U_Space_DoFmap,...
                                 V1_Space_DoFmap,V2_Space_DoFmap,old_soln_Values);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_Multiple_Subdomain_Embed_Dim_2_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the bulk matrix should be the area of the rectangle.  Error is:');
sum(sum(FEM(4).MAT)) - (2)

disp('Summing the mass matrix should be the length of \Gamma.  Error is:');
sum(sum(FEM(6).MAT)) - (1)

disp('Integrating sin(pi*y)*sin(pi*y) on \Omega_1 or \Omega_2 (restricted to \Gamma) should give the same answer.  Error is:');
(my_v1' * FEM(1).MAT * my_lambda) - (my_v2' * FEM(2).MAT * my_lambda)

disp('Integrating x * (grad(x*y).N) d/ds (s^3) should give (45/4).  Error is:');
(my_v' * FEM(3).MAT * my_mu) - (45/4)

disp('Integrating sin(pi*y) over \Gamma is -2/pi.  Error is:');
other_v = sin(pi*Omega_Mesh.Points(:,2)); % sin(pi*y)
(other_v' * FEM(7).MAT) - (-2/pi)

disp('Integrating X[1] over \Gamma is 1.  Error is:');
FEM(5).MAT(1,1) - (1)

disp('Integrating X[2] over \Gamma is (3/2).  Error is:');
FEM(5).MAT(2,1) - (3/2)

% figure;
% p1 = trimesh(Omega_Tri,Omega_P1_Vtx(:,1),Omega_P1_Vtx(:,2),0*old_soln_Values(:,1));
% view(2);
% shading interp;
% set(p1,'edgecolor','k'); % make mesh black
% hold on;
% plot(Gamma_P1_Vtx(:,1),Gamma_P1_Vtx(:,2),'m','LineWidth',2.5);
% hold off;
% axis equal
% title('Omega Mesh with Gamma Boundary in magenta');

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