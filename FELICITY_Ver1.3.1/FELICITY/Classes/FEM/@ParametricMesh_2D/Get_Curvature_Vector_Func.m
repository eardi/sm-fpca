function Curvature_Vector_Func = Get_Curvature_Vector_Func(obj,Surf_Map)
%Get_Curvature_Vector_Func
%
%   This returns a function handle for evaluating the curvature vector,
%   i.e.
%
%              \tv(\xi) = \alpha_{i}'(\xi) / |\alpha_{i}'(\xi)|,
%              \kv(\xi) = - \tv'(\xi) / |\alpha_{i}'(\xi)|.
%
%   Curvature_Vector_Func = obj.Get_Curvature_Vector_Func();
%
%   Note: assuming the chart is positively oriented, then the curvature
%   vector points *outside* of the domain, if the boundary is locally
%   convex.
%
%   Curvature_Vector_Func = obj.Get_Curvature_Vector_Func(Surf_Map);
%
%   In this case, we pass an additional function handle that represents a
%   surface mapping, i.e. a map from R^2 to R^3.  Then the boundary of the
%   reference domain is mapped to the boundary of the surface.  Moreover,
%   the curvature vector function reflects this.

% Copyright (c) 05-07-2020,  Shawn W. Walker

if (nargin==1)
    Surf_Map = @(x, y) [x, y];
elseif isempty(Surf_Map)
    Surf_Map = @(x, y) [x, y];
elseif ~isa(Surf_Map,'function_handle')
    error('Surf_Map must be a function handle!');
else
    % check the dimension
    SP = Surf_Map(0,0);
    if (length(SP) < 2)
        error('Not a valid surface map!');
    end
end

% compute analytic function for the curvature vector

Num_Charts = length(obj.Chart_Funcs);
Curvature_Vector_Func = cell(Num_Charts,1);
syms t real;
for ch = 1:Num_Charts
    alpha = obj.Chart_Funcs{ch};
    alpha_sym = alpha(t);
    
    % apply the surface map
    alpha_sym_mapped = Surf_Map(alpha_sym(1),alpha_sym(2));
    
    alpha_sym_deriv = diff(alpha_sym_mapped,t);
    alpha_sym_deriv_norm = sqrt(sum(alpha_sym_deriv.^2));
    TV_sym = simplify(alpha_sym_deriv / alpha_sym_deriv_norm);
    
    Curvature_Vec_sym = simplify( - diff(TV_sym,t) / alpha_sym_deriv_norm );
    %Curvature_Vector_Func{ch} = matlabFunction(Curvature_Vec_sym,'Vars',{t});
    Curvature_Vector_Func{ch} = Convert_to_Matlab_Function(Curvature_Vec_sym,t);
end

end