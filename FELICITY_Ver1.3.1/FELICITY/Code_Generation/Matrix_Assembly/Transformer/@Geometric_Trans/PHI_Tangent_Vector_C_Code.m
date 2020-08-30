function CODE = PHI_Tangent_Vector_C_Code(obj)
%PHI_Tangent_Vector_C_Code
%
%   Generate C-code for direct evaluation of PHI.Tangent_Vector.

% Copyright (c) 02-20-2012,  Shawn W. Walker

% init (part of) output struct
EVAL_STR(obj.GeoDim).line = [];

if ~isempty(obj.PHI.Tangent_Vector)
    if (obj.TopDim==1)
        % make var string
        CODE.Var_Name(1).line = []; % init
        CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Tangent_Vector');
        
        % need the gradient of the map!
        Map_PHI_Grad_str = obj.Output_CPP_Var_Name('Grad');
        % need the inverse det(Jac)
        Map_PHI_Inv_Det_Jacobian_str = obj.Output_CPP_Var_Name('Inv_Det_Jacobian');
        Map_PHI_Inv_Det_Jacobian_Eval_str = [Map_PHI_Inv_Det_Jacobian_str, '[qp_i]', '.a'];
        
        for ig=1:obj.GeoDim
            PHI_TV_str = obj.Get_CPP_Vector_Eval_String(CODE.Var_Name(1).line,ig);
            PHI_Grad_Index_str = [Map_PHI_Grad_str, '[qp_i]', '.m',...
                                  '[', num2str(ig-1), ']', '[0]']; % C-style indexing
            % Map.Tangent_Vector[qp_i][gd_i] = Map.Grad[qp_i][gd_i][td_i] * Map.INV_DET_Jac[qp_i];
            EVAL_STR(ig).line = [PHI_TV_str, ' = ', PHI_Grad_Index_str, ' * ',...
                                                    Map_PHI_Inv_Det_Jacobian_Eval_str, ';'];
        end
        
        % define the data type
        TYPE_str = obj.Get_CPP_Vector_Data_Type_Name(obj.GeoDim);
        Defn_Hdr = '// the oriented tangent vector of the curve';
        Loop_Hdr = '// compute oriented tangent vector (assuming the original mesh was oriented properly)';
        Loop_Comment = [];
        CONST_VAR = obj.Lin_PHI_TF;
        CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                                    Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
        %
    else % global tangent vector cannot be constructed; use the tangent space projection
        CODE = [];
    end
else
    CODE = [];
end

end