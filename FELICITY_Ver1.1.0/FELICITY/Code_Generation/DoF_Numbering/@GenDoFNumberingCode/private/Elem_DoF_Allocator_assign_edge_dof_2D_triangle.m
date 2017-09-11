function aed = Elem_DoF_Allocator_assign_edge_dof_2D_triangle(obj,Elem)
%Elem_DoF_Allocator_assign_edge_dof_2D_triangle
%
%   This stores lines of code for sub-sections of the
%   'Elem_DoF_Allocator.cc' C++ code file.

% Copyright (c) 05-27-2013,  Shawn W. Walker

Elem_Nodal_Top         = Elem.Nodal_Top;
Num_Separate_Nodal_Top = length(Elem_Nodal_Top);

%%%%%%%
aed = FELtext('Assign_Edge_DoF');
%%%
aed = aed.Append_CR(obj.String.Separator);
aed = aed.Append_CR('/* allocate the edge DoFs */');
aed = aed.Append_CR('int EDA::Assign_Edge_DoF(TRIANGLE_EDGE_SEARCH*  Tri_Edge_Search,   // inputs (list of triangles)');
aed = aed.Append_CR('                         const int              DoF_Offset)');
aed = aed.Append_CR('{');
aed = aed.Append_CR('    int Edge_DoF_Counter = DoF_Offset;');
aed = aed.Append_CR('    // allocate DoFs for the edges in the triangulation');
aed = aed.Append_CR('    if (Num_DoF_Per_Edge > 0)');
aed = aed.Append_CR('        {');
aed = aed.Append_CR('        // temp storage for DoFs on edge');
aed = aed.Append_CR('        int SE_DoF[Num_Edge_Sets+1][Max_DoF_Per_Edge+1];');
aed = aed.Append_CR('        // initialize to NULL value');
aed = aed.Append_CR('        for (int ind1=0; ind1 < Num_Edge_Sets+1; ind1++)');
aed = aed.Append_CR('        for (int ind2=0; ind2 < Max_DoF_Per_Edge+1; ind2++)');
aed = aed.Append_CR('            SE_DoF[ind1][ind2] = -1;');
aed = aed.Append_CR('');
aed = aed.Append_CR('        // initialize previous edge to NULL');
aed = aed.Append_CR('        EDGE_TO_CELL Prev_EI;');
aed = aed.Append_CR('        Prev_EI.edge_info[0] = -1;');
aed = aed.Append_CR('        Prev_EI.edge_info[1] = -1;');
aed = aed.Append_CR('        Prev_EI.edge_info[2] = -1;');
aed = aed.Append_CR('        Prev_EI.edge_info[3] = 0;');
aed = aed.Append_CR('');
aed = aed.Append_CR('        std::vector<EDGE_TO_CELL>::iterator ei; // need iterator');
aed = aed.Append_CR('        int EDGE_COUNT = 0;');
aed = aed.Append_CR('        for (ei=Tri_Edge_Search->Edge_List.begin(); ei!=Tri_Edge_Search->Edge_List.end(); ++ei)');
aed = aed.Append_CR('            {');
aed = aed.Append_CR('            const EDGE_TO_CELL Current_EI = *ei;');
aed = aed.Append_CR('            const bool NEW_EDGE = (Prev_EI.edge_info[0]!=Current_EI.edge_info[0]) || (Prev_EI.edge_info[1]!=Current_EI.edge_info[1]);');
aed = aed.Append_CR('            const unsigned int cell_index = (unsigned int) Current_EI.edge_info[2];');
aed = aed.Append_CR('            const int local_edge_index = Current_EI.edge_info[3];');
aed = aed.Append_CR('');
aed = aed.Append_CR('            // if this edge has NOT been visited yet');
aed = aed.Append_CR('            if (NEW_EDGE)');
aed = aed.Append_CR('                {');
aed = aed.Append_CR('                EDGE_COUNT++;');
aed = aed.Append_CR('                Prev_EI = Current_EI; // update previous');
aed = aed.Append_CR('');
aed = aed.Append_CR('                // allocate new DoF''s');

% edge DoF
Num_Set = 0;
TAB = '                ';
aed = aed.Append_CR([TAB, obj.String.BEGIN_Auto_Gen]);
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).E)
        Num_Set = Num_Set + 1;
        Set_Ind_str = num2str(Num_Set);
        aed = aed.Append_CR([TAB, '// Set ', Set_Ind_str, ': add more DoFs']);
        for di=1:size(Elem_Nodal_Top(nnt).E{ind},2)
            aed = aed.Append_CR([TAB, 'Edge_DoF_Counter++;']);
            aed = aed.Append_CR([TAB, 'SE_DoF[', Set_Ind_str, '][', num2str(di), '] = Edge_DoF_Counter;']);
        end
    end
end
aed = aed.Append_CR([TAB, obj.String.END_Auto_Gen]);
aed = aed.Append_CR('                }');
aed = aed.Append_CR('            else');
aed = aed.Append_CR('                {');
aed = aed.Append_CR('                // if the same edge is contained in the same cell as the previous');
aed = aed.Append_CR('                if (Prev_EI.edge_info[2]==cell_index)');
aed = aed.Append_CR('                    {');
aed = aed.Append_CR('                    // then, this should not happen!');
aed = aed.Append_CR('                    mexPrintf("An edge appears more than once, and referenced to the same cell,\\n");');
aed = aed.Append_CR('                    mexPrintf("        in an internal list of this sub-routine!\\n");');
aed = aed.Append_CR('                    mexPrintf("This should never happen!\\n");');
aed = aed.Append_CR('                    mexPrintf("Please report this bug!\\n");');
aed = aed.Append_CR('                    mexErrMsgTxt("STOP!\\n");');
aed = aed.Append_CR('                    }');
aed = aed.Append_CR('                }');
aed = aed.Append_CR('');
aed = aed.Append_CR('            // allocate DoFs on edge in positive order');
aed = aed.Append_CR('            if (local_edge_index>0)');
aed = aed.Append_CR('                {');

% edge DoF
Num_Set = 0;
TAB = '                ';
aed = aed.Append_CR([TAB, obj.String.BEGIN_Auto_Gen]);
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).E)
        Num_Set = Num_Set + 1;
        Set_Ind_str = num2str(Num_Set);
        aed = aed.Append_CR([TAB, '// Set ', Set_Ind_str, ':']);
        for di=1:size(Elem_Nodal_Top(nnt).E{ind},2)
            aed = aed.Append_CR([TAB, 'cell_dof[ Node.E[', Set_Ind_str, '][local_edge_index][', num2str(di),...
                                      '] ][cell_index] = ',...
                                      'SE_DoF[', Set_Ind_str, '][', num2str(di), '];']);
        end
    end
end
aed = aed.Append_CR([TAB, obj.String.END_Auto_Gen]);

aed = aed.Append_CR('                }');
aed = aed.Append_CR('            // allocate DoFs on edge in negative order');
aed = aed.Append_CR('            if (local_edge_index<0)');
aed = aed.Append_CR('                {');

% edge DoF
Num_Set = 0;
TAB = '                ';
aed = aed.Append_CR([TAB, obj.String.BEGIN_Auto_Gen]);
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).E)
        Num_Set = Num_Set + 1;
        Set_Ind_str = num2str(Num_Set);
        aed = aed.Append_CR([TAB, '// Set ', Set_Ind_str, ':']);
        nd = size(Elem_Nodal_Top(nnt).E{ind},2);
        for di=1:nd
            aed = aed.Append_CR([TAB, 'cell_dof[ Node.E[', Set_Ind_str, '][-local_edge_index][', num2str(nd-di+1),...
                                      '] ][cell_index] = ',...
                                      'SE_DoF[', Set_Ind_str, '][', num2str(di), '];']);
        end
    end
end
aed = aed.Append_CR([TAB, obj.String.END_Auto_Gen]);

aed = aed.Append_CR('                }');
aed = aed.Append_CR('            }');
aed = aed.Append_CR('        // store the number of unique edges');
aed = aed.Append_CR('        Tri_Edge_Search->Num_Unique_Edges = EDGE_COUNT;');
aed = aed.Append_CR('        }');
aed = aed.Append_CR('    return Edge_DoF_Counter;');
aed = aed.Append_CR('}');
aed = aed.Append_CR(obj.String.Separator);
aed = aed.Append_CR('');
aed = aed.Append_CR('');

end