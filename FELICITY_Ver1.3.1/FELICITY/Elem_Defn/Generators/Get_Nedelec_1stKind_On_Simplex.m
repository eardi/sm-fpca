function [Nodal_Basis, Nodal_Var] = Get_Nedelec_1stKind_On_Simplex(dim,deg_k,use_std)
%Get_Nedelec_1stKind_On_Simplex
%
%   This computes the Nedelec (1st kind) basis functions on a simplex.
%
%   This uses the Paul Wesson trick for choosing tangent basis vectors (for
%   edges and faces); i.e. the global numbering of the element vertices
%   dictates the choice of tangent vectors (see
%   "Generate_Nedelec_1stKind_Element_File" for more info).
%
%   The last input (only used in 3-D) determines which reference finite
%   element to get. Let the global vertices of the physical mesh element
%   (tetrahedron) be given by [V1, V2, V3, V4]
%   
%   use_std = true: this assumes that the vertex indices satisfy:
%             V1 < V2 < V3 < V4 (standard ascending ordering).
%             This dictates a particular choice of tangent basis vectors.
%
%   use_std = false: this assumes that the vertex indices satisfy:
%             V1 < V3 < V2 < V4 (reflect element; mirror image).
%             This dictates a different choice of tangent basis vectors.
%
%   Note: if the physical element does not satisfy either of these, then
%         you need another reference element!

% Copyright (c) 11-07-2016,  Shawn W. Walker

% set default
if (nargin==2)
    use_std = true;
end
if isempty(use_std)
    use_std = true;
end

disp(['Solve for Nedelec (1st kind) degree ', num2str(deg_k), ' basis functions (on ', num2str(dim), '-D reference simplex):']);

if (deg_k < 1)
    % invalid degree, so return *nothing*
    Nodal_Basis = [];
    Nodal_Var   = [];
    return;
end

% get parameterizations of the reference simplex
if (dim==1)
    % get params of the reference interval
    %Cell = interval_parameterizations();
    error('Invalid!');
elseif (dim==2)
    % get params of the reference triangle
    Cell = triangle_parameterizations();
elseif (dim==3)
    % get params of the reference tetrahedron
    Cell = tetrahedron_parameterizations();
else
    error('Dimension not implemented!');
end
indep_vars = Cell.Param_Inv; % col. vector list of independent variables

% define a set of basis functions (indep. variables are x,y)
num_comp = dim;
Basis_1 = basis_vector_polys_deg_k(indep_vars,deg_k-1,num_comp);
% get the special polynomial space S_k
Basis_2 = basis_vector_polys_deg_k_Sk(indep_vars,deg_k);
Basis = [Basis_1, Basis_2]; % direct sum!

% for ii = 1:length(Basis)
%     Basis(ii).func
% end

% error check
if (dim==2)
    Num_Basis = deg_k*(deg_k + 2);
elseif (dim==3)
    Num_Basis = round((1/2)* deg_k *(deg_k + 2)*(deg_k + 3));
elseif (dim < 2)
    error('Invalid dimension!');
else
    error('Dimension not implemented!');
end
if (Num_Basis~=length(Basis))
    error('Number of basis functions is invalid!');
end

indep_vars_cell = num2cell(indep_vars);

if (dim==2)
    % get Lagrange nodal basis functions on reference edge
    % (i.e. the unit interval)
    [Lagrange_Basis_Edge, Lagrange_Nodal_Pt_Edge] = Get_Lagrange_On_Simplex(dim-1,deg_k-1);
    Local_Edge_Var = num2cell(Cell.Edge(1).Local_Var);
    % replace x with u
    Lagrange_Basis_Edge = change_basis_func_independent_variable(Lagrange_Basis_Edge,indep_vars_cell(1:dim-1),Local_Edge_Var);
    
    % get Lagrange nodal basis functions on unit cell (triangle)
    [Lagrange_Basis_Cell, Lagrange_Nodal_Pt_Cell] = Get_Lagrange_On_Simplex(dim,deg_k-2);
    % don't need to change variables
elseif (dim==3)
    % get Lagrange nodal basis functions on reference edge
    % (i.e. the unit interval)
    [Lagrange_Basis_Edge, Lagrange_Nodal_Pt_Edge] = Get_Lagrange_On_Simplex(dim-2,deg_k-1);
    Local_Edge_Var = num2cell(Cell.Edge(1).Local_Var);
    % replace x with u
    Lagrange_Basis_Edge = change_basis_func_independent_variable(Lagrange_Basis_Edge,indep_vars_cell(1:dim-2),Local_Edge_Var);
    
    % get Lagrange nodal basis functions on reference facet
    % (i.e. the unit triangle)
    [Lagrange_Basis_Facet, Lagrange_Nodal_Pt_Facet] = Get_Lagrange_On_Simplex(dim-1,deg_k-2);
    Local_Facet_Var = num2cell(Cell.Facet(1).Local_Var);
    % replace {x,y} with {u,v}
    Lagrange_Basis_Facet = change_basis_func_independent_variable(Lagrange_Basis_Facet,indep_vars_cell(1:dim-1),Local_Facet_Var);
    
    % get Lagrange nodal basis functions on unit cell (tetrahedron)
    [Lagrange_Basis_Cell, Lagrange_Nodal_Pt_Cell] = Get_Lagrange_On_Simplex(dim,deg_k-3);
    % don't need to change variables
elseif (dim==1)
    error('Invalid dimension!');
else
    error('Not implemented!');
end

% BEGIN: define nodal variable data (in order of the DoF index)
% these effectively specify what the Degrees-of-Freedom (DoFs) are
% Note: these involve integral averages
Num_Nodal_Var = Num_Basis;
Nodal_Var(Num_Nodal_Var).Data = [];
nodal_index = 0; % init

% loop through edge averages
if (dim==2)
    Num_Edge = 3;
elseif (dim==3)
    Num_Edge = 6;
else
    error('Invalid!');
end
for ei = 1:Num_Edge
    % get the correct orientation (for H(curl)!) of the unit tangent vector of the edge
    Tangent_Vector = get_edge_tangent_vector_for_Hcurl(Cell,dim,ei,use_std);
    for li = 1:length(Lagrange_Basis_Edge)
        local_bf = Lagrange_Basis_Edge(li).Func; % local Lagrange basis function
        % map that function to the edge
        Xmap_Inv = Cell.Edge(ei).Param_Inv;
        local_bf = subs(local_bf,Local_Edge_Var,Xmap_Inv);
        
        % store the corresponding nodal (Lagrange) point coordinates
        NP = Lagrange_Nodal_Pt_Edge(li).Data{1};
        % map to the facet in question
        Xmap = Cell.Edge(ei).Param;
        Mapped_Nodal_Point = subs(Xmap,Local_Edge_Var,NP);
        
        % append nodal data
        nodal_index = nodal_index + 1;
        Nodal_Var(nodal_index).Data = {Mapped_Nodal_Point, local_bf*Tangent_Vector, 'int_edge', ei};
    end
end

% loop through facet averages
if (dim==3)
    for ti = 1:dim-1 % loop through the different tangent vectors in each facet
        Num_Facet = 4;
        for fi = 1:Num_Facet
            Tangent = get_facet_tangent_vectors_for_Hcurl(Cell,fi,use_std);
            for li = 1:length(Lagrange_Basis_Facet)
                local_bf = Lagrange_Basis_Facet(li).Func; % local Lagrange basis function
                % map that function to the facet
                Xmap_Inv = Cell.Facet(fi).Param_Inv;
                local_bf = subs(local_bf,Local_Facet_Var,Xmap_Inv);
                
                % store the corresponding nodal (Lagrange) point coordinates
                NP = Lagrange_Nodal_Pt_Facet(li).Data{1};
                % map to the facet in question
                Xmap = Cell.Facet(fi).Param;
                Mapped_Nodal_Point = subs(Xmap,Local_Facet_Var,NP);
                
                % append nodal data
                nodal_index = nodal_index + 1;
                Nodal_Var(nodal_index).Data = {Mapped_Nodal_Point, local_bf*Tangent(ti).Vector, 'int_facet', fi, 'dof_set', ti};
            end
        end
    end
end

% loop through cell averages
for vi = 1:dim % loop through vector components
    Vector = zeros(dim,1);
    Vector(vi) = 1;
    for li = 1:length(Lagrange_Basis_Cell)
        local_bf = Lagrange_Basis_Cell(li).Func; % local Lagrange basis function
        % already mapped to the cell
        
        % store the nodal (Lagrange) points
        Nodal_Point = Lagrange_Nodal_Pt_Cell(li).Data{1}; % already mapped
        
        % append nodal data
        nodal_index = nodal_index + 1;
        Nodal_Var(nodal_index).Data = {Nodal_Point, local_bf*Vector, 'int_cell', 1, 'dof_set', vi};
    end
end

% END: define nodal variable data (in order of the DoF index)

% generate matrix entries
N = length(Nodal_Var);
if (N~=Num_Nodal_Var) % error check
    error('Number of nodal variables is too high!');
end
% init Vandermonde matrix
A = sym(zeros(N,N));

% fill in the "Vandermonde" matrix
disp('Fill Vandermonde matrix A:');
for ii=1:N
    % get the current nodal variable (DoF)
    Nodal_Var_Data = Nodal_Var(ii).Data;
    Eval_Nodal_Variable = Nedelec_1stKind_On_Simplex_Nodal_Variable(Cell,Nodal_Var_Data,indep_vars);
    
    % loop through all of the (primal) basis functions
    for jj=1:N
        vphi = Basis(jj).func; % get basis function
        % insert into matrix
        A(ii,jj) = Eval_Nodal_Variable(vphi); % eval nodal variable
    end
    disp(['Compute A(', num2str(ii), ', 1:', num2str(N), ').']);
end
disp('Finished forming Vandermonde matrix...');

% lambda = abs(eig(double(A)));
% COND = max(lambda) / min(lambda);
% COND

% solve for coefficients
EYE_SYM = sym(eye(N));
disp('Solve for coefficients:');
COEF = A \ EYE_SYM;

% compute the nodal basis functions
Nodal_Basis(N).Func = [];
for ind=1:N
    TEMP = 0; % reset!
    for jj=1:N
        TEMP = TEMP + COEF(jj,ind) * Basis(jj).func;
    end
    Nodal_Basis(ind).Func = simplify(TEMP);
end

% display
for ind=1:N
    disp(['Nodal Basis Function #', num2str(ind), ':']);
    pretty(Nodal_Basis(ind).Func)
end

end

function tau = get_edge_tangent_vector_for_Hcurl(Cell,dim,edge_index,use_std)

% this returns a tangent vector so that it points from a vertex of lower
% index **toward a vertex of higher index**. This is the Paul Wesson trick.

% NOTE: these tangent vectors are *unit* tangent vectors.  This is how the
% degrees-of-freedom are defined.

tau = Cell.Edge(edge_index).Tangent;

% adjust sign if necessary
if (use_std)
    if (dim==2)
        if (edge_index==2)
            % flip this one relative to the "standard" assumed orientation
            tau = -tau;
        end
    elseif (dim==3)
        % V1 < V2 < V3 < V4
        if (edge_index==6)
            % flip this one relative to the "standard" assumed orientation
            tau = -tau;
        end
    else
        error('Invalid or not implemented!');
    end
else
    % this only happens in 3-D
    if (dim==3)
        % V1 < V3 < V2 < V4
        if or(edge_index==4,edge_index==6)
            % flip this relative to the "standard" assumed orientation
            tau = -tau;
        end
    else
        error('Invalid or not implemented!');
    end
end

end

function tau = get_facet_tangent_vectors_for_Hcurl(Cell,face_index,use_std)

% this returns two tangent vectors (on the given facet in 3-D) that satisfy
% the Paul Wesson trick.  I.e. for the given face, with vertices [a,b,c]
% given in ascending order with respect to the local vertex index, the
% tangent vectors are given by:  tau_1 = b - a, tau_2 = c - a.

% WARNING!!! these are not necessarily *unit* tangent vectors.
% They come from taking the difference of the corner vertex coordinates.
% Hence, the tangents on the boundary of the "111" face (i.e. face #1) are
% length sqrt(2).
% Note: this is how the degrees-of-freedom are defined.

tau(2).Vector = []; % init

if (use_std)
    % V1 < V2 < V3 < V4
    
    if (face_index==1)
        tau(1).Vector =  Cell.Edge(4).Tangent * Cell.Edge(4).Measure; %  e4
        tau(2).Vector = -Cell.Edge(6).Tangent * Cell.Edge(6).Measure; % -e6
    elseif (face_index==2)
        tau(1).Vector = Cell.Edge(2).Tangent; %  e2
        tau(2).Vector = Cell.Edge(3).Tangent; %  e3
    elseif (face_index==3)
        tau(1).Vector = Cell.Edge(1).Tangent; %  e1
        tau(2).Vector = Cell.Edge(3).Tangent; %  e3
    elseif (face_index==4)
        tau(1).Vector = Cell.Edge(1).Tangent; %  e1
        tau(2).Vector = Cell.Edge(2).Tangent; %  e2
    else
        error('Invalid!');
    end
    
else % mirror image
    % V1 < V3 < V2 < V4
    
    if (face_index==1)
        tau(1).Vector = -Cell.Edge(4).Tangent * Cell.Edge(4).Measure; % -e4
        tau(2).Vector =  Cell.Edge(5).Tangent * Cell.Edge(5).Measure; %  e5
    elseif (face_index==2)
        tau(1).Vector = Cell.Edge(2).Tangent; %  e2
        tau(2).Vector = Cell.Edge(3).Tangent; %  e3
    elseif (face_index==3)
        tau(1).Vector = Cell.Edge(1).Tangent; %  e1
        tau(2).Vector = Cell.Edge(3).Tangent; %  e3
    elseif (face_index==4)
        tau(1).Vector = Cell.Edge(2).Tangent; %  e2
        tau(2).Vector = Cell.Edge(1).Tangent; %  e1
    else
        error('Invalid!');
    end
    
end

end