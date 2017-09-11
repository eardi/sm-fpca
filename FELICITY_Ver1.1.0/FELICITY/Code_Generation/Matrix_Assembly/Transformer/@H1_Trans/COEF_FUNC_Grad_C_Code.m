function CODE = COEF_FUNC_Grad_C_Code(obj)
%COEF_FUNC_Grad_C_Code
%
%   Generate C-code for computing coefficient functions.
%       \nabla f_i(qp) = SUM^{NUM_BASIS}_{k=1} c_{ik} * \nabla phi_k(qp), where
%                        phi_k is the kth mapped basis function,
%                        f_i is the ith component of the coef. function, and
%                        qp are the coordinates of a quadrature point.

% Copyright (c) 08-10-2014,  Shawn W. Walker

TAB = '    ';
TAB2 = [TAB, TAB];

% make var string
f_Grad_str = obj.Output_CPP_Var_Name('Grad');

if and(obj.GeoMap.TopDim==1,obj.GeoMap.GeoDim > 1) % curve in higher dimensions
    % in this case, the gradient on a curve \Sigma (tangential gradient) is written as:
    % \nabla_{\Sigma} = \vt d/ds,  where \vt is the tangent vector.
    % so, in order to compute the tangential of a coefficient function on a 1-D curve
    % domain, we first compute the arc-length derivative of the function (this happens
    % elsewhere).  THEN, we simply multiply by the tangent vector.
    
    % make var string
    f_d_ds_str = obj.Output_CPP_Var_Name('d_ds');
    CF = [f_Grad_str, '[nc_i][qp_i]'];
    CF_d_ds = [f_d_ds_str, '[nc_i][qp_i]']; % previously computed d/ds of coef func.
    TV_str = obj.GeoMap.Output_CPP_Var_Name('Tangent_Vector');
    if obj.GeoMap.Is_Quantity_Constant('Tangent_Vector')
        QP_str = '[0]';
    else
        QP_str = '[qp_i]';
    end
    Mesh_Tangent_str = ['basis_func->Mesh->', TV_str, QP_str];
    
    % loop thru all components of the coefficient function
    EVAL_STR(5).line = []; % init
    EVAL_STR(1).line = ['for (int nc_i = 0; (nc_i < Num_Comp); nc_i++)'];
    EVAL_STR(2).line = [TAB, '{'];
    EVAL_STR(3).line = [TAB, '// compute the 1-D gradient (i.e. \vt * d/ds) of the function'];
    EVAL_STR(4).line = [TAB, 'Scalar_Mult_Vector(', Mesh_Tangent_str, ', ', CF_d_ds, ', ', CF, ');'];
    EVAL_STR(5).line = [TAB, '}'];
else
    % make var string
    BF  = ['basis_func->', f_Grad_str, '[basis_i][qp_i]'];
    BF0 = ['basis_func->', f_Grad_str, '[0][qp_i]'];
    CF  = [f_Grad_str, '[nc_i][qp_i]'];
    VEC_Dx1_str = obj.Get_CPP_Vector_Data_Type_Name(obj.GeoMap.GeoDim);
    
    % loop thru all components of the coefficient function
    EVAL_STR(11).line = []; % init
    EVAL_STR( 1).line = ['for (int nc_i = 0; (nc_i < Num_Comp); nc_i++)'];
    EVAL_STR( 2).line = [TAB, '{'];
    EVAL_STR( 3).line = [TAB, 'Scalar_Mult_Vector(', BF0, ', ', 'Node_Value[nc_i][kc[0]]', ', ', CF, ');'];
    EVAL_STR( 4).line = [TAB, '// sum over basis functions'];
    EVAL_STR( 5).line = [TAB, 'for (int basis_i = 1; (basis_i < NB); basis_i++)'];
    EVAL_STR( 6).line = [TAB2, '{'];
    EVAL_STR( 7).line = [TAB2, VEC_Dx1_str, '  Temp_VEC;'];
    EVAL_STR( 8).line = [TAB2, 'Scalar_Mult_Vector(', BF, ', ', 'Node_Value[nc_i][kc[basis_i]]', ', Temp_VEC);'];
    EVAL_STR( 9).line = [TAB2, 'Add_Vector(', CF, ', Temp_VEC, ', CF, ');'];
    EVAL_STR(10).line = [TAB2, '}'];
    EVAL_STR(11).line = [TAB, '}'];
end

% define the data type
TYPE_str = obj.Get_CPP_Vector_Data_Type_Name(obj.GeoMap.GeoDim);
Defn_Hdr = '// (intrinsic) gradient of coefficient function';
Loop_Hdr = '// get gradient of coefficient function';
Loop_Comment = '// loop through all components (indexing is in the C style)';
CONST_VAR = obj.Is_Quantity_Constant('Grad');
CODE = obj.create_coef_func_declaration_and_eval_code(f_Grad_str,TYPE_str,EVAL_STR,...
                            Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%
end