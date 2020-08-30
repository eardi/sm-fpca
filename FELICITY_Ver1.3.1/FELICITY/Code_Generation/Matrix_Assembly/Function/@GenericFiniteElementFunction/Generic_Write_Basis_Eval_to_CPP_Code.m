function status = Generic_Write_Basis_Eval_to_CPP_Code(obj,Quad_Pt,fid,Eval_Basis,COMMENT)
%Generic_Write_Basis_Eval_to_CPP_Code
%
%   This encapsulates the code generation for writing the evaluations of
%   basis functions.

% Copyright (c) 10-27-2016,  Shawn W. Walker

status = 0;

ENDL = '\n';
COM_PLUS_TAB = [COMMENT, '    '];

% get info for C++ code
CPP_Type_Info  = obj.FuncTrans.Get_Reference_Basis_Function_CPP_Type_Info(obj.Opt);
CPP_Eval_Names = fieldnames(CPP_Type_Info); % get needed options

CPP_Name_Hdr = obj.Get_Basis_Eval_Name_CPP_Hdr([]);
for oi = 1:length(CPP_Eval_Names)
    Single_Eval_Name = CPP_Eval_Names{oi};
    Num_Vars = length(CPP_Type_Info.(Single_Eval_Name));
    for jj = 1:Num_Vars
        Basis_Comp_Set  = CPP_Type_Info.(Single_Eval_Name)(jj).Comp;
        % Note: this is a cell array of the same matrix size as the
        % symbolic basis functions.  Each entry is just the matrix indices
        % for THAT entry (yes, it seems lame).
        Derivative_Set  = CPP_Type_Info.(Single_Eval_Name)(jj).Deriv;
        Eval_Expression = CPP_Type_Info.(Single_Eval_Name)(jj).Expr;
        [Basis_qp_eval, FORMAT_STR] = Process_Basis_Eval_to_CPP_Code(Quad_Pt,Eval_Basis,...
                                              Basis_Comp_Set,Derivative_Set,Eval_Expression);
        
        % declare basis function evaluation string format
        Basis_Name_str = [CPP_Name_Hdr, '_', CPP_Type_Info.(Single_Eval_Name)(jj).Suffix_str];
        Basis_Eval_Func_str = @(qp,bi,quant) [Basis_Name_str, '[', qp, '][', bi, '].Set_Equal_To(', quant, ');'];
        
        % write basis function evaluation data (for all quad points and
        % basis functions).
        Num_QP = size(Basis_qp_eval,1);
        Num_Basis = length(Eval_Basis);
        for qp = 1:Num_QP
            for bi = 1:Num_Basis
                Deriv_Eval = Basis_qp_eval{qp,bi};
                data_str = num2str(Deriv_Eval,FORMAT_STR);
                % do C-style indexing!
                Basis_Eval_str = Basis_Eval_Func_str(num2str(qp-1),num2str(bi-1),data_str);
                fprintf(fid, [COM_PLUS_TAB, Basis_Eval_str, ENDL]);
            end
        end
        fprintf(fid, ['', ENDL]);
    end
end
fprintf(fid, ['', ENDL]);

end