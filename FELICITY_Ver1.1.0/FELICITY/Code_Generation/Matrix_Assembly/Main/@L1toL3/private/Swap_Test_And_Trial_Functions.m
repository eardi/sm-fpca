function Integrand_sym_Swapped = Swap_Test_And_Trial_Functions(L2_Obj_Integral)
%Swap_Test_And_Trial_Functions
%
%   This switched the test and trial functions in the integrand.

% Copyright (c) 06-25-2012,  Shawn W. Walker

Integrand_sym = L2_Obj_Integral.Arg;

TEMP_Test_Name = ['XXX', L2_Obj_Integral.TestF.Name, 'XXX'];

Integrand_sym_1 = Replace_Function_In_Integral(L2_Obj_Integral.TestF.Name,TEMP_Test_Name,Integrand_sym);

Integrand_sym_2 = Replace_Function_In_Integral(L2_Obj_Integral.TrialF.Name,L2_Obj_Integral.TestF.Name,Integrand_sym_1);

Integrand_sym_Swapped = Replace_Function_In_Integral(TEMP_Test_Name,L2_Obj_Integral.TrialF.Name,Integrand_sym_2);

end