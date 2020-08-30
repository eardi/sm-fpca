function [status, Mesh] = test_FEL_Interval_1D_BaryPlot()
%test_FEL_Interval_1D_BaryPlot
%
%   Test code for FELICITY class.

% Copyright (c) 04-22-2011,  Shawn W. Walker

% define simple mesh on unit interval
Vtx     = (0:0.2:1)';
Num_Vtx = length(Vtx);
Vtx_Ind = (1:1:Num_Vtx)';
Edges   = [Vtx_Ind(1:end-1,1), Vtx_Ind(2:end,1)];

% create a mesh object
Mesh = MeshInterval(Edges,Vtx,'Curve');

% uniformly refine and reorder
Mesh = Mesh.Refine;
Mesh = Mesh.Refine;
Mesh = Mesh.Reorder;

% set y-coordinate
Y = (Mesh.Points(:,1) - 0.5).^2;
Mesh = Mesh.Set_Points([Mesh.Points, Y]);

% get centers of cells
SI = (1:1:Mesh.Num_Cell)';
BC = (1/2) * ones(Mesh.Num_Cell,2);
XC = Mesh.barycentricToCartesian(SI, BC);

% plot the mesh
figure;
Mesh.Plot;
hold on;
plot(XC(:,1),XC(:,2),'k*');
hold off;
title('Interval Mesh and Barycenters');

% offset coordinates
NEW_XC = XC;
NEW_XC(:,2) = NEW_XC(:,2) + 1; % MATLAB will ignore z-coordinate

% get bary-coord (should be the same as before)
NEW_BC = Mesh.cartesianToBarycentric(SI, NEW_XC);
BC_ERR = abs(NEW_BC - BC);
BC_ERR = max(BC_ERR(:));
if BC_ERR > 1e-14
    disp('(BC): Barycentric coordinate test failed!  See ''test_Square_2D_BaryPlot''.');
    status = 1;
    return;
end

% offset barycentric coordinates
NEW_BC(:,1) = NEW_BC(:,1) + 2;
% renormalize
NEW_BC_SUM = sum(NEW_BC,2);
NEW_BC(:,1) = NEW_BC(:,1) ./ NEW_BC_SUM;
NEW_BC(:,2) = NEW_BC(:,2) ./ NEW_BC_SUM;
NEW_XC = Mesh.barycentricToCartesian(SI, NEW_BC);

% plot the mesh
figure;
Mesh.Plot;
hold on;
plot(NEW_XC(:,1),NEW_XC(:,2),'k*');
hold off;
title('Interval Mesh and Barycenters (offset toward local vertex #1)');

% load reference data
current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);
RefDataFileName = fullfile(Current_Dir,'test_Interval_1D_BaryPlot_DATA.mat');
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