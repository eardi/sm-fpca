function [Vector_Comp, Tensor_Comp] = Parse_Vector_Tensor_Components(obj,input_str,var_str)
%Parse_Vector_Tensor_Components
%
%   This parses the vector and tensor components in the symbolic variable
%   string.

% Copyright (c) 03-27-2012,  Shawn W. Walker

len_var_str = length(var_str);

% setup matching strings
MATCH_STR_tensor_only    = '_t[123456789]';
MATCH_STR_vector_tensor  = '_v[123456789]_t[123456789]';

if ~isempty(regexp(input_str,[var_str, MATCH_STR_tensor_only], 'once'))
    % there is no vector component!
    Vector_Comp = 1; % assume ``1''
    % parse function (tensor) component
    Tensor_Comp_str = input_str(len_var_str+3);
    Tensor_Comp     = str2double(Tensor_Comp_str);
elseif ~isempty(regexp(input_str,[var_str, MATCH_STR_vector_tensor], 'once'))
    % parse function (vector) component
    Vector_Comp_str = input_str(len_var_str+3);
    Vector_Comp     = str2double(Vector_Comp_str);
    % parse function (tensor) component
    Tensor_Comp_str = input_str(len_var_str+6);
    Tensor_Comp     = str2double(Tensor_Comp_str);
else
    Vector_Comp = 1; % assume ``1''
    Tensor_Comp = 1; % assume ``1''
end

if Vector_Comp > obj.Elem.Num_Vec_Comp
    error('Chosen *vector* component greater than the number of components of the finite element space/function.');
end
if Tensor_Comp > obj.Elem.Num_Comp
    error('Chosen tensor component greater than the number of components of the finite element space/function.');
end

end