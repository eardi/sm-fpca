function CODE = COEF_FUNC_Curl_C_Code(obj)
%COEF_FUNC_Curl_C_Code
%
%   Generate C-code for computing coefficient functions.
%         vv_curl_i(qp) = SUM^{NUM_BASIS}_{k=1} c_{ik} * curl(vphi_k)(qp), where
%                        vphi_k is the kth (vector) mapped basis function,
%                        vv_i is the ith (tensor) component of the (vector)
%                        coef. function, and
%                        qp are the coordinates of a quadrature point.

% Copyright (c) 10-17-2016,  Shawn W. Walker

TD = obj.GeoMap.TopDim;
GD = obj.GeoMap.GeoDim;

% compute the curl
if (TD==2)
    if (GD==2)
        % curl is a scalar
        
        % make var string
        vv_Curl_str = obj.Output_CPP_Var_Name('Curl');
        Basis_Func_Curl_str = ['basis_func->', vv_Curl_str];
        BF  = [Basis_Func_Curl_str, '[basis_i][qp_i].a'];
        BF0 = [Basis_Func_Curl_str, '[0][qp_i].a'];
        CF = [vv_Curl_str, '[nc_i][qp_i].a'];
        TAB = '    ';
        TAB2 = [TAB, TAB];
        
        % define the data type
        TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
        
        % loop thru all (tensor) components
        EVAL_STR( 9).line = []; % init
        EVAL_STR( 1).line = ['for (int nc_i = 0; (nc_i < Num_Comp); nc_i++)'];
        EVAL_STR( 2).line = [TAB, '{'];
        EVAL_STR( 3).line = [TAB, CF, ' = Node_Value[nc_i][kc[0]] * ', BF0, ';'];
        EVAL_STR( 4).line = [TAB, '// sum over basis functions'];
        EVAL_STR( 5).line = [TAB, 'for (int basis_i = 1; (basis_i < NB); basis_i++)'];
        EVAL_STR( 6).line = [TAB2, '{'];
        EVAL_STR( 7).line = [TAB2, CF, ' += Node_Value[nc_i][kc[basis_i]] * ', BF, ';'];
        EVAL_STR( 8).line = [TAB2, '}']; % close the basis loop
        EVAL_STR( 9).line = [TAB, '}'];
    else
        error('Not implemented!');
    end
elseif (TD==3)
    % curl is a vector
    
    % make var string
    vv_Curl_str = obj.Output_CPP_Var_Name('Curl');
    Basis_Func_Curl_str = ['basis_func->', vv_Curl_str];
    BF  = [Basis_Func_Curl_str, '[basis_i][qp_i]'];
    BF0 = [Basis_Func_Curl_str, '[0][qp_i]'];
    CF = [vv_Curl_str, '[nc_i][qp_i]'];
    TAB = '    ';
    TAB2 = [TAB, TAB];
    
    % define the data type
    TYPE_str = obj.Get_CPP_Vector_Data_Type_Name(TD);
    
    % loop thru all (tensor) components
    EVAL_STR(14).line = []; % init
    EVAL_STR( 1).line = ['for (int nc_i = 0; (nc_i < Num_Comp); nc_i++)'];
    EVAL_STR( 2).line = [TAB, '{'];
    EVAL_STR( 3).line = [TAB, 'SCALAR NodeV;'];
    EVAL_STR( 4).line = [TAB, 'NodeV.a = Node_Value[nc_i][kc[0]];'];
    EVAL_STR( 5).line = [TAB, 'Scalar_Mult_Vector(', BF0, ', NodeV, ', CF, '); // first basis function'];
    EVAL_STR( 6).line = [TAB, '// sum over basis functions'];
    EVAL_STR( 7).line = [TAB, 'for (int basis_i = 1; (basis_i < NB); basis_i++)'];
    EVAL_STR( 8).line = [TAB2, '{'];
    EVAL_STR( 9).line = [TAB2, 'NodeV.a = Node_Value[nc_i][kc[basis_i]];'];
    EVAL_STR(10).line = [TAB2, TYPE_str, '  temp_vec;'];
    EVAL_STR(11).line = [TAB2, 'Scalar_Mult_Vector(', BF, ', NodeV, ', 'temp_vec', ');'];
    EVAL_STR(12).line = [TAB2, 'Add_Vector_Self(', 'temp_vec', ', ', CF, ');'];
    EVAL_STR(13).line = [TAB2, '}']; % close the basis loop
%     EVAL_STR(14).line = [TAB, 'mexPrintf(Name);'];
%     EVAL_STR(15).line = [TAB, 'mexPrintf(":\\n");'];
%     EVAL_STR(16).line = [TAB, 'mexPrintf("curl-comp 0: %%1.15f.\\n",', CF, '.v[0]);'];
%     EVAL_STR(17).line = [TAB, 'mexPrintf("curl-comp 1: %%1.15f.\\n",', CF, '.v[1]);'];
%     EVAL_STR(18).line = [TAB, 'mexPrintf("curl-comp 2: %%1.15f.\\n",', CF, '.v[2]);'];
    EVAL_STR(14).line = [TAB, '}']; % close the component loop
else
    error('Invalid!');
end

% generate snippet
Defn_Hdr = '// curl of coefficient function evaluated at a quadrature point in reference element';
Loop_Hdr = '// get coefficient (curl) function values';
Loop_Comment = '// loop through all components (indexing is in the C style)';
CONST_VAR = obj.Is_Quantity_Constant('Curl');
CODE = obj.create_coef_func_declaration_and_eval_code(vv_Curl_str,TYPE_str,EVAL_STR,...
                            Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%

end