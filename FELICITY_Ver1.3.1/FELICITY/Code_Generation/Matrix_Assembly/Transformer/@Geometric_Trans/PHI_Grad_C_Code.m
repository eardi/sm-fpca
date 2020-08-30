function CODE = PHI_Grad_C_Code(obj,Num_Basis)
%PHI_Grad_C_Code
%
%   Generate C-code for direct evaluation of PHI.Grad.
%      PHI_Grad_ij(qp) = SUM^{Num_Basis}_{k=1} c_{ki} \partial_j phi_i(qp),
%                        1 <= i <= GeoDim, 1 <= j <= TopDim
%                        and qp are the coordinates of a quadrature point.

% Copyright (c) 08-17-2017,  Shawn W. Walker

% constants that multiply the basis functions
coefs = sym('coef_%d_%d_',[Num_Basis, obj.GeoDim]);
local_basis = sym('Geo_phi_%d_d%d_',[Num_Basis, obj.TopDim]);

% make var string
CODE.Var_Name(1).line = []; % init
CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Grad');

% loop thru all components of grad(map)
EVAL_STR(obj.GeoDim,obj.TopDim).line = []; % init
for ir=1:obj.GeoDim
    for ic=1:obj.TopDim
        RESULT = sum(coefs(:,ir) .* local_basis(:,ic)); % evaluate PHI_Grad_ij(qp)
        TEMP_STR = ccode(RESULT); % turn into C-code!
        
        % make string replacements
        PHI_Grad_str = obj.Get_CPP_Matrix_Eval_String(CODE.Var_Name(1).line,ir,ic);
        TEMP_STR = regexprep(TEMP_STR, '  t0', PHI_Grad_str); % t0 is the default LHS term
        for ib=1:Num_Basis
            Geo_phi_S_str = ['Geo_phi_', num2str(ib), '_d', num2str(ic), '_'];
            Num_Deriv = [0 0 0];
            Num_Deriv(ic) = 1;
            Partial_Deriv_Str = obj.Get_Partial_Deriv_String(Num_Deriv);
            Geo_phi_C_str = ['Geo_Basis_Val_', Partial_Deriv_Str, '[qp_i]', '[', num2str(ib-1), ']']; % C-style indexing
            TEMP_STR = regexprep(TEMP_STR, Geo_phi_S_str, Geo_phi_C_str);
            coef_S_str = ['coef_', num2str(ib), '_', num2str(ir), '_'];
            coef_C_str = ['Node_Value', '[', num2str(ir-1), ']', '[kc[', num2str(ib-1), ']]']; % C-style indexing
            TEMP_STR = regexprep(TEMP_STR, coef_S_str, coef_C_str);
        end
        EVAL_STR(ir,ic).line = TEMP_STR;
    end
end

% I like the other ordering...
EVAL_STR = EVAL_STR';

% define the data type
TYPE_str = obj.Get_CPP_Matrix_Data_Type_Name(obj.GeoDim,obj.TopDim);
Defn_Hdr = '// gradient of the transformation (matrix)';
Loop_Hdr = '// compute the gradient of the local map\n    // note: indexing is in the C style';
Loop_Comment = '// sum over basis functions';
CONST_VAR = obj.Lin_PHI_TF;
CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                            Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%
end