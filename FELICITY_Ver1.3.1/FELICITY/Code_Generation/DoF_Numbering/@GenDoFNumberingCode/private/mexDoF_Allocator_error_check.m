function errchk = mexDoF_Allocator_error_check(obj,mex_strings)
%mexDoF_Allocator_error_check
%
%   This stores lines of code for sub-sections of the
%   'mexDoF_Allocator.cpp' C++ code file.

% Copyright (c) 12-10-2010,  Shawn W. Walker

TAB  = '    ';
TAB2 = '        ';

NUM_ARG = length(mex_strings.PRHS);
NUM_OUT = length(mex_strings.PLHS_Elem_DoF);

%%%%%%%
errchk = FELtext('error check');
% store text-lines
errchk = errchk.Append_CR([TAB, obj.String.BEGIN_Auto_Gen]);
errchk = errchk.Append_CR([TAB, '/* BEGIN: Error Checking */']);
errchk = errchk.Append_CR([TAB, 'if (nrhs!=', num2str(NUM_ARG), ')']);
errchk = errchk.Append_CR([TAB2, '{']);
errchk = errchk.Append_CR([TAB2, 'printf("ERROR: ', num2str(NUM_ARG), ' inputs required!\\n");']);
errchk = errchk.Append_CR([TAB2, 'printf("\\n");']);
errchk = errchk.Append_CR([TAB2, 'printf("      INPUTS                                                         ORDER \\n");']);
errchk = errchk.Append_CR([TAB2, 'printf("      -------------------                                            ----- \\n");']);
%%%%%
for ind=1:NUM_ARG
    errchk = errchk.Append_CR([TAB2, 'printf("      ', mex_strings.PRHS(ind).aligned(6:end), ' \\n");']);
end
errchk = errchk.Append_CR([TAB2, 'printf("\\n");']);
errchk = errchk.Append_CR([TAB2, 'printf("      OUTPUTS                                                        ORDER \\n");']);
errchk = errchk.Append_CR([TAB2, 'printf("      -------------------                                            ----- \\n");']);
for ind=1:length(mex_strings.PLHS_Elem_DoF)
    errchk = errchk.Append_CR([TAB2, 'printf("      ', mex_strings.PLHS_Elem_DoF(ind).aligned(6:end), ' \\n");']);
end
errchk = errchk.Append_CR([TAB2, 'printf("\\n");']);
errchk = errchk.Append_CR([TAB2, 'mexErrMsgTxt("Check the number of input arguments!");']);
errchk = errchk.Append_CR([TAB2, '}']);
errchk = errchk.Append_CR([TAB, 'if ((nlhs < 1)||(nlhs > ', num2str(NUM_OUT), ')) mexErrMsgTxt("1~', num2str(NUM_OUT),...
                                ' outputs are needed!");']);
errchk = errchk.Append_CR([TAB, '/* END: Error Checking */']);
errchk = errchk.Append_CR([TAB, obj.String.END_Auto_Gen]);
errchk = errchk.Append_CR('');

end