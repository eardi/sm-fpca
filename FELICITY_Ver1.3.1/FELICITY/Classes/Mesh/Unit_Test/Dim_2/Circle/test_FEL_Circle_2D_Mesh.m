function [status, Mesh] = test_FEL_Circle_2D_Mesh()
%test_FEL_Circle_2D_Mesh
%
%   Test code for FELICITY class.

% Copyright (c) 01-01-2011,  Shawn W. Walker

% load mesh
current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);
Mesh_FN = fullfile(Current_Dir, 'circle_mesh.txt');
[Vtx, Tri] = Read_MeshGen_File_new(Mesh_FN);

% create a mesh object
Mesh = MeshTriangle(Tri,Vtx,'Circle');

% plot histogram of the "quality" of each simplex in the mesh
figure;
Mesh.Quality(10);
% "10" specifies the number of bins; "Qual" is a vector of quality values

% define a 0D subdomain of the circle mesh
Mesh = Mesh.Append_Subdomain('0D','Some Vertices',[3; 13; 8]);
% data representing subdomain can be accessed via:  Mesh.Subdomain(1).Data

% get the boundary edges of the mesh
Bdy_Edge = Mesh.freeBoundary;
% define a 1D subdomain of the circle mesh
Mesh = Mesh.Append_Subdomain('1D','Boundary Edges',Bdy_Edge);

% define a 2D subdomain of the circle mesh
Mesh = Mesh.Append_Subdomain('2D','Some Triangles',[1; 25; 15]);
% This is another way to append subdomains with equal topological dimension as
% the global mesh
Mesh = Mesh.Delete_Subdomain('Some Triangles');
Mesh = Mesh.Append_Subdomain('2D','Some Triangles',Mesh.ConnectivityList([1; 25; 15],:));

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
Mesh.Plot_Subdomain('Some Triangles');
Mesh.Plot_Subdomain('Boundary Edges');
Mesh.Plot_Subdomain('Some Vertices');
hold off;
title('Initial Mesh');

% uniformly refine the entire mesh by dividing each triangle into 4 triangles
Mesh = Mesh.Refine;
% reorder again
Mesh = Mesh.Reorder;

% plot everything again
figure;
Mesh.Plot;
hold on;
Mesh.Plot_Subdomain('Some Triangles');
Mesh.Plot_Subdomain('Boundary Edges');
Mesh.Plot_Subdomain('Some Vertices');
hold off;
title('After Uniform Refinement');

% load reference data
RefDataFileName = fullfile(Current_Dir,'test_Circle_2D_Mesh_DATA.mat');

% Mesh_REF = Mesh;
% save(RefDataFileName,'Mesh_REF');
load(RefDataFileName);

% run regression test
status = mesh_compare_routine(Mesh,Mesh_REF);

end