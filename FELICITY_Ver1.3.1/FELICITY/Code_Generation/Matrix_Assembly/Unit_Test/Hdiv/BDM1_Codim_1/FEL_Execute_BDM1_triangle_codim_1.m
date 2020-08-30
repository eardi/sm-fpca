function status = FEL_Execute_BDM1_triangle_codim_1(mexName_DoF,mexName_assembly)
%FEL_Execute_BDM1_triangle_codim_1
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 05-21-2013,  Shawn W. Walker

% current_file = mfilename('fullpath');
% Current_Dir  = fileparts(current_file);

% BEGIN: create mesh

% get standard example mesh
[Vtx, Tri] = Standard_Triangle_Mesh_Test_Data();
% domain is a square [0, 2] X [0, 2]

MT = MeshTriangle(Tri,Vtx,'Box');
Omega_Tri_Indices = [1; 2; 3; 4; 9; 10; 11; 12];
MT = MT.Append_Subdomain('2D','Omega',Omega_Tri_Indices);
MT = MT.Append_Subdomain('1D','Gamma',[2 7; 7 12]);

MT = MT.Refine;
MT = MT.Refine;

Edges = MT.edges;
[Box_Edge, Box_Orient] = MT.Get_Facet_Info(Edges);
% a true entry means the local edge of the given triangle is contained in the
% Tri_Edge array; false means the *reversed* edge is in the Tri_Edge array.
% END: create mesh

%Omega_Tri = uint32(MT.Get_Global_Subdomain('Omega'));
Omega_Tri_Indices = MT.Subdomain(1).Data;

Omega_Mesh = MT.Output_Subdomain_Mesh('Omega');
Omega_Tri = uint32(Omega_Mesh.ConnectivityList);

% BEGIN: define some stuff

% allocate DoFs
tic
BDM1_DoFmap = feval(str2func(mexName_DoF),Omega_Tri);
toc

F1 = @(X) [1 + 0*X(:,1), 0*X(:,2)];
ff_VEC = Get_BDM1_Interpolant_of_Function(Omega_Mesh.Points,Omega_Tri,BDM1_DoFmap,Box_Orient(Omega_Tri_Indices,:),F1);

% create embedding data
DoI_Names = {'Box', 'Omega', 'Gamma'};
Subdomain_Embed = MT.Generate_Subdomain_Embedding_Data(DoI_Names);
% END: define some stuff

% assemble
tic
FEM = feval(str2func(mexName_assembly),[],MT.Points,uint32(MT.ConnectivityList),Box_Orient,Subdomain_Embed,BDM1_DoFmap);
toc

NV = FEM(1).MAT;

Int_Value = ff_VEC' * NV;
ERR1 = abs(Int_Value - 2);
%ERR1

status = 0; % init
if (ERR1 > 4e-15)
    disp(['Test Failed for NV matrix...']);
    status = 1;
end

end