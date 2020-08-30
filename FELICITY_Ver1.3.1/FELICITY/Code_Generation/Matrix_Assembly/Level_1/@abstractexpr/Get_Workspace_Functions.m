function Funcs = Get_Workspace_Functions(obj,Sym_Expression)
%Get_Workspace_Functions
%
%   This finds the (outer workspace) functions that appear in the symbolic expression
%   'Sym_Expression'; only acknowledges Test, Trial and Coef(s).
%
%   Funcs = obj.Get_Workspace_Functions(Sym_Expression);
%
%   Sym_Expression = (sym) expression.
%
%   Funcs = cell array of strings representing the function names that were
%           found in 'Sym_Expression'; only contains Test, Trial and Coef(s).

% Copyright (c) 01-23-2014,  Shawn W. Walker

% get string matching
CONST = ReferenceFiniteElement(constant_one(),true);
BF = FiniteElementBasisFunction(CONST);
Basis_MATCH_STR = BF.Get_String_Match_Struct;
Basis_MATCH_STR = struct2cell(Basis_MATCH_STR);
Num_Basis_Match = length(Basis_MATCH_STR);

S_Vars = symvar(Sym_Expression);
Num_Vars = length(S_Vars);

Funcs = containers.Map(); % init
for ind = 1:Num_Vars
    Var_Str = char(S_Vars(ind));
    % check for basis or coefficient function
    for bi = 1:Num_Basis_Match
        [tokens, names] = regexp(Var_Str, ['(\w*)', Basis_MATCH_STR{bi}], 'tokens', 'names');
        if ~isempty(tokens)
            Name = tokens{1}{1};
            Funcs(Name) = Name;
            break;
        end
    end
end

Funcs = Funcs.keys; % return a cell array of name strings

end