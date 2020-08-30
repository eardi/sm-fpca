function fdm = Elem_DoF_Allocator_fill_dof_map_2D_triangle(obj)
%Elem_DoF_Allocator_fill_dof_map_2D_triangle
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
%     int DoF_Offset = 0;
%     DoF_Offset = Assign_Vtx_DoF (Tri_Edge_Search, DoF_Offset);
%     DoF_Offset = Assign_Edge_DoF(Tri_Edge_Search, DoF_Offset);
%     DoF_Offset = Assign_Face_DoF(Tri_Edge_Search, DoF_Offset);
%     DoF_Offset = Assign_Tet_DoF (Tri_Edge_Search, DoF_Offset);
% }

%%%%%%%
fdm = FELtext('Fill_DoF_Map');
%%%
fdm = fdm.Append_CR(obj.String.Separator);
fdm = fdm.Append_CR('/* assign DoFs */');
fdm = fdm.Append_CR('void EDA::Fill_DoF_Map(TRIANGLE_EDGE_SEARCH*  Tri_Edge_Search)');
fdm = fdm.Append_CR('{');
fdm = fdm.Append_CR('    // output what we are doing');
fdm = fdm.Append_CR('    printf("Generating DoFs on ");');
fdm = fdm.Append_CR('    printf(Domain);');
fdm = fdm.Append_CR('    printf("s for the Finite Element: ");');
fdm = fdm.Append_CR('    printf(Name);');
fdm = fdm.Append_CR('    printf(".\\n");');
fdm = fdm.Append_CR('');
fdm = fdm.Append_CR('    // write the local to global DoF mapping');
fdm = fdm.Append_CR('    int DoF_Offset = 0;');
fdm = fdm.Append_CR('    DoF_Offset = Assign_Vtx_DoF (Tri_Edge_Search, DoF_Offset);');
fdm = fdm.Append_CR('    DoF_Offset = Assign_Edge_DoF(Tri_Edge_Search, DoF_Offset);');
fdm = fdm.Append_CR('    DoF_Offset = Assign_Face_DoF(Tri_Edge_Search, DoF_Offset);');
fdm = fdm.Append_CR('    DoF_Offset = Assign_Tet_DoF (Tri_Edge_Search, DoF_Offset);');
fdm = fdm.Append_CR('    Error_Check_DoF_Map(Tri_Edge_Search->Num_Tri);');
fdm = fdm.Append_CR('}');
fdm = fdm.Append_CR(obj.String.Separator);
fdm = fdm.Append_CR('');
fdm = fdm.Append_CR('');

end