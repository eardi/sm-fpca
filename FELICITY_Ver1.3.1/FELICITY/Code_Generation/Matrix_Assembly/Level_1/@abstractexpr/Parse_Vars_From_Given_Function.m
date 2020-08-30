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
%                 Note: if the tuple size is [m, n], then N = m*n.

% Copyright (c) 03-24-2018,  Shawn W. Walker

MATCH_STR.vv_tt   = '_v[1-9][1-9]?_t([1-9])([1-9]?)\w*';
MATCH_STR.tt_div  = '_t([1-9])([1-9]?)_div';
MATCH_STR.tt_scalar_curl = '_t([1-9])([1-9]?)_curl';

Num_Tuple   = L1Func.Num_Tensor;
TEMP_Func   = cell(Num_Tuple(1),Num_Tuple(2));

Num_Vars = length(Vars);
for vv = 1:Num_Vars
    var_str = char(Vars(vv));
    Match_EXPR = [L1Func.Name, MATCH_STR.vv_tt];
    m = regexp(var_str, Match_EXPR, 'tokens');
    if ~isempty(m)
        m_match = regexp(var_str, Match_EXPR, 'match');
        [ti_1, ti_2] = extract_tuple_index(var_str,Num_Tuple,m);
        TEMP_Func{ti_1,ti_2} = [TEMP_Func{ti_1,ti_2}, sym(m_match)];
    else
        % check if it was the divergence...
        Match_EXPR = [L1Func.Name, MATCH_STR.tt_div];
        m = regexp(var_str, Match_EXPR, 'tokens');
        if ~isempty(m)
            m_match = regexp(var_str, Match_EXPR, 'match');
            [ti_1, ti_2] = extract_tuple_index(var_str,Num_Tuple,m);
            TEMP_Func{ti_1,ti_2} = [TEMP_Func{ti_1,ti_2}, sym(m_match)];
        else
            % check if it was the scalar curl...
            Match_EXPR = [L1Func.Name, MATCH_STR.tt_scalar_curl];
            m = regexp(var_str, Match_EXPR, 'tokens');
            if ~isempty(m)
                m_match = regexp(var_str, Match_EXPR, 'match');
                [ti_1, ti_2] = extract_tuple_index(var_str,Num_Tuple,m);
                TEMP_Func{ti_1,ti_2} = [TEMP_Func{ti_1,ti_2}, sym(m_match)];
            else
%                 L1Func.Name
%                 var_str
%                 error('This variable was not identified!');
            end
        end
    end
end
Parsed_Func = TEMP_Func(:); % collapse to linear index

% for kk = 1:length(Parsed_Func)
%     Parsed_Func{kk}
% end

% Num_Vars    = length(Vars);
% for ti_1 = 1:Num_Tuple(1)
% for ti_2 = 1:Num_Tuple(2)
%     row_sym = [];
%     for vv = 1:Num_Vars
%         var_str = char(Vars(vv));
%         Match_EXPR = [L1Func.Name, '_v[1-9][1-9]?_t', num2str(ti_1), num2str(ti_2), '\w*'];
%         m = regexp(var_str, Match_EXPR, 'match');
%         if ~isempty(m)
%             row_sym = [row_sym, sym(m)];
%         else
%             % check if it was the divergence...
%             Match_EXPR = [L1Func.Name, '_t', num2str(ti_1), num2str(ti_2), '_div'];
%             m = regexp(var_str, Match_EXPR, 'match');
%             if ~isempty(m)
%                 row_sym = [row_sym, sym(m)];
%             end
%         end
%     end
%     kk = ti_1 + (ti_2 - 1)*Num_Tuple(1); % k = i + (j-1)*m
%     Parsed_Func{kk} = row_sym;
% end
% end

end

function [ti_1, ti_2] = extract_tuple_index(var_str,Num_Tuple,mm)

tt_ind = mm{1};
ti_1 = str2double(tt_ind{1});
if ~isempty(tt_ind{2})
    ti_2 = str2double(tt_ind{2});
else
    ti_2 = 1;
end
if or((ti_1 > Num_Tuple(1)),(ti_2 > Num_Tuple(2)))
    var_str
    error('Variable has a tuple index greater than what it is supposed to!');
end

end