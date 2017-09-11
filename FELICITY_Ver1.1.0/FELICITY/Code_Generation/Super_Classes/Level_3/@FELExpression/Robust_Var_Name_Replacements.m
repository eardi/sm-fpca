function [New_Sym_Exp, New_Var_Names] = Robust_Var_Name_Replacements(obj,Sym_Exp,Var_Names)
%Robust_Var_Name_Replacements
%
%   This replaces all the variable names in the symbolic expression ``Sym_Exp''
%   with new variable names that have DISTINCT names.  This is done to ensure
%   that no name is a subset of another one, which can screw up the text
%   replacements.  The list of variable names is given in ``Var_Names''.
%
%   Note: these replacements are done symbolically, so it won't get confused!

% Copyright (c) 04-10-2012,  Shawn W. Walker

% init
New_Sym_Exp = Sym_Exp;
New_Var_Names = Var_Names;

% create new distinct variable names
Num_Vars = length(Var_Names(:));
for ind = 1:Num_Vars
    Var_Name_str = Get_Indexed_Var_Name(ind);
    New_Var_Names(ind) = sym(Var_Name_str);
end

subs_H = FEL_subs_handle();

for ind = 1:Num_Vars
    New_Sym_Exp = subs_H(New_Sym_Exp,Var_Names(ind),New_Var_Names(ind));
end

end

function Var_Name_str = Get_Indexed_Var_Name(index)

if index > 100000
    error('This index is too big!');
end
index_str = num2str(index);
len_index_str = length(index_str);

padded_index_str = '000000';
padded_index_str(end - len_index_str + 1:end) = index_str;

Var_Name_str = ['FELICITYVARNAMEABC', padded_index_str, 'XYZ'];

end