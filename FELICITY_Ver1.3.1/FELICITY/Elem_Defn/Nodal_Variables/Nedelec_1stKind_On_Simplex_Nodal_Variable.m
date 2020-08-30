function Eval_Nodal_Var = Nedelec_1stKind_On_Simplex_Nodal_Variable(Cell,Nodal_Var_Data,Indep_Vars)
%Nedelec_1stKind_On_Simplex_Nodal_Variable
%
%   This returns a function handle to evaluate a specific nodal variable.
%   Note: the input of the function handle is a nodal *basis* function.
%
%   Inputs: Cell = parameterizations of reference cell and topological entities.
%           Nodal_Var_Data = *single* nodal variable.
%           Indep_Vars  = vector of sym variables.
%
%   This is for the ***Nedelec (1st Kind)*** finite element.
%
%   Format is:
%   (for EDGE nodes) Nodal_Var_Data =...
%       {sym([x;y;z]), symbolic (vector) function, 'int_edge', edge_index}
%                     (the vector function points parallel to the edge)
%
%   Format is: (only in 3-D)
%   (for FACET nodes) Nodal_Var_Data =...
%       {sym([x;y;z]), symbolic (vector) function, 'int_facet', facet_index, 'dof_set', k}
%                     (the vector function points perpendicular to the facet normal)
%
%   Format is:
%   (for CELL nodes) Nodal_Var_Data =...
%       {sym([x;y;z]), symbolic (vector) function, 'int_cell', 1, 'dof_set', k}
%                     (the vector function points along either the x, y, or z direction)

% Copyright (c) 11-02-2016,  Shawn W. Walker

% get the dimension
dim = length(Indep_Vars);

% setup integrate calls
if (dim==1)
    error('Invalid!');
elseif (dim==2)
    integrate_edge  = @integrate_on_edge;
    integrate_cell  = @integrate_on_face;
elseif (dim==3)
    integrate_edge  = @integrate_on_edge;
    integrate_facet = @integrate_on_face;
    integrate_cell  = @integrate_on_tetrahedron;
else
    error('Not implemented!');
end

% all Nedelec 1st-kind nodal variables involve integrals
q = Nodal_Var_Data{2}; % specific Lagrange basis function (vector valued)
Nodal_Type = Nodal_Var_Data{3}; % type of nodal variable
Entity_Index = Nodal_Var_Data{4}; % topological entity index

% setup the type of integral to compute
if strcmp(Nodal_Type,'int_edge') % integrate over edge
    Xmap = Cell.Edge(Entity_Index).Param;
    local_var = Cell.Edge(Entity_Index).Local_Var;
    
    Integrand_Func = @(vphi) transpose(vphi) * q;
    % setup the integral evaluation
    Eval_Nodal_Var = @(vphi) integrate_edge(Integrand_Func(vphi),Xmap,Indep_Vars,local_var);
elseif strcmp(Nodal_Type,'int_facet') % integrate over facet (only in 3-D)
    Xmap = Cell.Facet(Entity_Index).Param;
    local_var = Cell.Facet(Entity_Index).Local_Var;
    
    % get area of face of reference tetrahedron
    face_area = Cell.Facet(Entity_Index).Measure;
    
    Integrand_Func = @(vphi) transpose(vphi) * q;
    % setup the integral evaluation
    Eval_Nodal_Var = @(vphi) (1/face_area) * integrate_facet(Integrand_Func(vphi),Xmap,Indep_Vars,local_var);
elseif strcmp(Nodal_Type,'int_cell') % integrate over cell
    Xmap = Cell.Param;
    local_var = Cell.Param;
    
    Integrand_Func = @(vphi) transpose(vphi) * q;
    % setup the integral evaluation
    Eval_Nodal_Var = @(vphi) integrate_cell(Integrand_Func(vphi),Xmap,Indep_Vars,local_var);
else
    error('Invalid!');
end

end