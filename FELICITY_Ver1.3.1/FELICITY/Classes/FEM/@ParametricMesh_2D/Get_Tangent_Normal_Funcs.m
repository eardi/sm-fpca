function [Tangent_Func, Normal_Func] = Get_Tangent_Normal_Funcs(obj,Surf_Map)
%Get_Tangent_Normal_Funcs
%
%   This returns function handles for evaluating the tangent and normal
%   vectors, i.e.
%
%              \tv(\xi) = \alpha_{i}'(\xi) / |\alpha_{i}'(\xi)|,
%              \nv(\xi) = PERP{\tv(\xi)}.
%
%   [Tangent_Func, Normal_Func] = obj.Get_Tangent_Normal_Funcs();
%
%   Note: assuming the chart is positively oriented, then the tangent
%   vector is in the direction of the orientation, and the normal vector
%   points *outside* of the domain.
%
%   [Tangent_Func, Normal_Func] = obj.Get_Tangent_Normal_Funcs(Surf_Map);
%
%   In this case, we pass an additional function handle that represents a
%   surface mapping, i.e. a map from R^2 to R^3.  Then the boundary of the
%   reference domain is mapped to the boundary of the surface.  Moreover,
%   the tangent and normal functions reflect this.

% Copyright (c) 05-07-2020,  Shawn W. Walker

if (nargin==1)
    Surf_Map = @(u, v) [u, v];
    Surf_Normal = [];
elseif isempty(Surf_Map)
    Surf_Map = @(u, v) [u, v];
    Surf_Normal = [];
elseif ~isa(Surf_Map,'function_handle')
    error('Surf_Map must be a function handle!');
else
    % check the dimension
    SP = Surf_Map(0,0);
    if (length(SP) < 2)
        error('Not a valid surface map!');
    end
    
    % symbolic surface map
    syms u v real;
    chi_sym = Surf_Map(u,v);
    
    % compute the surface normal
    chi_du = diff(chi_sym,u);
    chi_dv = diff(chi_sym,v);
    SN_numerator = cross(chi_du,chi_dv);
    SN_MAG = sqrt(sum(SN_numerator.^2));
    Surf_Normal = SN_numerator / SN_MAG;
end

% compute analytic functions for the tangent and normal vector

Num_Charts   = length(obj.Chart_Funcs);
Tangent_Func = cell(Num_Charts,1);
Normal_Func  = cell(Num_Charts,1);
syms t real;
for ch = 1:Num_Charts
    alpha = obj.Chart_Funcs{ch};
    alpha_sym = alpha(t);
    
    % apply the surface map
    alpha_sym_mapped = Surf_Map(alpha_sym(1),alpha_sym(2));
    
    % unit tangent
    alpha_sym_deriv = diff(alpha_sym_mapped,t);
    alpha_sym_deriv_norm = sqrt(sum(alpha_sym_deriv.^2));
    TV_sym = alpha_sym_deriv / alpha_sym_deriv_norm;
    %Tangent_Func{ch} = matlabFunction(TV_sym,'Vars',{t});
    Tangent_Func{ch} = Convert_to_Matlab_Function(TV_sym,t);
    
    % unit (co)-normal
    if isempty(Surf_Normal)
        % just rotate the tangent
        NV_sym = [TV_sym(2), -TV_sym(1)];
    else
        % compute it!
        Surf_Normal_sym = subs(Surf_Normal,{'u', 'v'},{alpha_sym(1), alpha_sym(2)});
        NV_sym = simplify(cross(TV_sym,Surf_Normal_sym));
    end
    %Normal_Func{ch} = matlabFunction(NV_sym,'Vars',{t});
    Normal_Func{ch} = Convert_to_Matlab_Function(NV_sym,t);
end

end