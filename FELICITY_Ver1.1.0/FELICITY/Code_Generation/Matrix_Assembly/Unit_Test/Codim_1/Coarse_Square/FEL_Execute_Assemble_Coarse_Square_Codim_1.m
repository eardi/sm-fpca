function status = FEL_Execute_Assemble_Coarse_Square_Codim_1(mexName)
%FEL_Execute_Assemble_Coarse_Square_Codim_1
%
%   test FELICITY Auto-Generated Assembly Code.

% Copyright (c) 06-25-2012,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% get test mesh
[Omega_P1_Vtx, Omega_Tri] = Standard_Triangle_Mesh_Test_Data();
P1_DoFmap = uint32(Omega_Tri);
U_Space_DoFmap = P1_DoFmap;
% domain is a square [0, 2] X [0, 2]

% BEGIN: define subdomain of codim = 1
Codim_1_Data = int32(...
    [ 2, 3;
      6, 3;
      6, 1;
      8, -2;
     10, 1;
     12, -1;
     12, -3;
     16, -1]);
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

% global edge defn of Gamma
Gamma_Edges = [ 1  2;
                2  3;
                3  5;
                5  7;
                7  9;
                9 11;
               11 12;
               12 13];
%

% Gamma vertex coordinates
Gamma_P1_Nodes   = unique(Gamma_Edges(:));
Gamma_P1_Vtx     = Omega_P1_Vtx(Gamma_P1_Nodes,:);
Gamma_Edge_Mid_Vtx = 0.5*(Omega_P1_Vtx(Gamma_Edges(:,1),:) + Omega_P1_Vtx(Gamma_Edges(:,2),:));

% construct P2 DoFmap on Gamma
Gamma_Num_P1_Nodes = length(Gamma_P1_Nodes);
Gamma_P1_Ind = (1:1:Gamma_Num_P1_Nodes)';
Gamma_P1_DoFmap = uint32([Gamma_P1_Ind(1:end-1,1), Gamma_P1_Ind(2:end,1)]); % NOTE! unsigned integer
P2_Extra_Ind = (1:1:size(Gamma_Edges,1))' + Gamma_Num_P1_Nodes;
M_Space_DoFmap = [Gamma_P1_DoFmap, P2_Extra_Ind];
% END: define subdomain of codim = 1

% define external coefficient functions
my_v = Omega_P1_Vtx(:,1) + Omega_P1_Vtx(:,2); % x + y

my_mu           = zeros(max(M_Space_DoFmap(:)),1); % init
% set mu(x,y) = s (arc-length) along Gamma (zig-zag curve)
P1_Seg_1 = Gamma_P1_Vtx(:,2) < 0.001;
P1_Seg_3 = Gamma_P1_Vtx(:,2) > 1.999;
P1_Seg_2 = ~P1_Seg_1 & ~P1_Seg_3;
my_mu(P1_Seg_1,1) = Gamma_P1_Vtx(P1_Seg_1,1);
my_mu(P1_Seg_2,1) = 2 + sqrt((Gamma_P1_Vtx(P1_Seg_2,1) - 2).^2 + (Gamma_P1_Vtx(P1_Seg_2,2) - 0).^2);
my_mu(P1_Seg_3,1) = (2 + 2*sqrt(2)) + Gamma_P1_Vtx(P1_Seg_3,1);
P2_Mid_Seg_1 = Gamma_Edge_Mid_Vtx(:,2) < 0.001;
P2_Mid_Seg_3 = Gamma_Edge_Mid_Vtx(:,2) > 1.999;
P2_Mid_Seg_2 = ~P2_Mid_Seg_1 & ~P2_Mid_Seg_3;
false_P1 = false(Gamma_Num_P1_Nodes,1);
mu_P2_Mid_Seg_1 = [false_P1; P2_Mid_Seg_1];
mu_P2_Mid_Seg_2 = [false_P1; P2_Mid_Seg_2];
mu_P2_Mid_Seg_3 = [false_P1; P2_Mid_Seg_3];
my_mu(mu_P2_Mid_Seg_1,1) = Gamma_Edge_Mid_Vtx(P2_Mid_Seg_1,1);
my_mu(mu_P2_Mid_Seg_2,1) = 2 + sqrt((Gamma_Edge_Mid_Vtx(P2_Mid_Seg_2,1) - 2).^2 + (Gamma_Edge_Mid_Vtx(P2_Mid_Seg_2,2) - 0).^2);
my_mu(mu_P2_Mid_Seg_3,1) = (2 + 2*sqrt(2)) + Gamma_Edge_Mid_Vtx(P2_Mid_Seg_3,1);

% set vector function on Gamma
my_vec = 0.5*(Gamma_P1_Vtx(:).^2);

old_soln_Values = Omega_P1_Vtx(:,1); % the function x

% assemble
tic
FEM = feval(str2func(mexName),[],Omega_P1_Vtx,P1_DoFmap,[],Subdomain_Embed,M_Space_DoFmap,U_Space_DoFmap,...
                                 Gamma_P1_DoFmap,old_soln_Values);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_Assemble_Coarse_Square_Codim_1.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the P2 mass matrix should be the length of the zig-zag curve.  Error is:');
sum(sum(FEM(3).MAT)) - (4 + 2*sqrt(2))

disp('Integrating the arc-length squared (i.e. \int s^2 ds).  Error is:');
(my_mu' * FEM(3).MAT * my_mu) - (1/3)*(4 + 2*sqrt(2))^3

disp('Summing the mixed boundary "mass" matrix should be the length of the zig-zag curve.  Error is:');
sum(sum(FEM(1).MAT)) - (4 + 2*sqrt(2))

disp('Integrating (x+y)*s over the zig-zag curve.  Error is:');
b = 4 + 2*sqrt(2);
a = 2 + 2*sqrt(2);
ANSWER = (8/3) + (8 + 8*sqrt(2)) + (1/3)*(b^3 - a^3) - sqrt(2) * (b^2 - a^2);
(my_v' * FEM(1).MAT * my_mu) - ANSWER

disp('Integrating exp(x/4)*exp(y/5) over the zig-zag curve.  Error is (~ 3.9422E-002):');
v2 = exp(Omega_P1_Vtx(:,1)/4);
mu2 = 0*my_mu;
mu2(1:Gamma_Num_P1_Nodes,1) = exp(Gamma_P1_Vtx(:,2)/5);
mu2(P2_Extra_Ind,1) = exp(Gamma_Edge_Mid_Vtx(:,2)/5);
ANS1 = 4*(exp(0.5) - 1) + exp(0.5)*(20*sqrt(2))*(1 - exp(-0.1)) + exp(2/5)*4*(exp(0.5) - 1);
(v2' * FEM(1).MAT * mu2) - ANS1

disp('Summing the boundary vector should be 0.  Error is:');
sum(sum(FEM(2).MAT)) - 0

disp('Computing the integral of d/dx (x) * d/ds (s) gives the length of the zig-zag curve.  Error is:');
my_mu' * FEM(2).MAT - (4 + 2*sqrt(2))

disp('Computing the integral of |d/ds 0.5*(x^2,y^2)|^2 gives (16 + 8 * sqrt(2))/3.  Error is (~ -3.9226E-001):');
my_vec' * FEM(5).MAT * my_vec - ((16 + 8*sqrt(2))/3)

disp('Computing the integral of X[1] over the zig-zag curve.  Error is:');
FEM(4).MAT(1,1) - (4 + 2*sqrt(2))

disp('Integrating sin(X[1]) over the zig-zag curve.  Error is:');
FEM(4).MAT(2,1) - (2 + sqrt(2))*(1 - cos(2))

disp('Integrating N dot (1,1) over the zig-zag curve gives 0.  Error is:');
FEM(4).MAT(1,2) - 0

disp('Integrating T dot N over the zig-zag curve gives 0.  Error is:');
FEM(4).MAT(2,2) - 0

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