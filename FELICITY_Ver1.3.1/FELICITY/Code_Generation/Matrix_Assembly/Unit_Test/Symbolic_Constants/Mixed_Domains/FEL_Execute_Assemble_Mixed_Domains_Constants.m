function status = FEL_Execute_Assemble_Mixed_Domains_Constants(mexName)
%FEL_Execute_Assemble_Mixed_Domains_Constants
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 01-22-2018,  Shawn W. Walker

% simple mesh
[Tet, Vtx] = regular_tetrahedral_mesh(3,3,3);
MT = MeshTetrahedron(Tet,Vtx,'Omega');
clear Tet Vtx;

% add in the boundary \Gamma
FB = MT.freeBoundary();
MT = MT.Append_Subdomain('2D','Gamma',FB);
clear FB;

% get sub-domain embedding
Embed = MT.Generate_Subdomain_Embedding_Data({'Omega', 'Gamma'});

% Degree-of-Freedom map
P1_DoFmap = uint32(MT.ConnectivityList);

% set coefficient functions
c0_val = pi*[-1, 1, 2];

% assemble
tic
FEM = feval(mexName,[],MT.Points,P1_DoFmap,[],Embed,c0_val);
toc

Surf_Area_Gamma = 6;
Exact_Val = c0_val(1) * Surf_Area_Gamma;
%Exact_Val

% do some checks!
ERR_CHK1 = abs(FEM(1).MAT - FEM(2).MAT(1,1));
ERR_CHK1

ERR_CHK2 = abs(Exact_Val - FEM(1).MAT);
ERR_CHK2

status = 0; % init
% error check
if (max([ERR_CHK1, ERR_CHK2]) > 1e-13)
    disp(['Test Failed!']);
    status = 1;
end

end