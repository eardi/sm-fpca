function [status, Mesh] = test_FEL_Square_2D_Mesh()
%test_FEL_Square_2D_Mesh
%
%   Test code for FELICITY class.

% Copyright (c) 01-01-2011,  Shawn W. Walker

% define simple square mesh
Vtx = [0 0; 1 0; 1 1; 0 1]; % coordinates
Tri = [1 2 3; 3 4 1];       % triangle connectivity

% create a mesh object
Mesh = MeshTriangle(Tri,Vtx,'Square');

% plot histogram of the "quality" of each simplex in the mesh
figure;
Qual = Mesh.Quality(5);
% "5" specifies the number of bins; "Qual" is a vector of quality values

% define a 0D subdomain of the square mesh
Mesh = Mesh.Append_Subdomain('0D','Upper Right Vtx',[3]);
% data representing subdomain can be accessed via:  Mesh.Subdomain(1).Data

% get the boundary edges of the mesh
Bdy_Edge = Mesh.freeBoundary;
% define a 1D subdomain of the square mesh
Mesh = Mesh.Append_Subdomain('1D','Boundary',Bdy_Edge);

% define a 2D subdomain of the square mesh
Mesh = Mesh.Append_Subdomain('2D','Lower Right Tri',[1]);

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
Mesh.Plot_Subdomain('Lower Right Tri');
Mesh.Plot_Subdomain('Boundary');
Mesh.Plot_Subdomain('Upper Right Vtx');
hold off;
title('Initial Mesh');

% uniformly refine the entire mesh by dividing each triangle into 4 triangles
Mesh = Mesh.Refine;
% reorder again
Mesh = Mesh.Reorder;
% refine again
Mesh = Mesh.Refine;
% reorder again
Mesh = Mesh.Reorder;

% plot everything again
figure;
Mesh.Plot;
hold on;
Mesh.Plot_Subdomain('Lower Right Tri');
Mesh.Plot_Subdomain('Boundary');
Mesh.Plot_Subdomain('Upper Right Vtx');
hold off;
title('After Uniform Refinement');

% load reference data
current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);
RefDataFileName = fullfile(Current_Dir,'test_Square_2D_Mesh_DATA.mat');

% Mesh_REF = Mesh;
% save(RefDataFileName,'Mesh_REF');
load(RefDataFileName);

% run regression test
status = mesh_compare_routine(Mesh,Mesh_REF);

end