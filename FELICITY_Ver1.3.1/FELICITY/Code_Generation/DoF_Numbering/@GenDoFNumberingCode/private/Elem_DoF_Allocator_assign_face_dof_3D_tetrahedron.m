function afd = Elem_DoF_Allocator_assign_face_dof_3D_tetrahedron(obj,Elem)
%Elem_DoF_Allocator_assign_face_dof_3D_tetrahedron
%
%   This stores lines of code for sub-sections of the
%   'Elem_DoF_Allocator.cc' C++ code file.

% Copyright (c) 10-15-2016,  Shawn W. Walker

Elem_Nodal_Top         = Elem.Nodal_Top;
Num_Separate_Nodal_Top = length(Elem_Nodal_Top);

if (Num_Separate_Nodal_Top~=1)
    error('This should not happen!  Or the code needs to change!');
end

%%%%%%%
afd = FELtext('Assign_Face_DoF');
%%%
afd = afd.Append_CR(obj.String.Separator);
afd = afd.Append_CR('/* allocate the face DoFs */');
afd = afd.Append_CR('int EDA::Assign_Face_DoF(TETRAHEDRON_DATA*      Tet_Data,    // inputs (list of faces in tetrahedral mesh)');
afd = afd.Append_CR('                         const int              DoF_Offset)');
afd = afd.Append_CR('{');
afd = afd.Append_CR('    int Face_DoF_Counter = DoF_Offset;');
afd = afd.Append_CR('    // allocate DoFs for the faces in the triangulation');
afd = afd.Append_CR('    if (Num_DoF_Per_Face > 0)');
afd = afd.Append_CR('        {');
afd = afd.Append_CR('        // temp storage for DoFs on face');
afd = afd.Append_CR('        int SF_DoF[Num_Face_Sets+1][Max_DoF_Per_Face+1];');
afd = afd.Append_CR('        // initialize to NULL value');
afd = afd.Append_CR('        for (int ind1=0; ind1 < Num_Face_Sets+1; ind1++)');
afd = afd.Append_CR('        for (int ind2=0; ind2 < Max_DoF_Per_Face+1; ind2++)');
afd = afd.Append_CR('            SF_DoF[ind1][ind2] = -1;');
afd = afd.Append_CR('');
afd = afd.Append_CR('        // initialize previous face to NULL');
afd = afd.Append_CR('        FACE_TO_CELL Prev_FI;');
afd = afd.Append_CR('        Prev_FI.face_info[0] = 0;');
afd = afd.Append_CR('        Prev_FI.face_info[1] = 0;');
afd = afd.Append_CR('        Prev_FI.face_info[2] = 0;');
afd = afd.Append_CR('        Prev_FI.face_info[3] = 0;');
afd = afd.Append_CR('        Prev_FI.face_info[4] = 0;');
afd = afd.Append_CR('        Prev_FI.face_info[5] = 0;');
afd = afd.Append_CR('');
afd = afd.Append_CR('        std::vector<FACE_TO_CELL>::iterator fi; // need iterator');
afd = afd.Append_CR('        unsigned int initial_local_face_index = 100; // init to a bogus value');
afd = afd.Append_CR('        unsigned int initial_perm             = 100; // init to a bogus value');
afd = afd.Append_CR('        int FACE_COUNT = 0;');
afd = afd.Append_CR('        for (fi=Tet_Data->Face_List.begin(); fi!=Tet_Data->Face_List.end(); ++fi)');
afd = afd.Append_CR('            {');
afd = afd.Append_CR('            const FACE_TO_CELL Current_FI = *fi;');
afd = afd.Append_CR('            // determine if this face is different from the previous face');
afd = afd.Append_CR('            const bool NEW_FACE = (Prev_FI.face_info[0]!=Current_FI.face_info[0]) ||');
afd = afd.Append_CR('                                  (Prev_FI.face_info[1]!=Current_FI.face_info[1]) ||');
afd = afd.Append_CR('                                  (Prev_FI.face_info[2]!=Current_FI.face_info[2]);');
afd = afd.Append_CR('            // get the current cell index, local face index, and permutation');
afd = afd.Append_CR('            const unsigned int current_cell_index       = Current_FI.face_info[3];');
afd = afd.Append_CR('            const unsigned int current_local_face_index = Current_FI.face_info[4];');
afd = afd.Append_CR('            const unsigned int current_perm             = Current_FI.face_info[5];');
afd = afd.Append_CR('');
afd = afd.Append_CR('            // if this face has NOT been visited yet');
afd = afd.Append_CR('            if (NEW_FACE)');
afd = afd.Append_CR('                {');
afd = afd.Append_CR('                FACE_COUNT++;');
afd = afd.Append_CR('                Prev_FI = Current_FI; // update previous');
afd = afd.Append_CR('');
afd = afd.Append_CR('                // store the local face index that these DoFs will be allocated on');
afd = afd.Append_CR('                initial_local_face_index = current_local_face_index;');
afd = afd.Append_CR('                initial_perm             = current_perm;');
afd = afd.Append_CR('');
afd = afd.Append_CR('                // store new DoF''s in a temporary structure');

% face DoF
Num_Set = 0;
TAB = '                ';
afd = afd.Append_CR([TAB, obj.String.BEGIN_Auto_Gen]);
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).F)
        Num_Set = Num_Set + 1;
        Set_Ind_str = num2str(Num_Set);
        afd = afd.Append_CR([TAB, '// Set ', Set_Ind_str, ': add more DoFs']);
        for di=1:size(Elem_Nodal_Top(nnt).F{ind},2)
            afd = afd.Append_CR([TAB, 'Face_DoF_Counter++;']);
            afd = afd.Append_CR([TAB, 'SF_DoF[', Set_Ind_str, '][', num2str(di), '] = Face_DoF_Counter;']);
        end
    end
end
afd = afd.Append_CR([TAB, obj.String.END_Auto_Gen]);
afd = afd.Append_CR('                }');
afd = afd.Append_CR('            else // we are still on the same global face');
afd = afd.Append_CR('                {');
afd = afd.Append_CR('                // if the previous face and the current face are contained in the same cell (tetrahedron)');
afd = afd.Append_CR('                if (Prev_FI.face_info[3]==current_cell_index)');
afd = afd.Append_CR('                    {');
afd = afd.Append_CR('                    // then, this should not happen!');
afd = afd.Append_CR('                    mexPrintf("A face appears more than once, and referenced to the same cell,\\n");');
afd = afd.Append_CR('                    mexPrintf("        in an internal list of this sub-routine!\\n");');
afd = afd.Append_CR('                    mexPrintf("This should never happen!\\n");');
afd = afd.Append_CR('                    mexPrintf("Please report this bug!\\n");');
afd = afd.Append_CR('                    mexErrMsgTxt("STOP!\\n");');
afd = afd.Append_CR('                    }');
afd = afd.Append_CR('                }');
afd = afd.Append_CR('');
afd = afd.Append_CR('            const int* face_perm_map = NULL; // this holds the permutation to apply');
afd = afd.Append_CR('            const int cfi = (int) current_local_face_index;');
afd = afd.Append_CR('');

% face DoF
Num_Set = 0;
TAB = '            ';
afd = afd.Append_CR([TAB, obj.String.BEGIN_Auto_Gen]);
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).F)
        Num_Set = Num_Set + 1;
        Set_Ind_str = num2str(Num_Set);
        afd = afd.Append_CR([TAB, '// Set ', Set_Ind_str, ':']);
        afd = afd.Append_CR([TAB, 'face_perm_map = Face_DoF_Perm.Get_Map(', Set_Ind_str, ', ',...
                                  'current_local_face_index, current_perm, initial_local_face_index, initial_perm);']);

        Num_di = size(Elem_Nodal_Top(nnt).F{ind},2);
        for di=1:Num_di
            afd = afd.Append_CR([TAB, 'cell_dof[ Node.F[', Set_Ind_str, '][cfi][', num2str(di),...
                                      '] ][current_cell_index] = ',...
                                      'SF_DoF[', Set_Ind_str, '][ ', 'face_perm_map[', num2str(di), '] ];']);
        end
        if (Num_di==0)
            afd = afd.Append_CR([TAB, '// do *nothing*; there are no face DoFs here']);
        end
    end
end
afd = afd.Append_CR([TAB, obj.String.END_Auto_Gen]);

afd = afd.Append_CR('            }');
afd = afd.Append_CR('        // store the number of unique faces');
afd = afd.Append_CR('        Tet_Data->Num_Unique_Faces = FACE_COUNT;');
afd = afd.Append_CR('        }');
afd = afd.Append_CR('    return Face_DoF_Counter;');
afd = afd.Append_CR('}');
afd = afd.Append_CR(obj.String.Separator);
afd = afd.Append_CR('');
afd = afd.Append_CR('');

end