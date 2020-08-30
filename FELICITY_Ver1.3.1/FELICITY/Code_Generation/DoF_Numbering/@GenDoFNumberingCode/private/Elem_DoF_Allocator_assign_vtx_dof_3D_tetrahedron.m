function avd = Elem_DoF_Allocator_assign_vtx_dof_3D_tetrahedron(obj,Elem)
%Elem_DoF_Allocator_assign_vtx_dof_3D_tetrahedron
%
%   This stores lines of code for sub-sections of the
%   'Elem_DoF_Allocator.cc' C++ code file.

% Copyright (c) 12-01-2010,  Shawn W. Walker

Elem_Nodal_Top         = Elem.Nodal_Top;
Num_Separate_Nodal_Top = length(Elem_Nodal_Top);

%%%%%%%
avd = FELtext('Assign_Vtx_DoF');
%%%
avd = avd.Append_CR(obj.String.Separator);
avd = avd.Append_CR('/* allocate the vertex DoFs */');
avd = avd.Append_CR('int EDA::Assign_Vtx_DoF(TETRAHEDRON_DATA*      Tet_Data,     // inputs (list of tets)');
avd = avd.Append_CR('                        const int              DoF_Offset)');
avd = avd.Append_CR('{');
avd = avd.Append_CR('    // for every vertex, store the first tet (with local vertex index) that allocated DoFs for it');
avd = avd.Append_CR('    vector<int> Vtx_to_Tet[2];');
avd = avd.Append_CR('    Vtx_to_Tet[0].resize((unsigned int)(Tet_Data->Max_Vtx_Index+1));');
avd = avd.Append_CR('    Vtx_to_Tet[1].resize((unsigned int)(Tet_Data->Max_Vtx_Index+1));');
avd = avd.Append_CR('');
avd = avd.Append_CR('    int Vtx_DoF_Counter = DoF_Offset;');
avd = avd.Append_CR('    // allocate DoFs for the global vertices that are actually present');
avd = avd.Append_CR('    if (Num_DoF_Per_Vtx > 0)');
avd = avd.Append_CR('        {');
avd = avd.Append_CR('        int VTX_COUNT = 0; // keep track of the number of unique vertices');
avd = avd.Append_CR('        for (int ti=0; ti < Tet_Data->Num_Tet; ti++)');
avd = avd.Append_CR('            {');
avd = avd.Append_CR('            // loop thru all vertices of each tet');
avd = avd.Append_CR('            for (int vtxi=0; vtxi < NUM_VTX; vtxi++)');
avd = avd.Append_CR('                {');
avd = avd.Append_CR('                const unsigned int Vertex = (unsigned int) Tet_Data->Tet_DoF[vtxi][ti];');
avd = avd.Append_CR('                const int tet_ind         =   ti+1; // put into MATLAB-style indexing');
avd = avd.Append_CR('                const int vtx_ind         = vtxi+1; // put into MATLAB-style indexing');
avd = avd.Append_CR('                // if this vertex has NOT been visited yet');
avd = avd.Append_CR('                if (Vtx_to_Tet[0][Vertex]==0)');
avd = avd.Append_CR('                    {');
avd = avd.Append_CR('                    VTX_COUNT++;');
avd = avd.Append_CR('');
avd = avd.Append_CR('                    // remember which tet is associated with this vertex');
avd = avd.Append_CR('                    Vtx_to_Tet[0][Vertex] = tet_ind;');
avd = avd.Append_CR('                    // remember the local vertex');
avd = avd.Append_CR('                    Vtx_to_Tet[1][Vertex] = vtx_ind;');
avd = avd.Append_CR('');

% vertex DoF
Num_Set = 0;
TAB = '                    ';
avd = avd.Append_CR([TAB, obj.String.BEGIN_Auto_Gen]);
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).V)
        Num_Set = Num_Set + 1;
        Set_Ind_str = num2str(Num_Set);
        avd = avd.Append_CR([TAB, '// Set ', Set_Ind_str, ': add more DoFs']);
        for di=1:size(Elem_Nodal_Top(nnt).V{ind},2)
            avd = avd.Append_CR([TAB, 'Vtx_DoF_Counter++;']);
            avd = avd.Append_CR([TAB, 'cell_dof[ Node.V[', Set_Ind_str,...
                                      '][vtx_ind][', num2str(di), '] ][ti] = Vtx_DoF_Counter;']);
        end
    end
end
avd = avd.Append_CR([TAB, obj.String.END_Auto_Gen]);

avd = avd.Append_CR('                    }');
avd = avd.Append_CR('                else');
avd = avd.Append_CR('                    {');
avd = avd.Append_CR('                    const int old_ti      = Vtx_to_Tet[0][Vertex]-1; // put into C-style indexing');
avd = avd.Append_CR('                    const int old_vtx_ind = Vtx_to_Tet[1][Vertex];');
avd = avd.Append_CR('');

% vertex DoF
Num_Set = 0;
TAB = '                    ';
avd = avd.Append_CR([TAB, obj.String.BEGIN_Auto_Gen]);
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).V)
        Num_Set = Num_Set + 1;
        Set_Ind_str = num2str(Num_Set);
        avd = avd.Append_CR([TAB, '// Set ', Set_Ind_str, ': copy over DoFs']);
        for di=1:size(Elem_Nodal_Top(nnt).V{ind},2)
            avd = avd.Append_CR([TAB, 'cell_dof[ Node.V[', Set_Ind_str,...
                                      '][vtx_ind][', num2str(di), '] ][ti] = ',...
                                      'cell_dof[ Node.V[', Set_Ind_str,...
                                      '][old_vtx_ind][', num2str(di), '] ][old_ti];']);
        end
    end
end
avd = avd.Append_CR([TAB, obj.String.END_Auto_Gen]);

avd = avd.Append_CR('                    }');
avd = avd.Append_CR('                }');
avd = avd.Append_CR('            }');
avd = avd.Append_CR('        // store the number of unique vertices');
avd = avd.Append_CR('        Tet_Data->Num_Unique_Vertices = VTX_COUNT;');
avd = avd.Append_CR('        }');
avd = avd.Append_CR('    return Vtx_DoF_Counter;');
avd = avd.Append_CR('}');
avd = avd.Append_CR(obj.String.Separator);
avd = avd.Append_CR('');
avd = avd.Append_CR('');

end