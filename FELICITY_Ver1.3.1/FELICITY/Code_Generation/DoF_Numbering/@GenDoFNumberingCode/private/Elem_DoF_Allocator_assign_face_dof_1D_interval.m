function afd = Elem_DoF_Allocator_assign_face_dof_1D_interval(obj,Elem)
%Elem_DoF_Allocator_assign_face_dof_1D_interval
%
%   This stores lines of code for sub-sections of the
%   'Elem_DoF_Allocator.cc' C++ code file.

% Copyright (c) 12-01-2010,  Shawn W. Walker

Elem_Nodal_Top         = Elem.Nodal_Top;
Num_Separate_Nodal_Top = length(Elem_Nodal_Top);

%%%%%%%
afd = FELtext('Assign_Face_DoF');
%%%
afd = afd.Append_CR(obj.String.Separator);
afd = afd.Append_CR('/* allocate the face DoFs */');
afd = afd.Append_CR('int EDA::Assign_Face_DoF(EDGE_POINT_SEARCH*  Edge_Point_Search,   // inputs (list of edges)');
afd = afd.Append_CR('                         const int           DoF_Offset)');
afd = afd.Append_CR('{');
afd = afd.Append_CR('    int Face_DoF_Counter = DoF_Offset;');
afd = afd.Append_CR('    // special case: there are no faces in 1D');
afd = afd.Append_CR('    if (Num_DoF_Per_Face > 0)');
afd = afd.Append_CR('        {');
afd = afd.Append_CR('        // this should not run!');
afd = afd.Append_CR('        }');
afd = afd.Append_CR('    return Face_DoF_Counter;');
afd = afd.Append_CR('}');
afd = afd.Append_CR(obj.String.Separator);
afd = afd.Append_CR('');
afd = afd.Append_CR('');

end