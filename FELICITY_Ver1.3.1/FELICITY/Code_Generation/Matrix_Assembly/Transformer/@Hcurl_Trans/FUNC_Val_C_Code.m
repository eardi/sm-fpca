function CODE = FUNC_Val_C_Code(obj)
%FUNC_Val_C_Code
%
%   Generate C-code for direct evaluation of vv.
%         [vv_1, ..., vv_j]_k(qp) = [vv_1, ..., vv_j]_k(qp), where vv_j is
%                                   the jth component and _k denotes the kth
%                                   basis function, and qp are the coordinates
%                                   of a quadrature point.

% Copyright (c) 10-17-2016,  Shawn W. Walker

TD = obj.GeoMap.TopDim;
GD = obj.GeoMap.GeoDim;
if (TD < 2)
    error('Topological dimension must at least be 2!');
end
if (TD~=GD)
    disp('Not implemented!');
    CODE = [];
    return;
end

% make var string
vv_Val_str = obj.Output_CPP_Var_Name('Val');

TAB = '    ';

% is geometric transformation constant?
if obj.GeoMap.Is_Quantity_Constant('Grad'); % grad(PHI)
    % then jacobian is constant!
    QP_str = '[0]';
else % it is non-linear (varies over the quad points)
    QP_str = '[qp_i]';
end
Inv_Grad_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Inv_Grad');
Inverse_G_MAT = ['Mesh->', Inv_Grad_CPP_Name, QP_str];

if obj.INTERPOLATION
    Vector_Basis_CPP = 'phi_Val[basis_i]';
else
    Vector_Basis_CPP = 'phi_Val[qp_i][basis_i]';
end
Basis_Sign_CPP   = 'Basis_Sign[basis_i]';

% loop thru all components of the map
TYPE_str = obj.Get_CPP_Vector_Data_Type_Name(obj.GeoMap.GeoDim);
% code is dimension independent, almost!
EVAL_STR( 4).line = []; % init
EVAL_STR( 1).line = ['for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)'];
EVAL_STR( 2).line = [TAB, '{'];
if (TD==2)
    EVAL_STR( 3).line = [TAB, TYPE_str, ' vv_temp;'];
    EVAL_STR( 4).line = [TAB, '// multiply by sign change'];
    EVAL_STR( 5).line = [TAB, 'Scalar_Mult_Vector(', Vector_Basis_CPP, ', ', Basis_Sign_CPP, ', vv_temp', ');'];
    EVAL_STR( 6).line = [TAB, '// multiply by inverse Jacobian matrix transpose'];
    EVAL_STR( 7).line = [TAB, 'Mat_Transpose_Vec(', Inverse_G_MAT, ', vv_temp, ', vv_Val_str, '[basis_i][qp_i]', ');'];
elseif (TD==3)
    EVAL_STR( 3).line = [TAB, '// multiply by inverse Jacobian matrix transpose'];
    EVAL_STR( 4).line = [TAB, 'Mat_Transpose_Vec(', Inverse_G_MAT, ', ', Vector_Basis_CPP, ', ', vv_Val_str, '[basis_i][qp_i]', ');'];
end
EVAL_STR(end+1).line = [TAB, '}']; % close the basis loop

% define the data type
Defn_Hdr = '// vector valued H(curl) basis functions';
Loop_Hdr = '// map basis vectors over (indexing is in the C style)';
Loop_Comment = '// evaluate for each basis function';
CONST_VAR = obj.Is_Quantity_Constant('Val');
CODE = obj.create_basis_func_declaration_and_eval_code(vv_Val_str,TYPE_str,EVAL_STR,...
                             Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%

end