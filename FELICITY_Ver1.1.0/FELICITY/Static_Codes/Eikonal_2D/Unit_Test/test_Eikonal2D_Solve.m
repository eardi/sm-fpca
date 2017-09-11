function status = test_Eikonal2D_Solve()
%test_Eikonal2D_Solve
%
%   Test code for FELICITY class.

% Copyright (c) 09-20-2011,  Shawn W. Walker

% This file is used for testing the variational solver for a HJB type equation
%
% The implementation is based on the paper:
% "Finite-Element Discretization Of Static Hamilton-Jacobi Equations Based On A Local
% Variational Principle" by F. Bornemann and C. Rasch

% load up mesh and Dirichlet data
DATA = load('Eikonal_Data.mat','myTM','myBdy');
myTM  = DATA.myTM;
myBdy = DATA.myBdy;
clear DATA;

% if you use your own mesh, you better make sure the triangles are oriented positively!!!
%    this algorithm might not work if they are not positively oriented!!!
%    if you don't know what this means, I suggest you learn a bit more about
%    triangulations!

% compute the known exact solution (oriented distance function - positive inside)
EXACT_DIST_SOLN = max(-dist_circle(myTM.Vtx,0.35,0.5,0.15),-dist_circle(myTM.Vtx,0.66,0.5,0.15));

% BEGIN: set parameters

% this is used in the MEX file.  This should be larger than the maximum number of
% triangles that any single vertex in the mesh is attached to.  The more distorted the
% mesh, the larger this should be.
myParam.Max_Tri_per_Star = 12;
% limit the number of Gauss-Seidel iterations to use
myParam.NumGaussSeidel = 10;
% effective value of 'infinity' - should be much larger than the expected maximum of the
% true solution
myParam.INF_VAL = 100000;
% solver iterative tolerance
myParam.TOL = 1e-12;

% END: set parameters

% in this case, we will assume the standard Euclidean metric
myMetric = [];

SEmex  = SolveEikonal2Dmex(myTM,myBdy,myParam,myMetric);
tic
DIST_SOLN_mex  = SEmex.Compute_Soln;
toc
%%%%%%
SEslow = SolveEikonal2D(myTM,myBdy,myParam);
tic
DIST_SOLN_slow = SEslow.Compute_Soln;
toc

% compute the max error
mex_error = max(abs(DIST_SOLN_mex(:) - EXACT_DIST_SOLN(:)));
slow_error = max(abs(DIST_SOLN_slow(:) - EXACT_DIST_SOLN(:)));
mex_slow_error = max(abs(DIST_SOLN_slow(:) - DIST_SOLN_mex(:)));
disp('   ');
disp(['EXACT - mex SOLN = ', num2str(mex_error,'%1.10E')]);
disp('   ');
disp(['EXACT - slow SOLN = ', num2str(slow_error,'%1.10E')]);
disp('   ');
disp(['mex SOLN - slow SOLN = ', num2str(mex_slow_error,'%1.10E'), '  <--- should be close to zero']);
disp('   ');

% plot it!
figure;
% plot distance function of two nearby circles
p1 = trisurf(SEmex.TM.DoFmap,SEmex.TM.Vtx(:,1),SEmex.TM.Vtx(:,2),DIST_SOLN_mex);
view(2);
shading interp;
set(p1,'edgecolor','k'); % make mesh black
%set(p1,'LineWidth',1.25); % make mesh black
colorbar;
hold on;
plot(SEmex.TM.Vtx(SEmex.Bdy.Nodes,1),SEmex.TM.Vtx(SEmex.Bdy.Nodes,2),'bd');
hold off;
AX = [-0.12 1.12 -0.12 1.12];
axis(AX);
axis equal;
axis(AX);

%%%%%%%%%%%%%%%%

% now solve a different problem where the distance metric is variable
% NOTE: this is ONLY implemented in the mex version!!!

% setup the piecewise linear metric matrix
myMetric.I(1,1).VAL = 4*ones(size(myTM.Vtx,1),1);
myMetric.I(2,2).VAL = 0.25*ones(size(myTM.Vtx,1),1);
myMetric.I(1,2).VAL = 0*myMetric.I(1,1).VAL;
myMetric.I(2,1).VAL = 0*myMetric.I(1,1).VAL;
myMetric.DET.VAL = (myMetric.I(1,1).VAL.*myMetric.I(2,2).VAL) - (myMetric.I(1,2).VAL.*myMetric.I(2,1).VAL);

SE_met = SolveEikonal2Dmex(myTM,myBdy,myParam,myMetric);
% note: this solution is NOT a distance function!
SOLN_with_Metric = SE_met.Compute_Soln;

% plot it!
figure;
% plot eikonal function for two nearby circles with variable metric
p1 = trisurf(SE_met.TM.DoFmap,SE_met.TM.Vtx(:,1),SE_met.TM.Vtx(:,2),SOLN_with_Metric);
view(2);
shading interp;
set(p1,'edgecolor','k'); % make mesh black
%set(p1,'LineWidth',1.25); % make mesh black
colorbar;
hold on;
plot(SE_met.TM.Vtx(SE_met.Bdy.Nodes,1),SE_met.TM.Vtx(SE_met.Bdy.Nodes,2),'bd');
hold off;
AX = [-0.12 1.12 -0.12 1.12];
axis(AX);
axis equal;
axis(AX);

% load reference data
current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);
RefDataFileName = fullfile(Current_Dir,'test_Eikonal_Solve_DATA.mat');

% DIST_SOLN_mex_REF = DIST_SOLN_mex;
% SOLN_with_Metric_REF = SOLN_with_Metric;
% save(RefDataFileName,'DIST_SOLN_mex_REF','SOLN_with_Metric_REF');
load(RefDataFileName);

% run regression test
status = 0; % init
D1_err = abs(DIST_SOLN_mex_REF - DIST_SOLN_mex);
M1_err = abs(SOLN_with_Metric_REF - SOLN_with_Metric);
if D1_err > 1e-15
    disp('Eikonal Solver (distance function) test failed!  See ''test_Eikonal_Solve''.');
    status = 1;
end
if M1_err > 1e-15
    disp('Eikonal Solver (variable metric) test failed!  See ''test_Eikonal_Solve''.');
    status = 1;
end

end