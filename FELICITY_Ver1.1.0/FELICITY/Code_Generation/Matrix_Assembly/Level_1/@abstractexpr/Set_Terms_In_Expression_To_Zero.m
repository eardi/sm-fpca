function Sym_Expression_NEW = Set_Terms_In_Expression_To_Zero(obj,Sym_Expression,Vars)
%Set_Terms_In_Expression_To_Zero
%
%   This replaces any symbolic variables in Sym_Expression, that are in the list
%   Vars, by zero.
%
%   Sym_Expression_NEW = obj.Set_Terms_In_Expression_To_Zero(Sym_Expression,Vars);
%
%   Sym_Expression = (sym) object.
%   Vars = cell array of variable names.
%
%   Sym_Expression_NEW = similar to previous, except modified.

% Copyright (c) 01-24-2014,  Shawn W. Walker

% init
Sym_Expression_NEW = Sym_Expression;

subs_H = FEL_subs_handle();

for i1 = 1:length(Vars)
    for j1 = 1:length(Vars{i1})
        Sym_Expression_NEW = subs_H(Sym_Expression_NEW,Vars{i1}(j1),0);
    end
end

end