function CPP_Eval = Output_CPP_Eval_Extension(obj,FIELD_str,Components)
%Output_CPP_Eval_Extension
%
%   This outputs a string representing the C++ evaluation code for the given
%   constant name.
%
%   Components = [basis_comp_1, basis_comp_2, comp_1, comp_2, etc...]

% Copyright (c) 01-11-2018,  Shawn W. Walker

% % peel off the vector component
% Vec_Comp = Components(1);
% Components = Components(2:end);

if strcmp(FIELD_str,'Val')
    CPP_Eval = ['.a'];
else
    error('Not valid!');
end

end

% function INDEX_str = Get_Index_String(Index)
% 
% % use C-style indexing
% INDEX_str = ['[', num2str(Index - 1), ']'];
% 
% end