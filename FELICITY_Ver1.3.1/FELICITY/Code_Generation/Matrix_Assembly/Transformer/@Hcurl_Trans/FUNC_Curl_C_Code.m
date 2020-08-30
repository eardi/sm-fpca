function CODE = FUNC_Curl_C_Code(obj)
%FUNC_Curl_C_Code
%
%   Generate C-code for direct evaluation of \nabla \cdot vv.
%         vv_div_k(qp) = SUM^{DIM}_{j=1} \partial_j [vv_j]_k(qp), where vv_j is
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
vv_Curl_str = obj.Output_CPP_Var_Name('Curl');

TAB = '    ';

% is geometric transformation constant?
if obj.GeoMap.Is_Quantity_Constant('Grad'); % grad(PHI)
    % then jacobian is constant!
    QP_str = '[0]';
else % it is non-linear (varies over the quad points)
    QP_str = '[qp_i]';
end
Inv_Det_Jac_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Inv_Det_Jacobian');
INV_DET = ['Mesh->', Inv_Det_Jac_CPP_Name, QP_str, '.a'];

if obj.INTERPOLATION
    Curl_Prefix_CPP = 'phi_Curl[basis_i]';
else
    Curl_Prefix_CPP = 'phi_Curl[qp_i][basis_i]';
end

% generate snippet
EVAL_STR( 7).line = []; % init
EVAL_STR( 1).line = ['for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)'];
EVAL_STR( 2).line = [TAB, '{'];
EVAL_STR( 3).line = [TAB, '// compute curl of basis vector'];
if (TD==2)
    TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
    if (GD==2)
        Defn_Hdr = '// curl of vector valued H(curl) basis functions (curl is a scalar in 2-D)';
        
        Curl_Basis_CPP = [Curl_Prefix_CPP, '.a'];
        Basis_Sign_CPP = 'Basis_Sign[basis_i]';
        EVAL_STR( 4).line = [TAB, '// curl is a scalar in 2-D'];
        EVAL_STR( 5).line = [TAB, 'const double curl_temp = ', Basis_Sign_CPP, ' * ', Curl_Basis_CPP, '; // apply sign change'];
        EVAL_STR( 6).line = [TAB, '// multiply by 1/det(Jac)'];
        EVAL_STR( 7).line = [TAB, vv_Curl_str, '[basis_i][qp_i]', '.a', ' = ', 'curl_temp', ' * ', INV_DET, ';'];
    else
        error('Not implemented!');
    end
elseif (TD==3)
    TYPE_str = obj.Get_CPP_Vector_Data_Type_Name(TD);
    Defn_Hdr = '// curl of vector valued H(curl) basis functions (curl is a vector in 3-D)';
    
    Curl_Basis_CPP = Curl_Prefix_CPP;
    EVAL_STR( 4).line = [TAB, 'VEC_3x1 curl_temp;'];
    EVAL_STR( 5).line = [TAB, '// pre-multiply by 1/det(Jac)'];
    EVAL_STR( 6).line = [TAB, 'Scalar_Mult_Vector(', Curl_Basis_CPP, ', ', INV_DET, ', curl_temp);'];
    
    Grad_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Grad');
    Grad_MAT = ['Mesh->', Grad_CPP_Name, QP_str];
    EVAL_STR( 7).line = [TAB, '// multiply by Jacobian matrix'];
    EVAL_STR( 8).line = [TAB, 'Mat_Vec(', Grad_MAT, ', curl_temp, ', vv_Curl_str, '[basis_i][qp_i]', ');'];
else
    error('Invalid!');
end
EVAL_STR(end+1).line = [TAB, '}']; % close the basis loop

% define the data type
%Defn_Hdr = DEFINED above!
Loop_Hdr = '// map curl of basis vectors over (indexing is in the C style)';
Loop_Comment = '// evaluate for each basis function';
CONST_VAR = obj.Is_Quantity_Constant('Curl');
CODE = obj.create_basis_func_declaration_and_eval_code(vv_Curl_str,TYPE_str,EVAL_STR,...
                             Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%

end