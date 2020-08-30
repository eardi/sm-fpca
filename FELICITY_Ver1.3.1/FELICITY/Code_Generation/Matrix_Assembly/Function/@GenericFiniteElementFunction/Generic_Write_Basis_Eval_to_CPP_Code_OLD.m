function status = Generic_Write_Basis_Eval_to_CPP_Code_OLD(obj,VAR_NAME,NUM_PT_str,NUM_BASIS_str,Eval_Basis,...
                                                           Tensor_Comp,Largest_Derivative_Order,fid_Open,COMMENT)
%Generic_Write_Basis_Eval_to_CPP_Code_OLD
%
%   This encapsulates the code generation for writing the evaluations of
%   basis functions.

% Copyright (c) 09-14-2016,  Shawn W. Walker

if isempty(Largest_Derivative_Order)
    status = 0;
    return;
end

ENDL = '\n';

COM_PLUS_TAB = [COMMENT, '    '];

Len_alpha = Eval_Basis(1).Get_Length_Of_Multiindex;
Local_Basis_Deriv = obj.Get_Local_Basis_Multiindex_Deriv(Len_alpha,Largest_Derivative_Order);

% write out the basis function evaluations
for ind = 1:size(Local_Basis_Deriv,1)
    Local_Basis_Deriv_spec = Local_Basis_Deriv(ind,:);
    Basis_Title_str = ['// Value of basis function, derivatives = [', num2str(Local_Basis_Deriv_spec),...
                                                                       '], at quadrature points'];
    fprintf(fid_Open, [COM_PLUS_TAB, Basis_Title_str, ENDL]);
    
    Basis_Name_str = obj.Get_Basis_Eval_CPP_Name(VAR_NAME,Local_Basis_Deriv_spec);
    Basis_Eval_str = ['static const double ', Basis_Name_str, '[', NUM_PT_str, '][', NUM_BASIS_str, '] = { \\'];
    fprintf(fid_Open, [COM_PLUS_TAB, Basis_Eval_str, ENDL]);
    
    status = Process_Basis_Eval_to_CPP_Code_OLD(fid_Open,Eval_Basis,Tensor_Comp,Local_Basis_Deriv_spec,COM_PLUS_TAB);
    fprintf(fid_Open, [COM_PLUS_TAB, '};', ENDL]);
    fprintf(fid_Open, ['', ENDL]);
end

end