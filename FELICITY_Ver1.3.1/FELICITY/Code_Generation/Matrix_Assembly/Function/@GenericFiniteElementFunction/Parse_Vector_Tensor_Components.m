function [Basis_Comp, Tuple_Comp] = Parse_Vector_Tensor_Components(obj,input_str,var_str,Num_Tuple_in_FE_Space)
%Parse_Vector_Tensor_Components
%
%   This parses the vector and tuple components in the symbolic variable
%   string.

% Copyright (c) 03-22-2018,  Shawn W. Walker

% setup matching strings
MATCH_STR_tuple_comp            = '_t([123456789])([123456789]?)';
MATCH_STR_basis_comp_tuple_comp = '_v([123456789])([123456789]?)_t([123456789])([123456789]?)';

tc_index    = regexp(input_str, [var_str, MATCH_STR_tuple_comp], 'tokens');
bc_tc_index = regexp(input_str, [var_str, MATCH_STR_basis_comp_tuple_comp], 'tokens');

if ~isempty(tc_index)
    % there is no basis component!
    Basis_Comp = [1, 1]; % assume 1 x 1
    % parse function (tuple) component
    TC = tc_index{1,1};
    if ~isempty(TC{2})
        Tuple_Comp = [str2double(TC{1}), str2double(TC{2})];
    else
        Tuple_Comp = [str2double(TC{1}), 1];
    end
elseif ~isempty(bc_tc_index)
    BC_TC = bc_tc_index{1,1};
    % parse function (basis) component
    if ~isempty(BC_TC{2})
        Basis_Comp = [str2double(BC_TC{1}), str2double(BC_TC{2})];
    else
        Basis_Comp = [str2double(BC_TC{1}), 1];
    end
    % parse function (tuple) component
    if ~isempty(BC_TC{4})
        Tuple_Comp = [str2double(BC_TC{3}), str2double(BC_TC{4})];
    else
        Tuple_Comp = [str2double(BC_TC{3}), 1];
    end
else
    Basis_Comp = [1 1]; % assume 1 x 1
    Tuple_Comp = [1 1]; % assume 1 x 1
end

% determine the correct number of vector components
if or(isa(obj.FuncTrans,'Hdiv_Trans'),isa(obj.FuncTrans,'Hcurl_Trans'))
    Correct_Basis_Size = [obj.FuncTrans.GeoMap.GeoDim, 1];
    % i.e. it depends on the ambient space dimension
elseif isa(obj.FuncTrans,'Hdivdiv_Trans')
    Correct_Basis_Size = obj.FuncTrans.GeoMap.GeoDim * [1, 1];
    % i.e. it depends on the ambient space dimension
else
    Correct_Basis_Size = obj.Elem.Basis_Size;
end
% error check!
if or(Basis_Comp(1) > Correct_Basis_Size(1), Basis_Comp(2) > Correct_Basis_Size(2))
    error('Chosen *basis function* component > dimension of basis functions.');
end
if or(Tuple_Comp(1) > Num_Tuple_in_FE_Space(1), Tuple_Comp(2) > Num_Tuple_in_FE_Space(2))
    error('Chosen tuple component > number of cartesian products of the reference finite element in the global FE space.');
end

end