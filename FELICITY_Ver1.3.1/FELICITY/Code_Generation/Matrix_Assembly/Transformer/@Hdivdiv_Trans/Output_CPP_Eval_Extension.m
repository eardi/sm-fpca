function CPP_Eval = Output_CPP_Eval_Extension(obj,FIELD_str,Components)
%Output_CPP_Eval_Extension
%
%   This outputs a string representing the C++ evaluation code for the given
%   variable name.
%
%   Components = [basis_comp_1, basis_comp_2, comp_1, comp_2, etc...]

% Copyright (c) 03-22-2018,  Shawn W. Walker

% peel off the basis component
Basis_Comp = Components(1:2);
Components = Components(3:end);

% if strcmp(FIELD_str,'Orientation')
%     error('you don''t need this!');
if strcmp(FIELD_str,'Val')
    Basis_Comp_C_index_STR = Get_Index_String(Basis_Comp);
    CPP_Eval = ['.m', Basis_Comp_C_index_STR];
% elseif strcmp(FIELD_str,'Div')
%     CPP_Eval = ['.a', ''];
% elseif strcmp(FIELD_str,'Grad')
%     Grad_Comp_C_index_STR = Get_Index_String(Components(1));
%     CPP_Eval = ['.v', Grad_Comp_C_index_STR];
% elseif strcmp(FIELD_str,'Hess')
%     Comp_1_C_index_STR = Get_Index_String(Components(1));
%     Comp_2_C_index_STR = Get_Index_String(Components(2));
%     CPP_Eval = ['.m', Comp_1_C_index_STR, Comp_2_C_index_STR];
else
    error('Not valid!');
end

end

function INDEX_str = Get_Index_String(Index)

% use C-style indexing
INDEX_str = ['[', num2str(Index(1) - 1), ']', '[', num2str(Index(2) - 1), ']'];

end