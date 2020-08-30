function [status, Mesh] = test_FEL_Cube_3D_Mesh()
%test_FEL_Cube_3D_Mesh
%
%   Test code for FELICITY class.

% Copyright (c) 01-01-2011,  Shawn W. Walker

% define simple mesh of unit cube (6 tets)
[Tet, Vtx] = regular_tetrahedral_mesh(2,2,2);

% create a mesh object
Mesh = MeshTetrahedron(Tet,Vtx,'Cube');

% plot histogram of the "quality" of each simplex in the mesh
figure;
Qual = Mesh.Quality(5);
% "5" specifies the number of bins; "Qual" is a vector of quality values

% define a 0D subdomain of the cube mesh
Mesh = Mesh.Append_Subdomain('0D','Some Vertices',[1; 8; 5]);
% data representing subdomain can be accessed via:  Mesh.Subdomain(1).Data

% define a 1D subdomain of edges in the cube mesh
Bdy_Edge = [5 8; 1 7; 7 5];
Mesh = Mesh.Append_Subdomain('1D','Some Edges',Bdy_Edge);

% get the boundary faces of the mesh
Faces = Mesh.freeBoundary;
% define a 2D subdomain of the cube mesh
Mesh = Mesh.Append_Subdomain('2D','Boundary Faces',Faces);

% define a 3D subdomain of the cube mesh
Mesh = Mesh.Append_Subdomain('3D','Some Tets',[1; 6; 2]);
% This is another way to append subdomains with equal topological dimension as
% the global mesh
Mesh = Mesh.Delete_Subdomain('Some Tets');
Mesh = Mesh.Append_Subdomain('3D','Some Tets',Mesh.ConnectivityList([1; 6; 2],:));

% reorder the nodes of the mesh automatically
% note: this will NOT affect the subdomains
Mesh = Mesh.Reorder;

% display info about Mesh
display(Mesh); % you can also just type: >> Mesh <ENTER>

% plot the mesh
figure;
Mesh.Plot;

% add plots of the subdomains
hold on;
Mesh.Plot_Subdomain('Some Edges');
Mesh.Plot_Subdomain('Some Vertices');
hold off;
title('Initial Mesh');
figure;
Mesh.Plot_Subdomain('Boundary Faces');
figure;
Mesh.Plot_Subdomain('Some Tets');

% preliminary testing of outputting self-contained subdomain meshes
Mesh_Edge = Mesh.Output_Subdomain_Mesh('Some Edges');
FE = figure;
Mesh_Edge.Plot;
Mesh_Face = Mesh.Output_Subdomain_Mesh('Boundary Faces');
FF = figure;
Mesh_Face.Plot;
Mesh_Tets = Mesh.Output_Subdomain_Mesh('Some Tets');
FT = figure;
Mesh_Tets.Plot;
close(FE);
close(FF);
close(FT);

% % plot everything again
% figure;
% Mesh.Plot;
% hold on;
% Mesh.Plot_Subdomain('Some Edges');
% Mesh.Plot_Subdomain('Some Vertices');
% hold off;
% title('After Uniform Refinement');
% figure;
% Mesh.Plot_Subdomain('Boundary Faces');
% title('After Uniform Refinement');
% figure;
% Mesh.Plot_Subdomain('Some Tets');
% title('After Uniform Refinement');

% load reference data
current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);
RefDataFileName = fullfile(Current_Dir,'test_Cube_3D_Mesh_DATA.mat');

% Mesh_REF = Mesh;
% save(RefDataFileName,'Mesh_REF');
load(RefDataFileName);

% run regression test
status = mesh_compare_routine(Mesh,Mesh_REF);

end