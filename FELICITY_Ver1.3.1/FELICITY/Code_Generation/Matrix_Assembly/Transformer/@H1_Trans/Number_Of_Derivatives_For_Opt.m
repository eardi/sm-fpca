function Num_Deriv = Number_Of_Derivatives_For_Opt(obj,Opt)
%Number_Of_Derivatives_For_Opt
%
%   This computes the highest order derivatives (number) needed to evaluate the
%   function (FUNC) quantities in Opt.

% Copyright (c) 02-20-2012,  Shawn W. Walker

Num_Deriv = 0; % init

% check the quantities that require one derivative
Deriv_One = Opt.Grad | Opt.d_ds;
if (Deriv_One)
    Num_Deriv = 1;
end

% check the quantities that require two derivatives
Deriv_Two = Opt.Hess | Opt.d2_ds2;
if (Deriv_Two)
    Num_Deriv = 2;
end

end