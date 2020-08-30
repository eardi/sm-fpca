function status = Generic_Write_Basis_Eval_Interpolation_to_CPP_Code(...
                          obj,VAR_NAME,NUM_BASIS_str,Largest_Derivative_Order,Tensor_Comp,Eval_Basis,fid_Open,COMMENT)
%Generic_Write_Basis_Eval_Interpolation_to_CPP_Code
%
%   This encapsulates the code generation for writing the evaluations of
%   basis functions (symbolically).
%
%   The basis functions have already been composed with the correct map and
%   differentiated before this routine is called!

% Copyright (c) 09-14-2016,  Shawn W. Walker

status = 0;

ENDL = '\n';
COM_PLUS_TAB = [COMMENT, '    '];

Len_alpha = Eval_Basis(1).Get_Length_Of_Multiindex;
Local_Basis_Deriv = obj.Get_Local_Basis_Multiindex_Deriv(Len_alpha,Largest_Derivative_Order);

% write out the basis function evaluations
for ind = 1:size(Local_Basis_Deriv,1)
    % general comment on evaluating basis functions for specific derivatives
    Local_Basis_Deriv_spec = Local_Basis_Deriv(ind,:);
    Basis_Title_str = ['// Value of basis function, derivatives = [', num2str(Local_Basis_Deriv_spec),...
                                                                       '], at local coordinates'];
    fprintf(fid_Open, [COM_PLUS_TAB, Basis_Title_str, ENDL]);
    
    % write code for defining the basis functions
    Basis_Name_str = obj.Get_Basis_Eval_CPP_Name(VAR_NAME,Local_Basis_Deriv_spec);
    Basis_Defn_str = ['double ', Basis_Name_str, '[1][', NUM_BASIS_str, '];'];
    fprintf(fid_Open, [COM_PLUS_TAB, Basis_Defn_str, ENDL]);
    
    % loop through all of the basis functions
    for bb = 1:length(Eval_Basis)
        % C variable name
        basis_C_index_str = num2str(bb-1);
        Basis_Eval_Name_str = [Basis_Name_str, '[0][', basis_C_index_str, ']'];
        
        % get specific derivative of basis function
        alpha = Local_Basis_Deriv_spec(1:Len_alpha);
        BF_Deriv_Specific = Eval_Basis(bb).Get_Derivative(alpha);
        
        % only look at one component!
        Basis_Differentiate_Sym_Expr = BF_Deriv_Specific.Func(Tensor_Comp(1),Tensor_Comp(2));
        
        % generate code snippet
        Basis_Eval_str = make_basis_eval_str(Basis_Eval_Name_str, Basis_Differentiate_Sym_Expr);
        fprintf(fid_Open, [COM_PLUS_TAB, Basis_Eval_str, ENDL]);
    end
    
    status = fprintf(fid_Open, ['', ENDL]);
end

end

function Basis_Eval_str = make_basis_eval_str(Basis_Eval_Name_str, Sym_Expr)

C_code_str = ccode(Sym_Expr); % convert to C code!

% remove the standard variable that matlab uses for the final output
Basis_Eval_str = regexprep(C_code_str, 't0', Basis_Eval_Name_str);

end