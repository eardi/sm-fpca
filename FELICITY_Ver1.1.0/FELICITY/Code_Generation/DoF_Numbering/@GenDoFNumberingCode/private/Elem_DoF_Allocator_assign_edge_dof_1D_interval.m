function aed = Elem_DoF_Allocator_assign_edge_dof_1D_interval(obj,Elem)
%Elem_DoF_Allocator_assign_edge_dof_1D_interval
%
%   This stores lines of code for sub-sections of the
%   'Elem_DoF_Allocator.cc' C++ code file.

% Copyright (c) 12-01-2010,  Shawn W. Walker

Elem_Nodal_Top         = Elem.Nodal_Top;
Num_Separate_Nodal_Top = length(Elem_Nodal_Top);

%%%%%%%
aed = FELtext('Assign_Edge_DoF');
%%%
aed = aed.Append_CR(obj.String.Separator);
aed = aed.Append_CR('/* allocate the edge DoFs */');
aed = aed.Append_CR('int EDA::Assign_Edge_DoF(EDGE_POINT_SEARCH*  Edge_Point_Search,   // inputs (list of edges)');
aed = aed.Append_CR('                         const int           DoF_Offset)');
aed = aed.Append_CR('{');
aed = aed.Append_CR('    int Edge_DoF_Counter = DoF_Offset;');
aed = aed.Append_CR('    // special case: there are 1-to-N edges (no gaps in numbering)');
aed = aed.Append_CR('    if (Num_DoF_Per_Edge > 0)');
aed = aed.Append_CR('        {');
aed = aed.Append_CR('        // allocate DoFs for the edges in the mesh');
aed = aed.Append_CR('        for (int ei=0; ei < Edge_Point_Search->Num_Edge; ei++)');
aed = aed.Append_CR('            {');
aed = aed.Append_CR('            const int edge_ind = 1; // there is only 1 edge in 1D');
aed = aed.Append_CR('');

% edge DoF
Num_Set = 0;
TAB = '            ';
aed = aed.Append_CR([TAB, obj.String.BEGIN_Auto_Gen]);
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).E)
        Num_Set = Num_Set + 1;
        Set_Ind_str = num2str(Num_Set);
        aed = aed.Append_CR([TAB, '// Set ', Set_Ind_str, ': add more DoFs']);
        for di=1:size(Elem_Nodal_Top(nnt).E{ind},2)
            aed = aed.Append_CR([TAB, 'Edge_DoF_Counter++;']);
            aed = aed.Append_CR([TAB, 'cell_dof[ Node.E[', Set_Ind_str, '][edge_ind][', num2str(di),...
                                      '] ][ei] = Edge_DoF_Counter;']);
        end
    end
end
aed = aed.Append_CR([TAB, obj.String.END_Auto_Gen]);

aed = aed.Append_CR('            }');
aed = aed.Append_CR('        }');
aed = aed.Append_CR('    return Edge_DoF_Counter;');
aed = aed.Append_CR('}');
aed = aed.Append_CR(obj.String.Separator);
aed = aed.Append_CR('');
aed = aed.Append_CR('');

end