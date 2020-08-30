function [status, Mesh] = test_FEL_Square_2D_BaryPlot()
%test_FEL_Square_2D_BaryPlot
%
%   Test code for FELICITY class.

% Copyright (c) 04-22-2011,  Shawn W. Walker

% define simple square mesh
Vtx = [0 0; 1 0; 1 1; 0 1]; % coordinates
Tri = [1 2 3; 3 4 1];       % triangle connectivity

% create a mesh object
Mesh = MeshTriangle(Tri,Vtx,'Square');

% uniformly refine and reorder
Mesh = Mesh.Refine;
Mesh = Mesh.Refine;
Mesh = Mesh.Reorder;

% set z-coordinate
Z = (Mesh.Points(:,1) - 0.5).^2;
Mesh = Mesh.Set_Points([Mesh.Points, Z]);

% get centers of cells
SI = (1:1:Mesh.Num_Cell)';
BC = (1/3) * ones(Mesh.Num_Cell,3);
XC = Mesh.barycentricToCartesian(SI, BC);

% plot the mesh
figure;
Mesh.Plot;
hold on;
plot3(XC(:,1),XC(:,2),XC(:,3),'k*');
hold off;
title('Square Mesh and Barycenters');
view(3);

% offset coordinates
NEW_XC = XC;
NEW_XC(:,3) = NEW_XC(:,3) + 1; % MATLAB will ignore z-coordinate

% get bary-coord (should be the same as before)
NEW_BC = Mesh.cartesianToBarycentric(SI, NEW_XC);
BC_ERR = abs(NEW_BC - BC);
BC_ERR = max(BC_ERR(:));
if BC_ERR > 1e-15
    disp('(BC): Barycentric coordinate test failed!  See ''test_Square_2D_BaryPlot''.');
    status = 1;
    return;
end

% offset barycentric coordinates
NEW_BC(:,1) = NEW_BC(:,1) + 1;
% renormalize
NEW_BC_SUM = sum(NEW_BC,2);
NEW_BC(:,1) = NEW_BC(:,1) ./ NEW_BC_SUM;
NEW_BC(:,2) = NEW_BC(:,2) ./ NEW_BC_SUM;
NEW_BC(:,3) = NEW_BC(:,3) ./ NEW_BC_SUM;
NEW_XC = Mesh.barycentricToCartesian(SI, NEW_BC);

% plot the mesh
figure;
Mesh.Plot;
hold on;
plot3(NEW_XC(:,1),NEW_XC(:,2),NEW_XC(:,3),'k*');
hold off;
title('Square Mesh and Barycenters (offset toward local vertex #1)');
view(3);

% load reference data
current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);
RefDataFileName = fullfile(Current_Dir,'test_Square_2D_BaryPlot_DATA.mat');
% NEW_XC_REF = NEW_XC;
% save(RefDataFileName,'NEW_XC_REF');
load(RefDataFileName);

% run regression test
status = 0;
XC_ERR = abs(NEW_XC_REF - NEW_XC);
XC_ERR = max(XC_ERR(:));
if XC_ERR > 1e-15
    disp('(XC): Coordinate test failed!  See ''test_Square_2D_BaryPlot''.');
    status = 1;
end

end