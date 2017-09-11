function OUT = Make_Symbolic(obj,FUNC)
%Make_Symbolic
%
%   This converts several string arguments into symbolic variables.
%
%   OUT  = obj.Make_Symbolic(FUNC);
%
%   FUNC = MxN cell array of strings that represent symbolic variables.
%
%   OUT  = MxN matrix of (real) sym's (symbolic expressions).

% Copyright (c) 08-01-2011,  Shawn W. Walker

OUT = sym(zeros(size(FUNC)));

Num_Vars = length(OUT(:));
for ind = 1:Num_Vars
    OUT(ind) = sym(FUNC{ind},'real');
end

end