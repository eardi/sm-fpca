function CODE = PHI_2nd_Fund_Form_C_Code(obj)
%PHI_2nd_Fund_Form_C_Code
%
%   Generate C-code for direct evaluation of PHI.Second_Fund_Form.
%      PHI_2nd_Fund_Form_ij(qp) = SUM^{GeoDim}_{k=1} 
%                                 \partial_i \partial_j phi_k(qp) * n_k(qp),
%                                 1 <= i,j <= TopDim

% Copyright (c) 02-20-2012,  Shawn W. Walker

if ~isempty(obj.PHI.Second_Fund_Form)
    
    % init (part of) output struct
    EVAL_STR(1).line = []; % init
    
    % make var string
    CODE.Var_Name(1).line = []; % init
    CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Second_Fund_Form');
    Map_PHI_2nd_Form_Eval_str = [CODE.Var_Name(1).line, '_qp_i'];
    
    % need the hessian
    Map_PHI_Hess_str = obj.Output_CPP_Var_Name('Hess');
    Map_PHI_Hess_Tensor_str = [Map_PHI_Hess_str, '[qp_i]'];
    
    % need the normal vector
    if ~isempty(obj.PHI.Normal_Vector)
        Map_NV_str = obj.Output_CPP_Var_Name('Normal_Vector');
        Map_NV_Eval_str = [Map_NV_str, '[qp_i]'];
    else
        Map_NV_Eval_str = [];
    end
    
    if (obj.GeoDim==1)
        CODE = [];
    elseif (obj.GeoDim==2)
        if (obj.TopDim==1)
            if ~obj.Lin_PHI_TF % map is non-linear
                % call a function to compute the 2nd fundamental form
                EVAL_STR(1).line = []; % init
                EVAL_STR(1).line = ['Compute_2nd_Fundamental_Form(', Map_PHI_Hess_Tensor_str, ', ', Map_NV_Eval_str, ', ', ...
                                             Map_PHI_2nd_Form_Eval_str, ');'];
                
            else % the map is linear, so the 2nd fundamental form is ZERO!
                EVAL_STR(1).line = []; % init
                EVAL_STR(1).line = [obj.Get_CPP_Matrix_Eval_String(CODE.Var_Name(1).line,1,1), ' = 0.0;'];
            end
            
        elseif (obj.TopDim==2)
            CODE = [];
        else
            error('Not valid!');
        end
    elseif (obj.GeoDim==3)
        if (obj.TopDim==1)
            CODE = [];
        elseif (obj.TopDim==2)
            if ~obj.Lin_PHI_TF % map is non-linear
                EVAL_STR(1).line = []; % init
                EVAL_STR(1).line = ['Compute_2nd_Fundamental_Form(', Map_PHI_Hess_Tensor_str, ', ', Map_NV_Eval_str, ', ', ...
                                             Map_PHI_2nd_Form_Eval_str, ');'];
            else % the map is linear, so the 2nd fundamental form is ZERO!
                EVAL_STR(4).line = []; % init
                EVAL_STR(1).line = [obj.Get_CPP_Matrix_Eval_String(CODE.Var_Name(1).line,1,1), ' = 0.0;'];
                EVAL_STR(2).line = [obj.Get_CPP_Matrix_Eval_String(CODE.Var_Name(1).line,1,2), ' = 0.0;'];
                EVAL_STR(3).line = [obj.Get_CPP_Matrix_Eval_String(CODE.Var_Name(1).line,2,1), ' = 0.0;'];
                EVAL_STR(4).line = [obj.Get_CPP_Matrix_Eval_String(CODE.Var_Name(1).line,2,2), ' = 0.0;'];
            end
            
        elseif (obj.TopDim==3)
            CODE = [];
        else
            error('Not valid!');
        end
    else
        error('Not implemented!');
    end
    
    if ~isempty(CODE)
        % define the data type
        TYPE_str = obj.Get_CPP_Matrix_Data_Type_Name(obj.TopDim,obj.TopDim);
        Defn_Hdr = '// 2nd fundamental form of the map';
        Loop_Hdr = '// compute the 2nd fundamental form of the local map';
        Loop_Comment = '// sum over geometric dimension';
        CONST_VAR = obj.Lin_PHI_TF;
        CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                                    Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
        %
    end
    
else
    CODE = [];
end

end