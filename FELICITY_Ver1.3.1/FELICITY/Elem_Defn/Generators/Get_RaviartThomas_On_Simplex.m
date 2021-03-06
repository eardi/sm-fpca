function [Nodal_Basis, Nodal_Var] = Get_RaviartThomas_On_Simplex(dim,deg_k)
%Get_RaviartThomas_On_Simplex
%
%   This computes the Raviart-Thomas basis functions on a simplex.

% Copyright (c) 10-07-2016,  Shawn W. Walker

disp(['Solve for Raviart-Thomas degree ', num2str(deg_k), ' basis functions (on ', num2str(dim), '-D reference simplex):']);

if (deg_k < 0)
    % invalid degree, so return *nothing*
    Nodal_Basis = [];
    Nodal_Var   = [];
    return;
end

% get parameterizations of the reference simplex
if (dim==1)
    % get params of the reference interval
    Cell = interval_parameterizations();
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
Basis_1 = basis_vector_polys_deg_k(indep_vars,deg_k,num_comp);
% create the [x;y] * exact degree scalar basis
vec_X = indep_vars;
Basis_2 = basis_polys_deg_k(indep_vars,deg_k,true);
for bb = 1:length(Basis_2)
    Basis_2(bb).func = Basis_2(bb).func * vec_X;
end
Basis = [Basis_1, Basis_2]; % direct sum!

% error check
if (dim==2)
    Num_Basis = (deg_k + 1)*(deg_k + 3);
elseif (dim==3)
    Num_Basis = round((1/2)*(deg_k + 1)*(deg_k + 2)*(deg_k + 4));
elseif (dim < 2)
    error('Invalid dimension!');
else
    error('Dimension not implemented!');
end
if (Num_Basis~=length(Basis))
    error('Number of basis functions is invalid!');
end

indep_vars_cell = num2cell(indep_vars);

% get Lagrange nodal basis functions on reference facet
% (i.e. unit interval or unit triangle)
[Lagrange_Basis_Facet, Lagrange_Nodal_Pt_Facet] = Get_Lagrange_On_Simplex(dim-1,deg_k);
Local_Facet_Var = num2cell(Cell.Facet(1).Local_Var);
% replace x with u (or {x,y} with {u,v})
Lagrange_Basis_Facet = change_basis_func_independent_variable(Lagrange_Basis_Facet,indep_vars_cell(1:dim-1),Local_Facet_Var);

% get Lagrange nodal basis functions on unit cell (triangle or tetrahedron)
[Lagrange_Basis_Cell, Lagrange_Nodal_Pt_Cell] = Get_Lagrange_On_Simplex(dim,deg_k-1);
% don't need to change variables

% BEGIN: define nodal variable data (in order of the DoF index)
% these effectively specify what the Degrees-of-Freedom (DoFs) are
% Note: these involve integral averages
Num_Nodal_Var = Num_Basis;
Nodal_Var(Num_Nodal_Var).Data = [];
nodal_index = 0; % init

% loop through facet averages
Num_Facet = dim+1;
for fi = 1:Num_Facet
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
        Nodal_Var(nodal_index).Data = {Mapped_Nodal_Point, local_bf, 'int_facet', fi};
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
    Eval_Nodal_Variable = RaviartThomas_On_Simplex_Nodal_Variable(Cell,Nodal_Var_Data,indep_vars);
    
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