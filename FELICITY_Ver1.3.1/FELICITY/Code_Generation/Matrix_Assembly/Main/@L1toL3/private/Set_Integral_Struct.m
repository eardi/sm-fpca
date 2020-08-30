function L2_Obj_Integral = Set_Integral_Struct(Name,Domain,TestF,TrialF,SI,RI,CI,Integrand_str,Integrand_sym)
%Set_Integral_Struct
%
%   This outputs a convenient struct.

% Copyright (c) 06-25-2012,  Shawn W. Walker

% init
L2_Obj_Integral = Get_L2_Obj_Integral_Struct();

L2_Obj_Integral.Name      = Name;
L2_Obj_Integral.Domain    = Domain;
L2_Obj_Integral.TestF     = TestF;
L2_Obj_Integral.TrialF    = TrialF;
L2_Obj_Integral.SubMAT_Index = num2str(SI);
L2_Obj_Integral.row_index = num2str(RI);
L2_Obj_Integral.col_index = num2str(CI);
L2_Obj_Integral.Original  = Integrand_str;
L2_Obj_Integral.Arg       = Integrand_sym;
L2_Obj_Integral.COPY      = []; % this is set later...

end