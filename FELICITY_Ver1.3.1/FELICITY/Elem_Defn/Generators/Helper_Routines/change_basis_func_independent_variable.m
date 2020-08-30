function New_BF = change_basis_func_independent_variable(BF,old_var,new_var)
%change_basis_func_independent_variable
%
%   Change the independent variables in the given basis functions.
%
%   Note:  BF(:).Func contains symbolic functions.
%          old_var, new_var are cell arrays of symbolic variables.

% Copyright (c) 09-27-2016,  Shawn W. Walker

New_BF = BF; % init
for ii = 1:length(BF)
    New_BF(ii).Func = subs(BF(ii).Func,old_var,new_var);
end

end