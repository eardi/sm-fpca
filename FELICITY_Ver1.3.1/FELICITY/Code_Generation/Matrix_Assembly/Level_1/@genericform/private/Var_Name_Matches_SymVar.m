function MATCH = Var_Name_Matches_SymVar(FUNC,SymVar)
%Var_Name_Matches_SymVar
%
%   This checks if FUNC.Name matches the symbolic (sym) variable SymVar.  It returns true
%   or false accordingly.
%
%   MATCH = Var_Name_Matches_SymVar(FUNC,SymVar);
%
%   MATCH = (see above).

% Copyright (c) 10-18-2016,  Shawn W. Walker

% see these other files for how variable names are formatted:
%     "Get_String_Match_Struct"
%     "Is_Variable_Present"
FUNC_STR = ['_v[1-9][1-9]?_t[1-9][1-9]?', '\w*'];
FUNC_div_STR = '_t[1-9][1-9]?_div';
FUNC_scalar_curl_STR = '_t[1-9][1-9]?_curl';

% initialize
Match_FUNC             = [FUNC.Name, FUNC_STR];
Match_FUNC_div         = [FUNC.Name, FUNC_div_STR];
Match_FUNC_scalar_curl = [FUNC.Name, FUNC_scalar_curl_STR];

% make symbolic variable a string
sym_var_str = char(SymVar);

% see if the given FUNC matches the symbolic variable
m = regexp(sym_var_str, Match_FUNC, 'match');
if isempty(m)
    % just in case, check if it was the divergence...
    m = regexp(sym_var_str, Match_FUNC_div, 'match');
end
if isempty(m)
    % just in case, check if it was the scalar curl...
    m = regexp(sym_var_str, Match_FUNC_scalar_curl, 'match');
end

% we are not done yet!
% for example, suppose
%     sym_var_str = 'nu_v1_t2'
%     FUNC.Name = 'u'
% then, m = 'u_v1_t2' (there should not be a match!)
%
% so, we have to make an additional check to make sure they really are the same variable!

if strcmp(m,sym_var_str)
    % then they really are the same variable
    MATCH = true;
else
    % they are NOT the same variable
    MATCH = false;
end

end