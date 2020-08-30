function errc = Elem_DoF_Allocator_error_check_dof_map(obj)
%Elem_DoF_Allocator_error_check_dof_map
%
%   This stores lines of code for sub-sections of the
%   'Elem_DoF_Allocator.cc' C++ code file.

% Copyright (c) 04-27-2012,  Shawn W. Walker

% /* perform error checks on FEM DoF map */
% void EDA::Error_Check_DoF_Map(const int&  Num_Cell)
% {
%     // BEGIN: error check
%     const unsigned int LENGTH = Total_DoF_Per_Cell*Num_Cell;
%     const unsigned int MIN_DoF = *min_element(cell_dof[1], cell_dof[1]+LENGTH);
%     if (MIN_DoF < 1)
%         {
%         mexPrintf("ERROR: DoFmap references DoF with index 0!\n");
%         mexPrintf("ERROR: Some DoFs were never allocated!\n");
%         mexErrMsgTxt("ERROR: Make sure your mesh describes a domain that is a manifold!");
%         }
%     // END: error check
% }

%%%%%%%
errc = FELtext('Error_Check_DoF_Map');
%%%
errc = errc.Append_CR(obj.String.Separator);
errc = errc.Append_CR('/* perform error checks on Finite Element Degree-of-Freedom (DoF) map */');
errc = errc.Append_CR('void EDA::Error_Check_DoF_Map(const int&  Num_Cell)');
errc = errc.Append_CR('{');
errc = errc.Append_CR('    // BEGIN: error check');
errc = errc.Append_CR('    const unsigned int LENGTH = Total_DoF_Per_Cell*Num_Cell;');
errc = errc.Append_CR('    const unsigned int MIN_DoF = *min_element(cell_dof[1], cell_dof[1]+LENGTH);');
errc = errc.Append_CR('    if (MIN_DoF < 1)');
errc = errc.Append_CR('        {');
errc = errc.Append_CR('        mexPrintf("ERROR: DoFmap references DoF with index 0!\\n");');
errc = errc.Append_CR('        mexPrintf("ERROR: Some DoFs were never allocated!\\n");');
errc = errc.Append_CR('        mexErrMsgTxt("ERROR: Make sure your mesh describes a domain that is a manifold!");');
errc = errc.Append_CR('        }');
errc = errc.Append_CR('    // END: error check');
errc = errc.Append_CR('}');
errc = errc.Append_CR(obj.String.Separator);
errc = errc.Append_CR('');
errc = errc.Append_CR('');

end