function Num_Deriv = Number_Of_Derivatives_For_Opt(obj,Opt)
%Number_Of_Derivatives_For_Opt
%
%   This computes the highest order derivatives (number) needed to evaluate the
%   map (PHI) quantities in Opt.

% Copyright (c) 04-03-2018,  Shawn W. Walker

Num_Deriv = 0; % init

% check the quantities that require one derivative
Deriv_One = Opt.Grad | Opt.Metric | Opt.Det_Metric | Opt.Inv_Det_Metric |...
            Opt.Inv_Metric | Opt.Det_Jacobian | Opt.Det_Jacobian_with_quad_weight |...
            Opt.Inv_Det_Jacobian | Opt.Inv_Grad | Opt.Tangent_Vector |...
            Opt.Normal_Vector; % | Opt.Tangent_Space_Projection;
if (Deriv_One)
    Num_Deriv = 1;
end

% check the quantities that require two derivatives
Deriv_Two = Opt.Hess | Opt.Hess_Inv_Map | Opt.Grad_Metric | Opt.Grad_Inv_Metric | Opt.Christoffel_2nd_Kind |...
            Opt.Second_Fund_Form | Opt.Det_Second_Fund_Form | Opt.Inv_Det_Second_Fund_Form |...
            Opt.Total_Curvature_Vector | Opt.Total_Curvature | Opt.Gauss_Curvature |...
            Opt.Shape_Operator;
if (Deriv_Two)
    Num_Deriv = 2;
end

end