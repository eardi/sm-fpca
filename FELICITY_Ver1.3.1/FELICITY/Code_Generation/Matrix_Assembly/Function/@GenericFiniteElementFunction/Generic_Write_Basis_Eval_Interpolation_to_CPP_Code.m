function status = Generic_Write_Basis_Eval_Interpolation_to_CPP_Code(...
                          obj,fid,Eval_Basis,COMMENT)
%Generic_Write_Basis_Eval_Interpolation_to_CPP_Code
%
%   This encapsulates the code generation for writing the evaluations of
%   basis functions (symbolically).
%
%   The basis functions have already been composed with the correct map and
%   differentiated before this routine is called!

% Copyright (c) 10-28-2016,  Shawn W. Walker

status = 0;
Num_Basis = length(Eval_Basis);

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
        Tensor_Comp_Set = CPP_Type_Info.(Single_Eval_Name)(jj).Comp;
        Derivative_Set  = CPP_Type_Info.(Single_Eval_Name)(jj).Deriv;
        Eval_Expression = CPP_Type_Info.(Single_Eval_Name)(jj).Expr;
        Basis_Sym = Process_Symbolic_Basis_Eval(Eval_Basis,Tensor_Comp_Set,Derivative_Set,Eval_Expression);
        
%         % generate optimized C-code from symbolic expression
%         TEST_EXPR = sym(zeros(Num_Basis,length(Tensor_Comp_Set)));
%         for bi = 1:Num_Basis
%             TEST_EXPR(bi,:) = Basis_Sym(bi).Expr.Func;
%         end
%         ccode(TEST_EXPR,'file','C:\TEMP\test_code.c');
        
        % declare basis function evaluation string format
        Basis_Name_str = [CPP_Name_Hdr, '_', CPP_Type_Info.(Single_Eval_Name)(jj).Suffix_str];
        Basis_Eval_Func_str = @(bi,quant) [Basis_Name_str, '[', bi, '].Set_Equal_To(', quant, ');'];
        
        % write basis function evaluation data (for all quad points and
        % basis functions).
        for bi = 1:Num_Basis
            Sym_Expr = Basis_Sym(bi).Expr.Func;
            % loop through components
            Quant_Eval_str = convert_sym_to_ccode_snip(Sym_Expr(1));
            for kk = 2:length(Sym_Expr)
                Quant_Eval_str = [Quant_Eval_str, ', ', convert_sym_to_ccode_snip(Sym_Expr(kk))];
            end
            Basis_Eval_str = Basis_Eval_Func_str(num2str(bi-1),Quant_Eval_str);
            fprintf(fid, [COM_PLUS_TAB, Basis_Eval_str, ENDL]);
        end
        fprintf(fid, ['', ENDL]);
    end
end
%fprintf(fid, ['', ENDL]);

end

function Sym_Expr_CC_Snip = convert_sym_to_ccode_snip(Sym_Expr)

C_code_str = ccode(Sym_Expr); % convert to C code!

% remove the standard variable that matlab uses for the final output
Sym_Expr_CC_Snip = regexprep(C_code_str, 't0 =', '');
% trim!
Sym_Expr_CC_Snip = regexprep(Sym_Expr_CC_Snip, ';', '');
Sym_Expr_CC_Snip = strtrim(Sym_Expr_CC_Snip);

end