function status = FEL_Execute_Multiple_Subdomain_Embed_Dim_1(mexName)
%FEL_Execute_Multiple_Subdomain_Embed_Dim_1
%
%   test FELICITY Auto-Generated Assembly Code.

% Copyright (c) 06-26-2012,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% get test mesh
[Global_Vtx, Global_Edge] = Standard_Edge_Mesh_Test_Data();
Mesh = MeshInterval(Global_Edge, Global_Vtx, 'Global');
% domain is interval [0, 9]

% define subdomains
Mesh = Mesh.Append_Subdomain('1D','Omega',(2:1:9)');
Mesh = Mesh.Append_Subdomain('1D','Omega_1',[2;3;4;5]);
Mesh = Mesh.Append_Subdomain('1D','Omega_2',[6;7;8;9]);
% uniform refinement
for ind = 1:3
    Mesh = Mesh.Refine;
end

% create embedding data
DoI_Names = {'Omega'; 'Omega_1'; 'Omega_2'};
Subdomain_Embed = Mesh.Generate_Subdomain_Embedding_Data(DoI_Names);

Omega_Mesh = Mesh.Output_Subdomain_Mesh('Omega');
U_Space_DoFmap = uint32(Omega_Mesh.ConnectivityList);
%U_Space_DoFmap

Omega_1_Mesh = Mesh.Output_Subdomain_Mesh('Omega_1');
M_Space_DoFmap = uint32(Omega_1_Mesh.ConnectivityList);
%M_Space_DoFmap

my_lambda = sin(pi*Omega_1_Mesh.Points(:,1)); % sin(pi*x)
my_u      = Omega_Mesh.Points(:,1).^3; % x^3

% assemble
tic
FEM = feval(str2func(mexName),[],Mesh.Points,uint32(Mesh.ConnectivityList),[],Subdomain_Embed,M_Space_DoFmap,U_Space_DoFmap);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_Multiple_Subdomain_Embed_Dim_1_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the stiffness matrix should be zero.  Error is:');
sum(sum(FEM(3).MAT)) - (0)

disp('Integrating x^3 * sin(pi*x) should give (3.869638906039327E+01).  Error is:');
(my_u' * FEM(1).MAT * my_lambda) - (3.869638906039327E+01)

disp('Solve the (WEIGHTED) Laplace equation with Dirichlet conditions:');
disp('----> set u=0 at the left and right.');
Soln = zeros(size(FEM(3).MAT,1),1); % init
RHS = FEM(2).MAT;
A   = FEM(3).MAT;
disp('Right-hand-side is (f = -1)');
disp('Use backslash to solve (impose Dirichlet condition at s=0):');
FreeNodes = setdiff((1:1:length(Soln))',[4,9]);
Soln(FreeNodes,1) = A(FreeNodes,FreeNodes) \ RHS(FreeNodes,1);

figure;
TEMP = [Omega_Mesh.Points, (1:1:length(Omega_Mesh.Points))'];
SX = sortrows(TEMP,1);
PV = SX(:,2);
h1 = plot(Omega_Mesh.Points(PV,1),Soln(PV,1),'b-','LineWidth',2.0);
title('Solution of PDE: -d/dx (a(x) d/dx u) = -1, u(1) = u(9) = 0','FontSize',14);
xlabel('x (domain Omega = [1, 9])','FontSize',14);
ylabel('u (solution value)','FontSize',14);
set(gca,'FontSize',14);
axis([1 9 -3 0]);
axis equal;
axis([1 9 -3 0]);

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