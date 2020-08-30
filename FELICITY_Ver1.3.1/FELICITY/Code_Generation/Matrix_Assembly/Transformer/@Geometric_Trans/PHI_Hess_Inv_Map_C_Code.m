function CODE = PHI_Hess_Inv_Map_C_Code(obj)
%PHI_Hess_Inv_Map_C_Code
%
%   Generate C-code for computing the hessian of the inverse map composed with the map,
%   i.e. evaluation of PHI.Hess_Inv_Map:
%        PHI_Hess_Inv_Map_ijk(qp) = complicated formula!

% Copyright (c) 08-07-2014,  Shawn W. Walker

if ~isempty(obj.PHI.Hess_Inv_Map) % if this concept exists!

% init (part of) output struct
EVAL_STR(2).line = []; % init

% make var string
CODE.Var_Name(1).line = []; % init
CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Hess_Inv_Map');

if (obj.GeoDim==1)
    % TopDim must be 1
    % write evaluation code
    kk = 1;
    Map_PHI_Hess_Inv_Map_str =...
            obj.Get_CPP_Tensor_Eval_String(CODE.Var_Name(1).line,kk,1,1);
    ES = [Map_PHI_Hess_Inv_Map_str, ' = ']; % init
    if ~obj.Lin_PHI_TF % map is non-linear
        % need the inverse of gradient of the map
        Inv_Grad_str = obj.Output_CPP_Var_Name('Inv_Grad');
        Inv_Grad_Quad_str = [Inv_Grad_str, '[qp_i]'];
        PHI_Inv_Grad_Matrix_EVAL_str = [Inv_Grad_Quad_str, '.m[0][0]'];
        % need hessian(PHI)
        Map_PHI_Hess_str = obj.Output_CPP_Var_Name('Hess');
        Map_PHI_Hess_Quad_str = [Map_PHI_Hess_str, '[qp_i]'];
        Map_PHI_Hess_EVAL_str = [Map_PHI_Hess_Quad_str, '.m[0][0][0]'];
        % evaluate!
        EVAL_STR(1).line = ['// compute: -(d/dx PHI)^{-3} d^2/dx^2 PHI';];
        EVAL_STR(2).line = [ES, '- ', PHI_Inv_Grad_Matrix_EVAL_str, ' * ',...
                                      PHI_Inv_Grad_Matrix_EVAL_str, ' * ',...
                                      PHI_Inv_Grad_Matrix_EVAL_str, ' * ',...
                                      Map_PHI_Hess_EVAL_str, ';'];
    else
        EVAL_STR(1).line = '// the map is linear, so the Hessian of the inverse is ZERO!';
        EVAL_STR(2).line = [ES, '0.0;'];
    end
elseif (obj.GeoDim==2)
    if (obj.TopDim==2)
        % write evaluation code
        Map_PHI_Hess_Inv_Map_Quad_str = obj.Get_Quad_Pt_CPP_Ref_Var_Name(CODE.Var_Name(1).line);
        if ~obj.Lin_PHI_TF % map is non-linear
            % need the inverse of gradient of the map
            Inv_Grad_str = obj.Output_CPP_Var_Name('Inv_Grad');
            Inv_Grad_Quad_str = [Inv_Grad_str, '[qp_i]'];
            % need hessian(PHI)
            Map_PHI_Hess_str = obj.Output_CPP_Var_Name('Hess');
            Map_PHI_Hess_Quad_str = [Map_PHI_Hess_str, '[qp_i]'];
            
            % evaluate!
            EVAL_STR( 1).line = '// extract the components of the hessian(PHI)';
            EVAL_STR( 2).line = 'MAT_2x2  Hess_Comp_0, Hess_Comp_1;';
            EVAL_STR( 3).line = [Map_PHI_Hess_Quad_str, '.Extract_Comp_Matrix(0, Hess_Comp_0);'];
            EVAL_STR( 4).line = [Map_PHI_Hess_Quad_str, '.Extract_Comp_Matrix(1, Hess_Comp_1);'];
            EVAL_STR( 5).line = 'MAT_2x2  Temp_MAT_0, Temp_MAT_1;';
            
            EVAL_STR( 6).line = '// compute component 0 of hessian(PHI^{-1}) composed with PHI';
            EVAL_STR( 7).line = ['Scalar_Mult_Matrix(Hess_Comp_0, -', Inv_Grad_Quad_str, '.m[0][0]', ', Temp_MAT_0);'];
            EVAL_STR( 8).line = ['Scalar_Mult_Matrix(Hess_Comp_1, -', Inv_Grad_Quad_str, '.m[0][1]', ', Temp_MAT_1);'];
            EVAL_STR( 9).line = ['Add_Matrix(Temp_MAT_0, Temp_MAT_1, Temp_MAT_0);'];
            EVAL_STR(10).line = ['Mat_Mat(Temp_MAT_0, ', Inv_Grad_Quad_str, ', Temp_MAT_1);'];
            EVAL_STR(11).line = ['Mat_Transpose_Mat(', Inv_Grad_Quad_str, ', Temp_MAT_1, Temp_MAT_0);'];
            EVAL_STR(12).line = [Map_PHI_Hess_Inv_Map_Quad_str, '.Set_Comp_Matrix(0, Temp_MAT_0);'];
            
            EVAL_STR(13).line = '// compute component 1 of hessian(PHI^{-1}) composed with PHI';
            EVAL_STR(14).line = ['Scalar_Mult_Matrix(Hess_Comp_0, -', Inv_Grad_Quad_str, '.m[1][0]', ', Temp_MAT_0);'];
            EVAL_STR(15).line = ['Scalar_Mult_Matrix(Hess_Comp_1, -', Inv_Grad_Quad_str, '.m[1][1]', ', Temp_MAT_1);'];
            EVAL_STR(16).line = ['Add_Matrix(Temp_MAT_0, Temp_MAT_1, Temp_MAT_0);'];
            EVAL_STR(17).line = ['Mat_Mat(Temp_MAT_0, ', Inv_Grad_Quad_str, ', Temp_MAT_1);'];
            EVAL_STR(18).line = ['Mat_Transpose_Mat(', Inv_Grad_Quad_str, ', Temp_MAT_1, Temp_MAT_0);'];
            EVAL_STR(19).line = [Map_PHI_Hess_Inv_Map_Quad_str, '.Set_Comp_Matrix(1, Temp_MAT_0);'];
        else
            EVAL_STR(1).line = '// the map is linear, so the Hessian of the inverse is ZERO!';
            EVAL_STR(2).line = [Map_PHI_Hess_Inv_Map_Quad_str, '.Set_To_Zero();'];
        end
    else
        error('Invalid!');
    end
elseif (obj.GeoDim==3)
    if (obj.TopDim==3)
        % write evaluation code
        Map_PHI_Hess_Inv_Map_Quad_str = obj.Get_Quad_Pt_CPP_Ref_Var_Name(CODE.Var_Name(1).line);
        if ~obj.Lin_PHI_TF % map is non-linear
            % need the inverse of gradient of the map
            Inv_Grad_str = obj.Output_CPP_Var_Name('Inv_Grad');
            Inv_Grad_Quad_str = [Inv_Grad_str, '[qp_i]'];
            % need hessian(PHI)
            Map_PHI_Hess_str = obj.Output_CPP_Var_Name('Hess');
            Map_PHI_Hess_Quad_str = [Map_PHI_Hess_str, '[qp_i]'];
            
            % evaluate!
            EVAL_STR( 1).line = '// extract the components of the hessian(PHI)';
            EVAL_STR( 2).line = 'MAT_3x3  Hess_Comp_0, Hess_Comp_1, Hess_Comp_2;';
            EVAL_STR( 3).line = [Map_PHI_Hess_Quad_str, '.Extract_Comp_Matrix(0, Hess_Comp_0);'];
            EVAL_STR( 4).line = [Map_PHI_Hess_Quad_str, '.Extract_Comp_Matrix(1, Hess_Comp_1);'];
            EVAL_STR( 5).line = [Map_PHI_Hess_Quad_str, '.Extract_Comp_Matrix(2, Hess_Comp_2);'];
            EVAL_STR( 6).line = 'MAT_3x3  Temp_MAT_0, Temp_MAT_1, Temp_MAT_2;';
            
            EVAL_STR( 7).line = '// compute component 0 of hessian(PHI^{-1}) composed with PHI';
            EVAL_STR( 8).line = ['Scalar_Mult_Matrix(Hess_Comp_0, -', Inv_Grad_Quad_str, '.m[0][0]', ', Temp_MAT_0);'];
            EVAL_STR( 9).line = ['Scalar_Mult_Matrix(Hess_Comp_1, -', Inv_Grad_Quad_str, '.m[0][1]', ', Temp_MAT_1);'];
            EVAL_STR(10).line = ['Scalar_Mult_Matrix(Hess_Comp_2, -', Inv_Grad_Quad_str, '.m[0][2]', ', Temp_MAT_2);'];
            EVAL_STR(11).line = ['Add_Matrix(Temp_MAT_0, Temp_MAT_1, Temp_MAT_0);'];
            EVAL_STR(12).line = ['Add_Matrix(Temp_MAT_0, Temp_MAT_2, Temp_MAT_2);'];
            EVAL_STR(13).line = ['Mat_Mat(Temp_MAT_2, ', Inv_Grad_Quad_str, ', Temp_MAT_1);'];
            EVAL_STR(14).line = ['Mat_Transpose_Mat(', Inv_Grad_Quad_str, ', Temp_MAT_1, Temp_MAT_0);'];
            EVAL_STR(15).line = [Map_PHI_Hess_Inv_Map_Quad_str, '.Set_Comp_Matrix(0, Temp_MAT_0);'];
            
            EVAL_STR(16).line = '// compute component 1 of hessian(PHI^{-1}) composed with PHI';
            EVAL_STR(17).line = ['Scalar_Mult_Matrix(Hess_Comp_0, -', Inv_Grad_Quad_str, '.m[1][0]', ', Temp_MAT_0);'];
            EVAL_STR(18).line = ['Scalar_Mult_Matrix(Hess_Comp_1, -', Inv_Grad_Quad_str, '.m[1][1]', ', Temp_MAT_1);'];
            EVAL_STR(19).line = ['Scalar_Mult_Matrix(Hess_Comp_2, -', Inv_Grad_Quad_str, '.m[1][2]', ', Temp_MAT_2);'];
            EVAL_STR(20).line = ['Add_Matrix(Temp_MAT_0, Temp_MAT_1, Temp_MAT_0);'];
            EVAL_STR(21).line = ['Add_Matrix(Temp_MAT_0, Temp_MAT_2, Temp_MAT_2);'];
            EVAL_STR(22).line = ['Mat_Mat(Temp_MAT_2, ', Inv_Grad_Quad_str, ', Temp_MAT_1);'];
            EVAL_STR(23).line = ['Mat_Transpose_Mat(', Inv_Grad_Quad_str, ', Temp_MAT_1, Temp_MAT_0);'];
            EVAL_STR(24).line = [Map_PHI_Hess_Inv_Map_Quad_str, '.Set_Comp_Matrix(1, Temp_MAT_0);'];
            
            EVAL_STR(25).line = '// compute component 2 of hessian(PHI^{-1}) composed with PHI';
            EVAL_STR(26).line = ['Scalar_Mult_Matrix(Hess_Comp_0, -', Inv_Grad_Quad_str, '.m[2][0]', ', Temp_MAT_0);'];
            EVAL_STR(27).line = ['Scalar_Mult_Matrix(Hess_Comp_1, -', Inv_Grad_Quad_str, '.m[2][1]', ', Temp_MAT_1);'];
            EVAL_STR(28).line = ['Scalar_Mult_Matrix(Hess_Comp_2, -', Inv_Grad_Quad_str, '.m[2][2]', ', Temp_MAT_2);'];
            EVAL_STR(29).line = ['Add_Matrix(Temp_MAT_0, Temp_MAT_1, Temp_MAT_0);'];
            EVAL_STR(30).line = ['Add_Matrix(Temp_MAT_0, Temp_MAT_2, Temp_MAT_2);'];
            EVAL_STR(31).line = ['Mat_Mat(Temp_MAT_2, ', Inv_Grad_Quad_str, ', Temp_MAT_1);'];
            EVAL_STR(32).line = ['Mat_Transpose_Mat(', Inv_Grad_Quad_str, ', Temp_MAT_1, Temp_MAT_0);'];
            EVAL_STR(33).line = [Map_PHI_Hess_Inv_Map_Quad_str, '.Set_Comp_Matrix(2, Temp_MAT_0);'];
        else
            EVAL_STR(1).line = '// the map is linear, so the Hessian of the inverse is ZERO!';
            EVAL_STR(2).line = [Map_PHI_Hess_Inv_Map_Quad_str, '.Set_To_Zero();'];
        end

    else
        error('Invalid!');
    end
else
    error('Invalid dimensions!');
end

% define the data type
TYPE_str = obj.Get_CPP_Tensor_Data_Type_Name(obj.GeoDim,obj.TopDim,obj.TopDim);
Defn_Hdr = '// hessian of the inverse transformation';
Loop_Hdr = '// compute the hessian of the inverse local map\n    // note: indexing is in the C style';
Loop_Comment = '// (Grad(PHI)^-1)^t * {-weighted sum of hessian(PHI_k)} * (Grad(PHI)^-1)';
CONST_VAR = obj.Lin_PHI_TF;
CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                            Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%
else
    CODE = [];
end

end