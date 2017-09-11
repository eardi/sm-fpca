function atd = Elem_DoF_Allocator_assign_tet_dof_2D_triangle(obj,Elem)
%Elem_DoF_Allocator_assign_tet_dof_2D_triangle
%
%   This stores lines of code for sub-sections of the
%   'Elem_DoF_Allocator.cc' C++ code file.

% Copyright (c) 12-01-2010,  Shawn W. Walker

Elem_Nodal_Top         = Elem.Nodal_Top;
Num_Separate_Nodal_Top = length(Elem_Nodal_Top);

%%%%%%%
atd = FELtext('Assign_Tet_DoF');
%%%
atd = atd.Append_CR(obj.String.Separator);
atd = atd.Append_CR('/* allocate the tet DoFs */');
atd = atd.Append_CR('int EDA::Assign_Tet_DoF(TRIANGLE_EDGE_SEARCH*  Tri_Edge_Search,   // inputs (list of triangles)');
atd = atd.Append_CR('                        const int              DoF_Offset)');
atd = atd.Append_CR('{');
atd = atd.Append_CR('    int Tet_DoF_Counter = DoF_Offset;');
atd = atd.Append_CR('    // special case: there are no tets in 2D');
atd = atd.Append_CR('    if (Num_DoF_Per_Tet > 0)');
atd = atd.Append_CR('        {');
atd = atd.Append_CR('        // this should not run!');
atd = atd.Append_CR('        }');
atd = atd.Append_CR('    return Tet_DoF_Counter;');
atd = atd.Append_CR('}');
atd = atd.Append_CR(obj.String.Separator);
atd = atd.Append_CR('');
atd = atd.Append_CR('');

end