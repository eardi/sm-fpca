function Integrand_sym_NEW = Replace_Function_In_Integral(Func_Name_A,Func_Name_B,Integrand_sym)
%Replace_Function_In_Integral
%
%   This replaces every instance of "Func_Name_A" appearing in "L2_Obj_Integral"
%   with "Func_Name_B".
%   For example, if L1Func_A.Name = 'v', and L1Func_B.Name = 'u', then this will
%   replace 'v_v1_t2_grad1' by 'u_v1_t2_grad1'.

% Copyright (c) 08-01-2011,  Shawn W. Walker

Integrand_sym_NEW = Integrand_sym; % init
Vars = symvar(Integrand_sym);
Num_Vars = length(Vars);

LEN_A = length(Func_Name_A);
%LEN_B = length(Func_Name_B);

for vi = 1:Num_Vars
    old_var = Vars(vi);
    var_str = char(old_var);
    Match_EXPR = [Func_Name_A, '_v([1-9])_t([1-9])', '\w*'];
    mt = regexp(var_str, Match_EXPR, 'match');
    if ~isempty(mt)
        new_var_str = mt{1};
        new_var_str = [Func_Name_B, new_var_str(LEN_A+1:end)];
        new_var = sym(new_var_str);
        Integrand_sym_NEW = subs(Integrand_sym_NEW,old_var,new_var);
    end
end

end