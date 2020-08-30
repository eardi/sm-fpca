function [status, Mesh] = test_FEL_Bisection_2D_Square()
%test_FEL_Bisection_2D_Square
%
%   Test code for FELICITY class.
%
%   SWW: this unit test seems to make MATLAB crash on MACs *only*.
%   Therefore, this unit test is ignored on MACs.

% Copyright (c) 01-17-2016,  Shawn W. Walker

if ismac
    disp('Ignoring ''test_Bisection_2D_Square'' because this computer is a MAC.');
    status = 0; % no error
    Mesh = []; % NULL
else
    
    % define simple square mesh
    Vtx = [0 0; 1 0; 1 1; 0 1]; % coordinates
    Tri = [1 2 3; 3 4 1];       % triangle connectivity
    
    % create a mesh object
    Mesh = MeshTriangle(Tri,Vtx,'Square');
    
    % define a 0D subdomain of the square mesh
    Mesh = Mesh.Append_Subdomain('0D','Upper Right Vtx',[3]);
    % data representing subdomain can be accessed via:  Mesh.Subdomain(1).Data
    
    % define a 1D subdomain of the square mesh
    Diag_Edge = [1 3]; % edge between vertices 1 and 3
    Mesh = Mesh.Append_Subdomain('1D','Diagonal',Diag_Edge);
    
    % define a 2D subdomain of the square mesh
    Mesh = Mesh.Append_Subdomain('2D','Lower Right Region',[1]);
    
    % plot the mesh
    figure;
    Mesh.Plot;
    % add plots of the subdomains
    hold on;
    Mesh.Plot_Subdomain('Lower Right Region');
    Mesh.Plot_Subdomain('Diagonal');
    Mesh.Plot_Subdomain('Upper Right Vtx');
    hold off;
    title('Initial Mesh');
    
    % bisect upper left triangle into two triangles
    % of course, this will cause the other triangle to get bisected to maintain
    % conformity
    Mesh = Mesh.Refine('bisection',[1]);
    % bisect the (new) #2 and #4 triangles
    Mesh = Mesh.Refine('bisection',[2; 4]);
    % refine all triangles by bisection
    Mesh = Mesh.Refine('bisection');
    % refine all triangles that reference the ``Upper Right Vtx'' by bisection
    Mark_Tri = Mesh.Get_Subdomain_Cells('Upper Right Vtx');
    Mesh = Mesh.Refine('bisection',Mark_Tri);
    % refine all triangles contained in the ``Lower Right Region'' by bisection
    Mark_Tri = Mesh.Get_Subdomain_Cells('Lower Right Region');
    Mesh = Mesh.Refine('bisection',Mark_Tri);
    % refine all triangles that reference the ``Diagonal'' by bisection
    Mark_Tri = Mesh.Get_Subdomain_Cells('Diagonal');
    Mesh = Mesh.Refine('bisection',Mark_Tri);
    % refine again
    Mark_Tri = Mesh.Get_Subdomain_Cells('Diagonal');
    Mesh = Mesh.Refine('bisection',Mark_Tri);
    
    % plot everything again
    figure;
    Mesh.Plot;
    hold on;
    Mesh.Plot_Subdomain('Lower Right Region');
    Mesh.Plot_Subdomain('Diagonal');
    Mesh.Plot_Subdomain('Upper Right Vtx');
    hold off;
    title('After (Selective) Refinement');
    
    % load reference data
    current_file = mfilename('fullpath');
    Current_Dir  = fileparts(current_file);
    RefDataFileName = fullfile(Current_Dir,'test_Bisection_2D_Square_DATA.mat');
    
%     Mesh_REF = Mesh;
%     save(RefDataFileName,'Mesh_REF');
    load(RefDataFileName);
    
    % run regression test
    status = mesh_compare_routine(Mesh,Mesh_REF);
end

end