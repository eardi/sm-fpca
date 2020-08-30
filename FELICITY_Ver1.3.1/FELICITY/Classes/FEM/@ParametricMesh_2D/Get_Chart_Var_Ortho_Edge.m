function [Chart_Var_XC, Iter_Func] = Get_Chart_Var_Ortho_Edge(obj,Edge_Pt_Tail,Edge_Pt_Head,...
                                               Edge_Chart_Ind,Edge_Chart_Var,XC,Enforce_Limits,Iter_Func_input)
%Get_Chart_Var_Ortho_Edge
%
%   This finds parameterization variables \xi, such that
%
%              (\alpha_{i}(\xi) - X0) \cdot TV = 0,
%
%   where X0 is a given point, and TV is the tangent vector of the
%   given edges.  This is useful for projecting points onto the
%   parameterized boundary orthogonal to given edge segments.
%
%   [Chart_Var_XC, Iter_Func] = obj.Get_Chart_Var_Ortho_Edge(Edge_Pt_Tail,Edge_Pt_Head,...
%                                           Edge_Chart_Ind,Edge_Chart_Var,XC,Enforce_Limits);
%
%   Edge_Pt_Tail = Ex2 matrix of coordinates of the "tail" of the edge.
%   Edge_Pt_Head = Ex2 matrix of coordinates of the "head" of the edge.
%   Edge_Chart_Ind = Ex1 vector of chart indices, i.e. which chart to use
%                    on each edge.
%   Edge_Chart_Var = Ex2 matrix of chart variable limits, i.e.
%                    Edge_Chart_Var(:,1) correspond to the tail, and
%                    Edge_Chart_Var(:,2) correspond to the head.  The
%                    output chart variables must lie in this range.
%   XC = Ex1 cell array of point coordinates. XC{i} is an Mx2 matrix of
%        coordinates of points associated to the ith edge.  Note that M can
%        change from one edge to the next.
%   Enforce_Limits = true/false.  Indicates whether to enforce the limits
%                    in Edge_Chart_Var.
%
%   Chart_Var_XC = Ex1 cell array of chart variable values. Chart_Var_XC{i}
%                  is an Mx1 vector of chart variable values associated to
%                  the ith edge.  Note that M can change from one edge to
%                  the next.
%   Iter_Func = cell array of function handles that this routine can use
%               for repeated calls; see below.
%
%   optional argument:
%   Chart_Var_XC = obj.Get_Chart_Var_Ortho_Edge(Edge_Pt_Tail,...,
%                                               Enforce_Limits,Iter_Func);

% Copyright (c) 08-13-2019,  Shawn W. Walker

if (nargin==7)
    Iter_Func = [];
else
    Iter_Func = Iter_Func_input;
end

if isempty(Iter_Func)
    % compute iteration function for running Newton's method to find zero
    Num_Charts = length(obj.Chart_Funcs);
    Iter_Func = cell(Num_Charts,1);
    syms t real;
    for ch = 1:Num_Charts
        alpha = obj.Chart_Funcs{ch};
        alpha_sym = alpha(t);
        alpha_sym_deriv = diff(alpha_sym,t);
        alpha_prime = matlabFunction(alpha_sym_deriv,'Vars',{t});
        
        % find parameterization variable, such that
        %   f(\xi) = (\alpha_{i}(\xi) - X0) \cdot TV = 0, where
        %         TV is the tangent vector of a given edge.
        % Newton's method:  \xi_{k+1} = \Theta(\xi_{k}), where
        %          \Theta(\xi) := \xi - [ f(\xi) / f'(\xi) ], where
        %          f'(\xi) = \alpha_{i}'(\xi) \cdot TV.
        Iter_Func{ch} = @(xi,X0,TV) xi - ( dot( ( alpha(xi) - X0 ), TV )...
                                         / dot( alpha_prime(xi), TV ) );
    end
end

% init
Num_Edges = size(Edge_Pt_Head,1);
Chart_Var_XC = cell(Num_Edges,1);

% compute tangents
TV = Edge_Pt_Head - Edge_Pt_Tail;
TV = Normalize_Vector_Field(TV);

% run Newton's method
TOL = 1e-14;
for ei = 1:Num_Edges
    Ch_Ind = Edge_Chart_Ind(ei,1);
    % initial guess
    xi = (1/2) * sum(Edge_Chart_Var(ei,:));
    Theta = Iter_Func{Ch_Ind};
    % loop through the subset of points
    X_pts = XC{ei};
    Num_pts = size(X_pts,1);
    Chart_Var_XC{ei} = zeros(Num_pts,1); % init
    for jj = 1:Num_pts
        X0 = X_pts(jj,:);
        for kk = 1:50
            old_xi = xi;
            xi = Theta(xi,X0,TV(ei,:));
            ERR_xi = abs(xi - old_xi);
            %ERR_xi
            if ERR_xi < TOL
                if Enforce_Limits
                    xi_p = max(xi,Edge_Chart_Var(ei,1));
                    xi_p = min(xi_p,Edge_Chart_Var(ei,2));
                    if abs(xi_p - xi) > TOL
                        xi
                        xi_p
                        error('ERROR!');
                    end
                    xi = xi_p;
                end
                Chart_Var_XC{ei}(jj,1) = xi;
                break;
            end
        end
        if ERR_xi >= TOL
            error('Newton''s method did not converge!');
        end
    end
end

end