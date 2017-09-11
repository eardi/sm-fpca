function [GEOM, BF, CF, Ccode_Frag] =...
                Convert_Symbolic_Expression_To_CPP_snippet(obj,Symbolic_Expression,GEOM,BF,CF)
%Convert_Symbolic_Expression_To_CPP_snippet
%
%   This will parse the symbolic expression into a CPP code string.

% Copyright (c) 06-12-2014,  Shawn W. Walker

Geo_Dim = GEOM.DoI_Geom.Elem.Num_Comp;

% parse out variable names
Var_Names = symvar(Symbolic_Expression);
Num_Vars = length(Var_Names);

% init
if (Num_Vars > 0)
    Replace(Num_Vars).str = [];
else
    Replace = [];
end
% identify each variable
for ind = 1:Num_Vars
    var_name_str = char(Var_Names(ind));
    
    Replacement_str = []; % init
    
    % if there are basis functions present
    if ~isempty(BF)
        % check if it is the v
        [BF.v, Replacement_str] = BF.v.Get_Eval_String(var_name_str,BF.v_str,Geo_Dim);
        
        % check if it is the u
        if isempty(Replacement_str)
            [BF.u, Replacement_str] = BF.u.Get_Eval_String(var_name_str,BF.u_str,Geo_Dim);
        end
    end
    
    % check if it is one of the coefficient functions
    if isempty(Replacement_str)
        Num_Funcs = length(CF);
        for fi = 1:Num_Funcs
            [cf_temp, Replacement_str] = CF(fi).func.Get_Eval_String(var_name_str,CF(fi).str,Geo_Dim);
            CF(fi).func = cf_temp; % the evaluations get transfered here!
            if ~isempty(Replacement_str)
                break;
            end
        end
    end
    
    % check if it is a geometric function/predicate for the Domain of Integration or Expression
    % SWW: bad notation!
    if isempty(Replacement_str)
        [GEOM.DoI_Geom, Replacement_str] = GEOM.DoI_Geom.Get_Eval_String(var_name_str,'DoI');
    end
    
    % check if it is some other geometric function
    if isempty(Replacement_str)
        Num_GFs = length(GEOM.GF);
        for gi = 1:Num_GFs
            [gf_temp, Replacement_str] = GEOM.GF(gi).func.Get_Eval_String(var_name_str,'');
            GEOM.GF(gi).func = gf_temp; % the evaluations get transfered here!
            if ~isempty(Replacement_str)
                break;
            end
        end
    end
    
    if isempty(Replacement_str)
        disp(['The variable ', var_name_str, ' was not identified in the expression!']);
        error('Check that this is a valid variable.');
    end
    
    Replace(ind).str = Replacement_str;
end

% replace symbolic variable names with DISTINCT names
[New_Sym_Exp, New_Var_Names] = Robust_Var_Name_Replacements(obj,Symbolic_Expression,Var_Names);

Ccode_Frag = Make_Symbolic_Into_Ccode_Fragment(obj,New_Sym_Exp,New_Var_Names,Replace);

end