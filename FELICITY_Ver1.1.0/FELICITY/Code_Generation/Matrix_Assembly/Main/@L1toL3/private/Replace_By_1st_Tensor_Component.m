function Integrand_sym_NEW = Replace_By_1st_Tensor_Component(L1Func,Integrand_sym)
%Replace_By_1st_Tensor_Component
%
%   This makes either Test or Trial functions use the first tensor component in
%   the symbolic expression.

% Copyright (c) 08-01-2011,  Shawn W. Walker

% init
Integrand_sym_NEW = Integrand_sym;
Vars = symvar(Integrand_sym);
Num_Vars = length(Vars);

for vi = 1:Num_Vars
    old_var = Vars(vi);
    var_str = char(old_var);
    Match_EXPR = [L1Func.Name, '_v([1-9])_t([1-9])', '\w*'];
    mt = regexp(var_str, Match_EXPR, 'match');
    if ~isempty(mt)
        % replace with first tensor component
        new_var_str = mt{1};
        LOC_tensor_comp = length(L1Func.Name) + 6;
        new_var_str(LOC_tensor_comp) = '1'; % set component to 1
        new_var = sym(new_var_str);
        Integrand_sym_NEW = subs(Integrand_sym_NEW,old_var,new_var);
    end
end

end