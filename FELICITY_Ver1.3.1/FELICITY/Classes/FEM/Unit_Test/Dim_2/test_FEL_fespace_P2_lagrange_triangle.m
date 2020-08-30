function [status, Mesh] = test_FEL_fespace_P2_lagrange_triangle()
%test_FEL_fespace_P2_lagrange_triangle
%
%   Test code for FELICITY class.

% Copyright (c) 07-01-2019,  Shawn W. Walker

% load up the standard test mesh
[Vtx, Tri] = Standard_Triangle_Mesh_Test_Data();

% create a mesh object
Mesh = MeshTriangle(Tri,Vtx,'Square');
% define a 1D subdomain of the square mesh
Bdy_Edge = Mesh.freeBoundary;
Mesh = Mesh.Append_Subdomain('1D','Boundary',Bdy_Edge);

% define some more subdomains
Mesh = Mesh.Append_Subdomain('1D','Vertical',[2 7;7 12]);
Mesh = Mesh.Append_Subdomain('2D','Small Square',[1; 2; 3; 4]);

% declare reference element
P2_Elem = lagrange_deg2_dim2();
RE = ReferenceFiniteElement(P2_Elem,false);

% declare a finite element space
FES = FiniteElementSpace('P2',RE,Mesh,[]);
% set DoFmap
FES = FES.Set_DoFmap(Mesh,Setup_Lagrange_P2_DoFmap(Mesh.ConnectivityList,[]));

% extract the DoF indices that are on the boundary
Bdy_DoFs = FES.Get_DoFs_On_Subdomain(Mesh,'Boundary');

% get the coordinates of the DoFs
XC = FES.Get_DoF_Coord(Mesh);
% get the coordinates of the Boundary DoFs
Bdy_XC = XC(Bdy_DoFs,:);

% plot the mesh
figure;
Mesh.Plot;
AX = [0 2 0 2];
axis(AX);
hold on;
plot(XC(:,1),XC(:,2),'kd');
plot(Bdy_XC(:,1),Bdy_XC(:,2),'rs');
hold off;
axis equal;
axis(AX);
title('Triangle Mesh and P2-Lagrange DoF Points (diamonds)');
xlabel('Red squares are DoFs on boundary.');

% create a FES on the small square
FES_small = FiniteElementSpace('P2',RE,Mesh,'Small Square');
% get subdomain mesh
Small_Square_Mesh = Mesh.Output_Subdomain_Mesh('Small Square');
% set DoFmap
FES_small = FES_small.Set_DoFmap(Mesh,Setup_Lagrange_P2_DoFmap(Small_Square_Mesh.ConnectivityList,[]));

% extract the DoF indices that are on the vertical line
Vertical_DoFs = FES_small.Get_DoFs_On_Subdomain(Mesh,'Vertical');

% get the coordinates of the DoFs
XC_small = FES_small.Get_DoF_Coord(Mesh);
% get the coordinates of the Boundary DoFs
Vertical_XC_small = XC_small(Vertical_DoFs,:);

% plot the mesh
figure;
p2 = Mesh.Plot_Subdomain('Small Square');
set(p2,'FaceColor',1.0*[1 1 1]);
AX = [0 2 0 2];
axis(AX);
hold on;
plot(XC_small(:,1),XC_small(:,2),'kd');
plot(Vertical_XC_small(:,1),Vertical_XC_small(:,2),'bs','MarkerSize',16);
hold off;
axis equal;
axis(AX);
title('Triangle Mesh and (sub) P2-Lagrange DoF Points (diamonds)');
xlabel('blue squares are DoFs on vertical edge.');

% load reference data
current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);
RefDataFileName = fullfile(Current_Dir,'test_fespace_P2_lagrange_triangle_DATA.mat');
% XC_REF     = XC;
% Bdy_XC_REF = Bdy_XC;
% XC_small_REF          = XC_small;
% Vertical_XC_small_REF = Vertical_XC_small;
% save(RefDataFileName,'XC_REF','Bdy_XC_REF','XC_small_REF','Vertical_XC_small_REF');
load(RefDataFileName);

% run regression test
status = 0;
XC_ERR = abs(XC_REF - XC);
XC_ERR = max(XC_ERR(:));
if XC_ERR > 1e-15
    disp('(XC): DoF coordinate test failed!  See ''test_fespace_P2_lagrange_triangle''.');
    status = 1;
end
Bdy_XC_ERR = abs(Bdy_XC_REF - Bdy_XC);
Bdy_XC_ERR = max(Bdy_XC_ERR(:));
if Bdy_XC_ERR > 1e-15
    disp('(Bdy_XC): Boundary DoF coordinate test failed!  See ''test_fespace_P2_lagrange_triangle''.');
    status = 1;
end
XC_small_ERR = abs(XC_small_REF - XC_small);
XC_small_ERR = max(XC_small_ERR(:));
if XC_small_ERR > 1e-15
    disp('(XC_small): DoF coordinate test failed!  See ''test_fespace_P2_lagrange_triangle''.');
    status = 1;
end
Vertical_XC_small_ERR = abs(Vertical_XC_small_REF - Vertical_XC_small);
Vertical_XC_small_ERR = max(Vertical_XC_small_ERR(:));
if Vertical_XC_small_ERR > 1e-15
    disp('(Vertical_XC_small): DoF coordinate test failed!  See ''test_fespace_P2_lagrange_triangle''.');
    status = 1;
end
%%%%%%%%%%%
if (FES.max_dof ~= 41)
    disp('Largest DoF index should equal 41!');
    disp('DoF test failed!  See ''test_fespace_P2_lagrange_triangle''.');
    status = 1;
end
if (FES.min_dof ~= 1)
    disp('Smallest DoF index should equal 1!');
    disp('DoF test failed!  See ''test_fespace_P2_lagrange_triangle''.');
    status = 1;
end
if (FES_small.max_dof ~= 13)
    disp('Largest DoF index should equal 41!');
    disp('DoF test failed!  See ''test_fespace_P2_lagrange_triangle''.');
    status = 1;
end
if (FES_small.min_dof ~= 1)
    disp('Smallest DoF index should equal 1!');
    disp('DoF test failed!  See ''test_fespace_P2_lagrange_triangle''.');
    status = 1;
end

end