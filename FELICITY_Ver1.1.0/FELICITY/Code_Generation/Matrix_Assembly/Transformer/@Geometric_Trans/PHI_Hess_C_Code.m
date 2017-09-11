function CODE = PHI_Hess_C_Code(obj,Num_Basis)
%PHI_Hess_C_Code
%
%   Generate C-code for direct evaluation of PHI.Hess.
%      PHI_Hess_ijk(qp) = SUM^{Num_Basis}_{q=1} c_{qk} *
%                                  \partial_i \partial_j phi_k(qp),
%                         1 <= k <= GeoDim, 1 <= i,j <= TopDim
%                         and qp are the coordinates of a quadrature point.

% Copyright (c) 02-20-2012,  Shawn W. Walker

% make var string
CODE.Var_Name(1).line = []; % init
CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Hess');

if ~obj.Lin_PHI_TF % map is non-linear
    % init (part of) output struct
    EVAL_STR(obj.TopDim*obj.TopDim*obj.GeoDim).line = []; % init
    for kk=1:obj.GeoDim
        if (obj.TopDim==1)
            % write evaluation code
            EVAL_STR(1 + (kk-1)*obj.TopDim^2).line =...
                Generate_Evaluation_String(obj,CODE.Var_Name(1).line,1,1,kk,Num_Basis);
        elseif (obj.TopDim==2)
            % write evaluation code
            EVAL_STR(1 + (kk-1)*obj.TopDim^2).line = Generate_Evaluation_String(obj,CODE.Var_Name(1).line,1,1,kk,Num_Basis);
            EVAL_STR(2 + (kk-1)*obj.TopDim^2).line = Generate_Evaluation_String(obj,CODE.Var_Name(1).line,1,2,kk,Num_Basis);
            EVAL_STR(3 + (kk-1)*obj.TopDim^2).line =...
                               [obj.Get_CPP_Tensor_Eval_String(CODE.Var_Name(1).line,kk,2,1), ' = ',...
                                obj.Get_CPP_Tensor_Eval_String(CODE.Var_Name(1).line,kk,1,2), '; // symmetry!'];
            EVAL_STR(4 + (kk-1)*obj.TopDim^2).line = Generate_Evaluation_String(obj,CODE.Var_Name(1).line,2,2,kk,Num_Basis);
        elseif (obj.TopDim==3)
            % write evaluation code
            EVAL_STR(1 + (kk-1)*obj.TopDim^2).line = Generate_Evaluation_String(obj,CODE.Var_Name(1).line,1,1,kk,Num_Basis);
            EVAL_STR(2 + (kk-1)*obj.TopDim^2).line = Generate_Evaluation_String(obj,CODE.Var_Name(1).line,1,2,kk,Num_Basis);
            EVAL_STR(3 + (kk-1)*obj.TopDim^2).line = Generate_Evaluation_String(obj,CODE.Var_Name(1).line,1,3,kk,Num_Basis);
            
            EVAL_STR(4 + (kk-1)*obj.TopDim^2).line =...
                               [obj.Get_CPP_Tensor_Eval_String(CODE.Var_Name(1).line,kk,2,1), ' = ',...
                                obj.Get_CPP_Tensor_Eval_String(CODE.Var_Name(1).line,kk,1,2), '; // symmetry!'];
            EVAL_STR(5 + (kk-1)*obj.TopDim^2).line = Generate_Evaluation_String(obj,CODE.Var_Name(1).line,2,2,kk,Num_Basis);
            EVAL_STR(6 + (kk-1)*obj.TopDim^2).line = Generate_Evaluation_String(obj,CODE.Var_Name(1).line,2,3,kk,Num_Basis);
            
            EVAL_STR(7 + (kk-1)*obj.TopDim^2).line =...
                               [obj.Get_CPP_Tensor_Eval_String(CODE.Var_Name(1).line,kk,3,1), ' = ',...
                                obj.Get_CPP_Tensor_Eval_String(CODE.Var_Name(1).line,kk,1,3), '; // symmetry!'];
            EVAL_STR(8 + (kk-1)*obj.TopDim^2).line =...
                               [obj.Get_CPP_Tensor_Eval_String(CODE.Var_Name(1).line,kk,3,2), ' = ',...
                                obj.Get_CPP_Tensor_Eval_String(CODE.Var_Name(1).line,kk,2,3), '; // symmetry!'];
            EVAL_STR(9 + (kk-1)*obj.TopDim^2).line = Generate_Evaluation_String(obj,CODE.Var_Name(1).line,3,3,kk,Num_Basis);
        else
            error('Not implemented!');
        end
    end
else
    % the map is linear, so the Hessian is ZERO!
    Map_Hess_Quad_str = obj.Get_Quad_Pt_CPP_Ref_Var_Name(CODE.Var_Name(1).line);
    EVAL_STR.line = [Map_Hess_Quad_str, '.Set_To_Zero(); // map is linear, so hessian is ZERO!'];
end

% define the data type
TYPE_str = obj.Get_CPP_Tensor_Data_Type_Name(obj.GeoDim,obj.TopDim,obj.TopDim);
Defn_Hdr = '// hessian of the transformation';
Loop_Hdr = '// compute the hessian of the local map\n    // note: indexing is in the C style';
Loop_Comment = '// sum over basis functions';
CONST_VAR = obj.Lin_PHI_TF;
CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                            Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%
end

function ES = Generate_Evaluation_String(obj,Var_Name,ii,jj,kk,Num_Basis)

Map_PHI_Hess_str = obj.Get_CPP_Tensor_Eval_String(Var_Name,kk,ii,jj);
ES = [Map_PHI_Hess_str, ' = ']; % init

Partial_Deriv_Str = Get_Mixed_Deriv_String(obj,ii,jj);
for bb=1:Num_Basis
    Geo_phi_C_str = ['Geo_Basis_Val_', Partial_Deriv_Str, '[qp_i]', '[', num2str(bb-1), ']']; % C-style indexing
    coef_C_str = ['Node_Value', '[', num2str(kk-1), ']', '[kc[', num2str(bb-1), ']]']; % C-style indexing
    MULT_str = [Geo_phi_C_str, ' * ', coef_C_str];
    ES = [ES, MULT_str];
    if (bb < Num_Basis)
        ES = [ES, ' + '];
    end
end

ES = [ES, ';']; % close the C++ code!

end

function Deriv_Str = Get_Mixed_Deriv_String(obj,ii,jj)

Num_Deriv = [0 0 0]; % init

% MATLAB-style indexing
Num_Deriv(ii) = Num_Deriv(ii) + 1;
Num_Deriv(jj) = Num_Deriv(jj) + 1;

Deriv_Str = obj.Get_Partial_Deriv_String(Num_Deriv);

end