function [status, Mesh] = test_FEL_Curve_1D_Mesh()
%test_FEL_Curve_1D_Mesh
%
%   Test code for FELICITY class.

% Copyright (c) 01-01-2011,  Shawn W. Walker

% define simple mesh on unit interval
Vtx     = (0:0.2:1)';
Num_Vtx = length(Vtx);
Vtx_Ind = (1:1:Num_Vtx)';
Edges   = [Vtx_Ind(1:end-1,1), Vtx_Ind(2:end,1)];

% create a mesh object
Mesh = MeshInterval(Edges,Vtx,'Curve');

% redfine the vertex coordinates to have a "y" dimension
Y = (Vtx(:,1) - 1).^2;
Mesh = Mesh.Set_Points([Mesh.Points, Y]);

% plot histogram of the "quality" of each simplex in the mesh
figure;
Qual = Mesh.Quality(5);
% "5" specifies the number of bins; "Qual" is a vector of quality values

% define a 0D subdomain of the curve mesh
Mesh = Mesh.Append_Subdomain('0D','Some Vertices',[4; 3]);
% data representing subdomain can be accessed via:  Mesh.Subdomain(1).Data

% get the boundary vertices of the mesh
Bdy_Vtx = Mesh.freeBoundary;
% define a 0D subdomain of the curve mesh
Mesh = Mesh.Append_Subdomain('0D','Boundary Vertices',Bdy_Vtx);

% define a 1D subdomain of the curve mesh
Mesh = Mesh.Append_Subdomain('1D','Some Edges',[1; 4; 2]);
% This is another way to append subdomains with equal topological dimension as
% the global mesh
Mesh = Mesh.Delete_Subdomain('Some Edges');
Mesh = Mesh.Append_Subdomain('1D','Some Edges',Mesh.ConnectivityList([1; 4; 2],:));

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
Mesh.Plot_Subdomain('Some Vertices');
Mesh.Plot_Subdomain('Boundary Vertices');
hold off;
title('Initial Mesh');

% plot edge subdomains separately
figure;
Mesh.Plot_Subdomain('Some Edges');

% uniformly refine the entire mesh by dividing each edge into 2 edges
Mesh = Mesh.Refine;
% reorder again
Mesh = Mesh.Reorder;

% plot everything again
figure;
Mesh.Plot;
hold on;
Mesh.Plot_Subdomain('Some Vertices');
Mesh.Plot_Subdomain('Boundary Vertices');
hold off;
title('After Uniform Refinement');
figure;
Mesh.Plot_Subdomain('Some Edges');
title('After Uniform Refinement');

% load reference data
current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);
RefDataFileName = fullfile(Current_Dir,'test_Curve_1D_Mesh_DATA.mat');

% Mesh_REF = Mesh;
% save(RefDataFileName,'Mesh_REF');
load(RefDataFileName);

% run regression test
status = mesh_compare_routine(Mesh,Mesh_REF);

end