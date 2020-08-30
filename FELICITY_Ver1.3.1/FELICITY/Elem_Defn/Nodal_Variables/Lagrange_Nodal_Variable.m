function Eval_Nodal_Var = Lagrange_Nodal_Variable(Cell,Nodal_Var_Data,Indep_Vars)
%Lagrange_Nodal_Variable
%
%   This returns a function handle to evaluate a specific nodal variable.
%   Note: the input of the function handle is a nodal *basis* function.
%
%   Inputs: Cell = parameterizations of reference cell and topological entities.
%           Nodal_Var_Data = *single* nodal variable.
%           Indep_Vars  = vector of sym variables.
%
%   This is for the ***Lagrange*** finite element.
%
%   Format is:  Nodal_Var_Data =
%                         {sym([(2/3); (1/3)]), 'eval_facet', facet_index};

% Copyright (c) 11-03-2016,  Shawn W. Walker

% all Lagrange nodal variables are point evaluation
Pt_Coord = num2cell(Nodal_Var_Data{1});
% Nodal_Type = Nodal_Var_Data{2};
% Entity_Index = Nodal_Var_Data{3};

if ( size(Pt_Coord,1) < size(Pt_Coord,2) )
    Pt_Coord = Pt_Coord'; % make into column vector
end

% get the dimension
Top_Dim = length(Cell.Param);

% setup the point evaluation
if (length(Pt_Coord)==Top_Dim)
    % then Pt_Coord is in standard reference coordinates
    Eval_Nodal_Var = @(phi) subs(phi,Indep_Vars,Pt_Coord);
elseif (length(Pt_Coord)==Top_Dim+1)
    % then Pt_Coord is in barycentric coordinate format
    % only need the reference coordinates
    Ref_Coord = Pt_Coord(2:end,1);
    Eval_Nodal_Var = @(phi) subs(phi,Indep_Vars,Ref_Coord);
else
    error('Format of Pt_Coord is unknown!');
end

end