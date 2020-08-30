function Dom_Names = Get_Geometric_Function_Domain_Names(obj,Sym_Expression)
%Get_Geometric_Function_Domain_Names
%
%   This finds any geometric functions appearing in the symbolic expression
%   'Sym_Expression'; they can be from any domain!
%
%   Dom_Names = obj.Get_Geometric_Function_Domain_Names(Sym_Expression);
%
%   Sym_Expression = (sym) expression.
%
%   Dom_Names = cell array of string names of the geometric domains corresponding to
%               geometric functions found in 'Sym_Expression'.

% Copyright (c) 01-23-2014,  Shawn W. Walker

% get string matching
CONST = ReferenceFiniteElement(constant_one(),true);
GF = GeometricElementFunction(CONST,[]);
Geom_MATCH_STR = GF.Get_String_Match_Struct;
Geom_MATCH_STR = struct2cell(Geom_MATCH_STR);
Num_Geom = length(Geom_MATCH_STR);

S_Vars = symvar(Sym_Expression);
Num_Vars = length(S_Vars);

Dom_Names = containers.Map(); % init
for ind = 1:Num_Vars
    Var_Str = char(S_Vars(ind));
    
    % check for geometric functions
    for gi = 1:Num_Geom
        [tokens, names] = regexp(Var_Str, ['(\w*)', Geom_MATCH_STR{gi}], 'tokens', 'names');
        if ~isempty(tokens)
            Name = tokens{1}{1};
            % error check
            if ~strncmp(Name,'geom',4)
                disp(['This supposed geometric function: ', Var_Str]);
                disp(['     does not have a "geom" prefix.  This should not have happened!']);
                error('stop!');
            end
            % peel off the "geom" prefix to get the domain name
            Domain_Name = Name(5:end);
            Dom_Names(Domain_Name) = Domain_Name;
            break;
        end
    end
end

Dom_Names = Dom_Names.keys; % get a cell array of name strings

end