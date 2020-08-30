function afd = assign_face_dof_3D_tet_SUBroutine(afd,TAB,Num_Set,F,edge_map)
%assign_face_dof_3D_tet_SUBroutine
%
%   This is used in 'Elem_DoF_Allocator_assign_face_dof_3D_tetrahedron'.
%
%   afd = assign_face_dof_3D_tet_SUBroutine(afd,TAB,Num_Set,Elem_Nodal_Top(nnt).F{ind},[1 3 2]);

% Copyright (c) 04-07-2010,  Shawn W. Walker

error('do NOT use!');

Set_Ind_str = num2str(Num_Set);

% get face (w.r.t. 3 edges) DoF info
Num_DoF_per_Face = size(F,2);
Num_DoF_per_Edge = Num_DoF_per_Face/3;
if (round(Num_DoF_per_Edge)~=(Num_DoF_per_Edge))
    error('Number of DoFs per face must be a multiple of three!  Else it is NOT a legal finite element.');
end

temp = (1:1:Num_DoF_per_Edge);
Edof_ref = [];
for ei = 1:3
    Edof_ref = [Edof_ref; temp + (ei-1)*Num_DoF_per_Edge];
end

% reverse and map edge DoFs
Edof = Edof_ref(:,end:-1:1);
Edof = Edof(edge_map,:);

% // edge map [1 2 3] -> [1 3 2]
% // Set 1: copy over DoFs
% // edge 1
% cell_dof[ Node.F[1][face_ind][2] ][ti] = cell_dof[ Node.F[1][old_face_ind][1] ][old_ti];
% cell_dof[ Node.F[1][face_ind][1] ][ti] = cell_dof[ Node.F[1][old_face_ind][2] ][old_ti];
% // edge 2
% cell_dof[ Node.F[1][face_ind][6] ][ti] = cell_dof[ Node.F[1][old_face_ind][3] ][old_ti];
% cell_dof[ Node.F[1][face_ind][5] ][ti] = cell_dof[ Node.F[1][old_face_ind][4] ][old_ti];
% // edge 3
% cell_dof[ Node.F[1][face_ind][4] ][ti] = cell_dof[ Node.F[1][old_face_ind][5] ][old_ti];
% cell_dof[ Node.F[1][face_ind][3] ][ti] = cell_dof[ Node.F[1][old_face_ind][6] ][old_ti];
%%%%

afd = afd.Append_CR([TAB, '// Set ', Set_Ind_str, ': copy over DoFs']);
for ei=1:3
    afd = afd.Append_CR([TAB, '// edge ', num2str(ei)]);
    for di=1:Num_DoF_per_Edge
        afd = afd.Append_CR([TAB, 'cell_dof[ Node.F[', Set_Ind_str, '][face_ind][', num2str(Edof(ei,di)),...
                                   '] ][ti] = cell_dof[ Node.F[', Set_Ind_str, '][old_face_ind][',...
                                   num2str(Edof_ref(ei,di)), '] ][old_ti];']);
    end
end

end