function atd = Elem_DoF_Allocator_assign_tet_dof_3D_tetrahedron(obj,Elem)
%Elem_DoF_Allocator_assign_tet_dof_3D_tetrahedron
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
atd = atd.Append_CR('int EDA::Assign_Tet_DoF(TETRAHEDRON_DATA*       Tet_Data,    // inputs (list of tets)');
atd = atd.Append_CR('                        const int               DoF_Offset)');
atd = atd.Append_CR('{');
atd = atd.Append_CR('    int Tet_DoF_Counter = DoF_Offset;');
atd = atd.Append_CR('    // special case: there are 1-to-N tets (no gaps in numbering)');
atd = atd.Append_CR('    if (Num_DoF_Per_Tet > 0)');
atd = atd.Append_CR('        {');
atd = atd.Append_CR('        // allocate DoFs for the global tets that are actually present');
atd = atd.Append_CR('        for (int ti=0; ti < Tet_Data->Num_Tet; ti++)');
atd = atd.Append_CR('            {');
atd = atd.Append_CR('            const int tet_ind = 1; // there is only 1 tet in 3D');
atd = atd.Append_CR('');

% tet DoF
Num_Set = 0;
TAB = '            ';
atd = atd.Append_CR([TAB, obj.String.BEGIN_Auto_Gen]);
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).T)
        Num_Set = Num_Set + 1;
        Set_Ind_str = num2str(Num_Set);
        atd = atd.Append_CR([TAB, '// Set ', Set_Ind_str, ': add more DoFs']);
        for di=1:size(Elem_Nodal_Top(nnt).T{ind},2)
            atd = atd.Append_CR([TAB, 'Tet_DoF_Counter++;']);
            atd = atd.Append_CR([TAB, 'cell_dof[ Node.T[', Set_Ind_str,...
                                      '][tet_ind][', num2str(di), '] ][ti] = Tet_DoF_Counter;']);
        end
    end
end
atd = atd.Append_CR([TAB, obj.String.END_Auto_Gen]);

atd = atd.Append_CR('            }');
atd = atd.Append_CR('        }');
atd = atd.Append_CR('    return Tet_DoF_Counter;');
atd = atd.Append_CR('}');
atd = atd.Append_CR(obj.String.Separator);
atd = atd.Append_CR('');
atd = atd.Append_CR('');

end