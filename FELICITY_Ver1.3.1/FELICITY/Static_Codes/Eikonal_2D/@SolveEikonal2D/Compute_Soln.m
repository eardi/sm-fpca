function u_soln = Compute_Soln(obj)
%Compute_Soln
%
%   This routine computes the solution of the Eikonal equation.

% Copyright (c) 07-01-2009,  Shawn W. Walker

% how many nodes are there
Num_Nodes = size(obj.TM.Vtx,1);

% init function
u_soln = 2*obj.Param.INF_VAL*ones(Num_Nodes,1);

% set Dirichlet values
u_soln(obj.Bdy.Nodes) = obj.Bdy.Data;

% setup list of vertex indices to loop through
Vtx_List = setdiff_fast((1:1:Num_Nodes)',obj.Bdy.Nodes);

% save old
u_old = u_soln;

disp('Begin Solving Eikonal Equation');
disp('---------------------------------------');

for j=1:obj.Param.NumGaussSeidel
    u_soln = Sweep_Mesh_Once(obj,Vtx_List,u_soln);
    ERROR = max(abs(u_soln - u_old));
    disp(['Current Max Error is: ', num2str(ERROR,'%1.4E')]);
    if ERROR < obj.Param.TOL
        break;
    end
    u_old = u_soln;
end

disp('Finished Solving Eikonal Equation');
disp('---------------------------------------');
disp(['Final Max Iteration Error is: ', num2str(ERROR,'%1.4E')]);
disp('---------------------------------------');

% change sign of certain labeled nodes
u_soln(obj.TM.NegMask) = -u_soln(obj.TM.NegMask);

% END %