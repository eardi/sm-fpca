function idm = Elem_DoF_Allocator_init_dof_map(obj)
%Elem_DoF_Allocator_init_dof_map
%
%   This stores lines of code for sub-sections of the
%   'Elem_DoF_Allocator.cc' C++ code file.

% Copyright (c) 12-01-2010,  Shawn W. Walker

% /* initialize FEM DoF map to all zeros */
% mxArray* EDA::Init_DoF_Map(int  Num_Cell)     // output to MATLAB
% {
%     mxArray* DoF_Map;
% 
%     // BEGIN: allocate and access output data
%     DoF_Map = mxCreateNumericMatrix(Num_Cell, Total_DoF_Per_Cell, mxUINT32_CLASS, mxREAL);
%     // access the data
%     // split up the columns of the data
%     cell_dof[0] = NULL; // not used!
%     cell_dof[1] = (int *) mxGetPr(DoF_Map);
%     for (int i = 2; (i <= Total_DoF_Per_Cell); i++) // note: off by one because of C-style indexing!
%         cell_dof[i] = cell_dof[i-1] + Num_Cell;
%     // END: allocate and access output data
% 
%     return DoF_Map;
% }

%%%%%%%
idm = FELtext('Init_DoF_Map');
%%%
idm = idm.Append_CR(obj.String.Separator);
idm = idm.Append_CR('/* initialize FEM DoF map to all zeros */');
idm = idm.Append_CR('mxArray* EDA::Init_DoF_Map(int  Num_Cell)     // output to MATLAB');
idm = idm.Append_CR('{');
idm = idm.Append_CR('    mxArray* DoF_Map;');
idm = idm.Append_CR('');
idm = idm.Append_CR('    // BEGIN: allocate and access output data');
idm = idm.Append_CR('    DoF_Map = mxCreateNumericMatrix((mwSize)Num_Cell, (mwSize)Total_DoF_Per_Cell, mxUINT32_CLASS, mxREAL);');
idm = idm.Append_CR('    // access the data');
idm = idm.Append_CR('    // split up the columns of the data');
idm = idm.Append_CR('    cell_dof[0] = NULL; // not used!');
idm = idm.Append_CR('    cell_dof[1] = (int *) mxGetPr(DoF_Map);');
idm = idm.Append_CR('    for (int i = 2; (i <= Total_DoF_Per_Cell); i++) // note: off by one because of C-style indexing!');
idm = idm.Append_CR('        cell_dof[i] = cell_dof[i-1] + Num_Cell;');
idm = idm.Append_CR('    // END: allocate and access output data');
idm = idm.Append_CR('');
idm = idm.Append_CR('    return DoF_Map;');
idm = idm.Append_CR('}');
idm = idm.Append_CR(obj.String.Separator);
idm = idm.Append_CR('');
idm = idm.Append_CR('');

end