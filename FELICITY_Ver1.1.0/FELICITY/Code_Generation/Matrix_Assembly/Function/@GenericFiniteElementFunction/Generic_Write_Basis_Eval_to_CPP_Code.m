function status = Generic_Write_Basis_Eval_to_CPP_Code(obj,VAR_NAME,NUM_PT_str,NUM_BASIS_str,Eval_Basis,...
                                                           Tensor_Comp,Pick_Deriv,fid_Open,COMMENT)
%Generic_Write_Basis_Eval_to_CPP_Code
%
%   This encapsulates the code generation for writing the evaluations of
%   basis functions.

% Copyright (c) 04-07-2010,  Shawn W. Walker

if isempty(Pick_Deriv)
    status = 0;
    return;
end

ENDL = '\n';

COM_PLUS_TAB = [COMMENT, '    '];

Len_alpha = Eval_Basis(1).Get_Length_Of_Multiindex;
Local_Basis_Deriv = Get_Local_Basis_Deriv_From_Global_Deriv(Len_alpha,Pick_Deriv);

% write out the basis function evaluations
for ind = 1:size(Local_Basis_Deriv,1)
    Local_Basis_Deriv_spec = Local_Basis_Deriv(ind,:);
    Basis_Title_str = ['// Value of basis function, derivatives = [', num2str(Local_Basis_Deriv_spec),...
                                                                       '], at quadrature points'];
    fprintf(fid_Open, [COM_PLUS_TAB, Basis_Title_str, ENDL]);
    Deriv_str = [num2str(Local_Basis_Deriv_spec(1)), '_', num2str(Local_Basis_Deriv_spec(2)), '_',...
                 num2str(Local_Basis_Deriv_spec(3))];
    Basis_Eval_str = ['static const double ', VAR_NAME, '_Basis_Val_', Deriv_str,...
                      '[', NUM_PT_str, '][', NUM_BASIS_str, '] = { \\'];
    fprintf(fid_Open, [COM_PLUS_TAB, Basis_Eval_str, ENDL]);
    status = Process_Basis_Eval_to_CPP_Code(fid_Open,Eval_Basis,Tensor_Comp,Local_Basis_Deriv_spec,COM_PLUS_TAB);
    fprintf(fid_Open, [COM_PLUS_TAB, '};', ENDL]);
    fprintf(fid_Open, ['', ENDL]);
end

end