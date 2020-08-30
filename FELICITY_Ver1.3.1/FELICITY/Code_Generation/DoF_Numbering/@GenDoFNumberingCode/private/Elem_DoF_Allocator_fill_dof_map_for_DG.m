function fdm = Elem_DoF_Allocator_fill_dof_map_for_DG(obj,Elem)
%Elem_DoF_Allocator_fill_dof_map_for_DG
%
%   This stores lines of code for sub-sections of the
%   'Elem_DoF_Allocator.cc' C++ code file.

% Copyright (c) 12-01-2010,  Shawn W. Walker

% /* assign DoFs */
% void EDA::Fill_DoF_Map(TRIANGLE_EDGE_SEARCH*  Tri_Edge_Search)
% {
%     // output what we are doing
%     printf("Generating DoFs on ");
%     printf(Domain);
%     printf("s for the Finite Element: ");
%     printf(Name);
%     printf(".\n");
% 
%     // write the local to global DoF mapping
%     int DoF_Counter = 0;
%     for (int ti=0; ti < Tri_Edge_Search->Num_Tri; ti++)
%         {
%         for (int i = 1; (i <= Total_DoF_Per_Cell); i++) // note: off by one because of C-style indexing!
%             {
%             DoF_Counter++;
%             cell_dof[i][ti] = DoF_Counter;
%             }
%         }
% }

% get dimension
Dim = Elem.Dim;

if (Dim==1)
    FILL_DOF_MAP_str = 'void EDA::Fill_DoF_Map(EDGE_POINT_SEARCH*  Edge_Point_Search)';
    FOR_LOOP_str     = '    for (int ind=0; ind < Edge_Point_Search->Num_Edge; ind++)';
    ERR_CHK_str      = '    Error_Check_DoF_Map(Edge_Point_Search->Num_Edge);';
elseif (Dim==2)
    FILL_DOF_MAP_str = 'void EDA::Fill_DoF_Map(TRIANGLE_EDGE_SEARCH*  Tri_Edge_Search)';
    FOR_LOOP_str     = '    for (int ind=0; ind < Tri_Edge_Search->Num_Tri; ind++)';
    ERR_CHK_str      = '    Error_Check_DoF_Map(Tri_Edge_Search->Num_Tri);';
elseif (Dim==3)
    FILL_DOF_MAP_str = 'void EDA::Fill_DoF_Map(TETRAHEDRON_DATA*  Tet_Data)';
    FOR_LOOP_str     = '    for (int ind=0; ind < Tet_Data->Num_Tet; ind++)';
    ERR_CHK_str      = '    Error_Check_DoF_Map(Tet_Data->Num_Tet);';
else
    error('NOT implemented!');
end

%%%%%%%
fdm = FELtext('Fill_DoF_Map');
%%%
fdm = fdm.Append_CR(obj.String.Separator);
fdm = fdm.Append_CR('/* assign DoFs (DG-style) */');
fdm = fdm.Append_CR(FILL_DOF_MAP_str);
fdm = fdm.Append_CR('{');
fdm = fdm.Append_CR('    // output what we are doing');
fdm = fdm.Append_CR('    printf("Generating DoFs on ");');
fdm = fdm.Append_CR('    printf(Domain);');
fdm = fdm.Append_CR('    printf("s for the Finite Element: ");');
fdm = fdm.Append_CR('    printf(Name);');
fdm = fdm.Append_CR('    printf(".\\n");');
fdm = fdm.Append_CR('');
fdm = fdm.Append_CR('    // write the local to global DoF mapping');
fdm = fdm.Append_CR('    int DoF_Counter = 0;');
fdm = fdm.Append_CR(FOR_LOOP_str);
fdm = fdm.Append_CR('        {');
fdm = fdm.Append_CR('        for (int i = 1; (i <= Total_DoF_Per_Cell); i++) // note: off by one because of C-style indexing!');
fdm = fdm.Append_CR('            {');
fdm = fdm.Append_CR('            DoF_Counter++;');
fdm = fdm.Append_CR('            cell_dof[i][ind] = DoF_Counter;');
fdm = fdm.Append_CR('            }');
fdm = fdm.Append_CR('        }');
fdm = fdm.Append_CR(ERR_CHK_str);
fdm = fdm.Append_CR('}');
fdm = fdm.Append_CR(obj.String.Separator);
fdm = fdm.Append_CR('');
fdm = fdm.Append_CR('');

end