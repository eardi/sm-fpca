function afd = Elem_DoF_Allocator_assign_face_dof_2D_triangle(obj,Elem)
%Elem_DoF_Allocator_assign_face_dof_2D_triangle
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
afd = afd.Append_CR('int EDA::Assign_Face_DoF(TRIANGLE_EDGE_SEARCH*  Tri_Edge_Search,   // inputs (list of triangles)');
afd = afd.Append_CR('                         const int              DoF_Offset)');
afd = afd.Append_CR('{');
afd = afd.Append_CR('    int Face_DoF_Counter = DoF_Offset;');
afd = afd.Append_CR('    // special case: there are 1-to-N triangles (no gaps in numbering)');
afd = afd.Append_CR('    if (Num_DoF_Per_Face > 0)');
afd = afd.Append_CR('        {');
afd = afd.Append_CR('        // allocate DoFs for the faces (triangles) in the mesh');
afd = afd.Append_CR('        for (int ti=0; ti < Tri_Edge_Search->Num_Tri; ti++)');
afd = afd.Append_CR('            {');
afd = afd.Append_CR('            const int face_ind = 1; // there is only 1 face in 2D');

% face DoF
Num_Set = 0;
TAB = '            ';
afd = afd.Append_CR([TAB, obj.String.BEGIN_Auto_Gen]);
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).F)
        Num_Set = Num_Set + 1;
        Set_Ind_str = num2str(Num_Set);
        afd = afd.Append_CR([TAB, '// Set ', Set_Ind_str, ': add more DoFs']);
        for di=1:size(Elem_Nodal_Top(nnt).F{ind},2)
            afd = afd.Append_CR([TAB, 'Face_DoF_Counter++;']);
            afd = afd.Append_CR([TAB, 'cell_dof[ Node.F[', Set_Ind_str,...
                                      '][face_ind][', num2str(di), '] ][ti] = Face_DoF_Counter;']);
        end
    end
end
afd = afd.Append_CR([TAB, obj.String.END_Auto_Gen]);

afd = afd.Append_CR('            }');
afd = afd.Append_CR('        }');
afd = afd.Append_CR('    return Face_DoF_Counter;');
afd = afd.Append_CR('}');
afd = afd.Append_CR(obj.String.Separator);
afd = afd.Append_CR('');
afd = afd.Append_CR('');

end