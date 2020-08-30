function status = FEL_Execute_Interp_BDM1_2D(mexName_DoF,mexName_Interp)
%FEL_Execute_Interp_BDM1_2D
%
%   test FELICITY Auto-Generated Interpolation Code.

% Copyright (c) 02-10-2013,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% get test mesh
[Omega_P1_Vtx, Omega_Tri] = Standard_Triangle_Mesh_Test_Data();
% domain is a square [0, 2] X [0, 2]
Mesh = MeshTriangle(Omega_Tri, Omega_P1_Vtx, 'Omega');
% refine
for ind = 1:0
    Mesh = Mesh.Refine;
end
% append the boundary as a subdomain
FBE = Mesh.freeBoundary;
Mesh = Mesh.Append_Subdomain('1D','Gamma',FBE);
% create edge orientation
Edges = Mesh.edges;
[Tri_Edge, Omega_Orient] = Mesh.Get_Facet_Info(Edges);
% a true entry means the local edge of the given triangle is contained in the
% Tri_Edge array; false means the *reversed* edge is in the Tri_Edge array.

% allocate DoFs
BDM1_DoFmap = feval(str2func(mexName_DoF),uint32(Mesh.ConnectivityList));
%Num_BDM1_Nodes = max(BDM1_DoFmap(:));

% create embedding data
DoE_Names = {'Gamma'; 'Omega'};
Omega_Mesh_Subdomains = Mesh.Generate_Subdomain_Embedding_Data(DoE_Names);

% BDM1 FE functions
F1 = @(X) [exp(-0.5*X(:,1).*X(:,2)), sin(pi*X(:,1).*X(:,2))];
v = Get_BDM1_Interpolant_of_Function(Mesh.Points,Mesh.ConnectivityList,BDM1_DoFmap,Omega_Orient,F1);

% exact interpolant functions
I_v = @(x,y) {exp(-0.5*x.*y);
              sin(pi*x.*y)};
%

% define the interpolation points
Cell_Omega_Indices = (1:1:Mesh.Num_Cell)';
% interpolate at the barycenter of reference triangle (on Omega)
Omega_Interp_Data = {uint32(Cell_Omega_Indices), (1/3) * ones(Mesh.Num_Cell,2)};
Omega_Interp_Pts = Mesh.referenceToCartesian(Cell_Omega_Indices, Omega_Interp_Data{2});

% define the interpolation points
Mesh_Gamma = Mesh.Output_Subdomain_Mesh('Gamma');
Cell_Gamma_Indices = (1:1:Mesh_Gamma.Num_Cell)';
% interpolate at the barycenter of reference edge (on Gamma)
Gamma_Interp_Data = {uint32(Cell_Gamma_Indices), (1/2) * ones(Mesh_Gamma.Num_Cell,1)};
Gamma_Interp_Pts = Mesh_Gamma.referenceToCartesian(Cell_Gamma_Indices, Gamma_Interp_Data{2});

% interpolate!
tic
INTERP = feval(str2func(mexName_Interp),Mesh.Points,uint32(Mesh.ConnectivityList),Omega_Orient,Omega_Mesh_Subdomains,...
                                        Gamma_Interp_Data,Omega_Interp_Data,BDM1_DoFmap,v);
toc
RefINTERPDataFileName = fullfile(Current_Dir,'FEL_Execute_Interp_BDM1_2D_REF_Data.mat');
% INTERP_REF = INTERP;
% save(RefINTERPDataFileName,'INTERP_REF');
load(RefINTERPDataFileName);

% compare the exact values with the interpolated ones
I_on_Gamma_exact = I_on_Gamma(Gamma_Interp_Pts(:,1),Gamma_Interp_Pts(:,2));
I_v_exact        = I_v(Omega_Interp_Pts(:,1),Omega_Interp_Pts(:,2));

% these errors satisfy the order of accuracy estimates when refining...
I_on_Gamma_err = max(abs(I_on_Gamma_exact - INTERP(1).DATA{1,1}));
I_v1_err = max(abs(I_v_exact{1,1} - INTERP(2).DATA{1,1}));
I_v2_err = max(abs(I_v_exact{2,1} - INTERP(2).DATA{2,1}));

disp(' ');
disp('L_inf errors for the interpolations:');
I_on_Gamma_err
I_v1_err
I_v2_err

status = 0; % init
% compare to reference data
for ind = 1:length(INTERP)
    [nr, nc] = size(INTERP(ind).DATA);
    for ir = 1:nr
        for ic = 1:nc
            ERROR = max(abs(INTERP(ind).DATA{ir,ic} - INTERP_REF(ind).DATA{ir,ic}));
            if (ERROR > 4e-15)
                disp(['Test Failed for INTERP(', num2str(ind), ').DATA...']);
                status = 1;
            end
        end
    end
end

end

function Exact = I_on_Gamma(x,y)

v1 = exp(-0.5*x.*y);
v2 = sin(pi*x.*y);

LEFT  = (x < 1e-10);
RIGHT = (x > (2-1e-10));
BOT   = (y < 1e-10);
TOP   = (y > (2-1e-10));

Exact = 0*x;
Exact(LEFT,1)  = -v1(LEFT,1);
Exact(RIGHT,1) =  v1(RIGHT,1);
Exact(BOT,1)   = -v2(BOT,1);
Exact(TOP,1)   =  v2(TOP,1);

end