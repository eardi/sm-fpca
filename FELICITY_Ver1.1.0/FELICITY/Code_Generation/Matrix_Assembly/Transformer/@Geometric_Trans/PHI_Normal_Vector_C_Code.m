function CODE = PHI_Normal_Vector_C_Code(obj)
%PHI_Normal_Vector_C_Code
%
%   Generate C-code for direct evaluation of PHI.Normal_Vector.

% Copyright (c) 02-20-2012,  Shawn W. Walker

% init (part of) output struct
CODE.Var_Name(1).line = [];

% a curve in the plane, or a surface in 3-D
if or( and((obj.TopDim==1),(obj.GeoDim==2)), and((obj.TopDim==2),(obj.GeoDim==3)) )
    % make var string
    CODE.Var_Name(1).line = []; % init
    CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Normal_Vector');
    Map_NV_Eval_str = [CODE.Var_Name(1).line, '_qp_i'];
    
    % need the gradient of the map!
    Map_PHI_Grad_str = obj.Output_CPP_Var_Name('Grad');
    Map_PHI_Grad_Eval_str = [Map_PHI_Grad_str, '[qp_i]'];

    % need the inverse det(Jac)
    Map_PHI_Inv_Det_Jacobian_str = obj.Output_CPP_Var_Name('Inv_Det_Jacobian');
    Map_PHI_Inv_Det_Jacobian_Eval_str = [Map_PHI_Inv_Det_Jacobian_str, '[qp_i]'];
    
    % call a function to compute the inverse
    EVAL_STR(1).line = []; % init
    %Compute_Normal_Vector (const MAT_3x2& G, const SCALAR& Inv_Det_Jac, VEC_3x1& N)
    EVAL_STR(1).line = ['Compute_Normal_Vector(', Map_PHI_Grad_Eval_str, ', ', Map_PHI_Inv_Det_Jacobian_Eval_str, ', ', ...
                                                  Map_NV_Eval_str, ');'];
else % normal vector does not make sense
    CODE = [];
    return;
end

% define the data type
TYPE_str = obj.Get_CPP_Vector_Data_Type_Name(obj.GeoDim);
Defn_Hdr = '// the oriented normal vector of the manifold';
Loop_Hdr = '// compute oriented normal vector (assuming the original mesh was oriented properly)';
Loop_Comment = [];
CONST_VAR = obj.Lin_PHI_TF;
CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                            Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%
end