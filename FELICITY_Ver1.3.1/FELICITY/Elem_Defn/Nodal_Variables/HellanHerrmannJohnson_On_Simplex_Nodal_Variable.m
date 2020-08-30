function Eval_Nodal_Var = HellanHerrmannJohnson_On_Simplex_Nodal_Variable(Cell,Nodal_Var_Data,Indep_Vars)
%HellanHerrmannJohnson_On_Simplex_Nodal_Variable
%
%   This returns a function handle to evaluate a specific nodal variable.
%   Note: the input of the function handle is a nodal *basis* function.
%
%   Inputs: Cell = parameterizations of reference cell and topological entities.
%           Nodal_Var_Data = *single* nodal variable.
%           Indep_Vars = vector of sym variables.
%
%   This is for the ***Hellan-Herrmann-Johnson*** finite element.
%
%   Format is:
%   (for FACET nodes) Nodal_Var_Data =...
%       {sym([(2/3); (1/3); 0]), symbolic (scalar) function, 'int_facet', facet_index}
%
%   Format is:
%   (for CELL nodes) Nodal_Var_Data =...
%       {sym([(1/3); (1/3); (1/3)]), symbolic (matrix) function, 'int_cell', 1, 'dof_set', k}

% Copyright (c) 03-28-2018,  Shawn W. Walker

% get the dimension
dim = length(Indep_Vars);

% setup integrate calls
if (dim==1)
    error('Invalid!');
elseif (dim==2)
    integrate_facet = @integrate_on_edge;
    integrate_cell  = @integrate_on_face;
elseif (dim==3)
    error('Not implemented!');
    
    integrate_facet = @integrate_on_face;
    integrate_cell  = @integrate_on_tetrahedron;
else
    error('Not implemented!');
end

% all Hellan-Herrmann-Johnson nodal variables involve integrals
q = Nodal_Var_Data{2}; % specific Lagrange basis function
Nodal_Type = Nodal_Var_Data{3}; % type of nodal variable
Entity_Index = Nodal_Var_Data{4}; % topological entity index

% setup the type of integral to compute
if strcmp(Nodal_Type,'int_facet') % integrate over facet
    Xmap = Cell.Facet(Entity_Index).Param;
    local_var = Cell.Facet(Entity_Index).Local_Var;
    nu = Cell.Facet(Entity_Index).Normal;
    
    % get length of edge (area of face) of reference triangle (tetrahedron)
    facet_meas = Cell.Facet(Entity_Index).Measure;
    
    Integrand_Func = @(SIGMA) dot(nu,SIGMA * nu) * q;
    % setup the integral evaluation
    Eval_Nodal_Var = @(SIGMA) facet_meas * integrate_facet(Integrand_Func(SIGMA),Xmap,Indep_Vars,local_var);
elseif strcmp(Nodal_Type,'int_cell') % integrate over cell
    Xmap = Cell.Param;
    local_var = Cell.Param;
    Integrand_Func = @(SIGMA) sum(sum(SIGMA .* q));
    % setup the integral evaluation
    Eval_Nodal_Var = @(SIGMA) integrate_cell(Integrand_Func(SIGMA),Xmap,Indep_Vars,local_var);
else
    error('Invalid!');
end

end