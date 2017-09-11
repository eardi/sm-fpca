function Parsed_Func = Parse_Vars_From_Given_Function(obj,L1Func,Vars)
%Parse_Vars_From_Given_Function
%
%   This takes a given list of symbolic variables, finds the ones that
%   correspond to the given function, and returns a structure containing those
%   function vars.  Each row of the output structure corresponds to a specific
%   tensor component, and contains symbolic representations of operators applied
%   to the given function.
%
%   Parsed_Func = obj.Parse_Vars_From_Given_Function(L1Func,Vars);
%
%   L1Func = a Level 1 l1func object (i.e. Test, Trial, or Coef).
%   Vars   = array of sym (symbolic) objects.
%
%   Parsed_Func = Nx1 cell array of sym row vectors.  N = number of tensor
%                 components of L1Func.  Each sym row vector contains several
%                 sym entries, each one represents a match between L1Func and
%                 one of the entries in the given 'Vars' list.

% Copyright (c) 08-01-2011,  Shawn W. Walker

Num_Tensor  = L1Func.Num_Tensor;
Parsed_Func = cell(Num_Tensor,1);

Num_Vars    = length(Vars);
for ind = 1:Num_Tensor
    row_sym = [];
    for vi = 1:Num_Vars
        var_str = char(Vars(vi));
        Match_EXPR = [L1Func.Name, '_v[1-9]_t', num2str(ind), '\w*'];
        m = regexp(var_str, Match_EXPR, 'match');
        if ~isempty(m)
            row_sym = [row_sym, sym(m)];
        else
            % check if it was the divergence...
            Match_EXPR = [L1Func.Name, '_t', num2str(ind), '_div'];
            m = regexp(var_str, Match_EXPR, 'match');
            if ~isempty(m)
                row_sym = [row_sym, sym(m)];
            end
        end
    end
    Parsed_Func{ind} = row_sym;
end

end