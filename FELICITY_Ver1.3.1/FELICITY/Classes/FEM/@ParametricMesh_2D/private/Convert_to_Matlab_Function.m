function m_func = Convert_to_Matlab_Function(sym_func,sym_var)
%Convert_to_Matlab_Function
%
%   This provides robust conversion of symbolic function to a
%   matlabFunction that is properly vectorized.

% Copyright (c) 05-09-2020,  Shawn W. Walker

[NR, NC] = size(sym_func);

if (NR~=1)
    error('Not implemented!');
end

for jj=1:NC
    CHK_const = diff(sym_func(jj),sym_var);
    if CHK_const==sym(0)
        sym_func(jj) = sym_func(jj) + 1e-20*sym_var;
    end
end

m_func = matlabFunction(sym_func,'Vars',{sym_var});

end