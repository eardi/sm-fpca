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

% BEGIN: indicate which nodes are adjacent to the boundary nodes
%        used to init the FIFO queue

    % faster than ISMEMBER
    Node_on_Bdy = false(Num_Nodes,1);
    Node_on_Bdy(obj.Bdy.Nodes) = true;
    Bdy_Tri_Mask = Node_on_Bdy(obj.TM.DoFmap(:,1),1) | Node_on_Bdy(obj.TM.DoFmap(:,2),1) | Node_on_Bdy(obj.TM.DoFmap(:,3),1);
    % get the boundary triangles
    Bdy_Tri = obj.TM.DoFmap(Bdy_Tri_Mask,:);
    % faster than UNIQUE
    Bdy_Tri_Vtx_Indices = sort(Bdy_Tri(:));
    Bdy_Tri_Vtx_Indices( Bdy_Tri_Vtx_Indices(1:end-1) == Bdy_Tri_Vtx_Indices(2:end) ) = [];
    Adj_Node_List = setdiff_fast(Bdy_Tri_Vtx_Indices,obj.Bdy.Nodes);

% END: indicate which nodes are adjacent to the boundary nodes

disp('Solve Eikonal Equation with MEX file...');
[u_soln, ERROR] = mexEikonal_2D(obj.TM.Vtx,uint32(obj.TM.DoFmap),obj.TM.TriStarData,uint32(obj.Bdy.Nodes),...
                               uint32(Adj_Node_List),u_soln,obj.Param,obj.Metric);
% [u_soln, ERROR] = mexEikonal_2D(obj.TM.Vtx,uint64(obj.TM.DoFmap),obj.TM.TriStarData,uint64(obj.Bdy.Nodes),...
%                                uint64(Adj_Node_List),u_soln,obj.Param,obj.Metric);
% disp(['The max iteration error between the last two iterations is: ', num2str(ERROR,'%1.5E')]);

% change sign of certain labeled nodes
u_soln(obj.TM.NegMask) = -u_soln(obj.TM.NegMask);

% END %