function afd = Elem_DoF_Allocator_assign_face_dof_3D_tetrahedron(obj,Elem)
%Elem_DoF_Allocator_assign_face_dof_3D_tetrahedron
%
%   This stores lines of code for sub-sections of the
%   'Elem_DoF_Allocator.cc' C++ code file.

% Copyright (c) 05-29-2013,  Shawn W. Walker

Elem_Nodal_Top         = Elem.Nodal_Top;
Num_Separate_Nodal_Top = length(Elem_Nodal_Top);

%%%%%%%
afd = FELtext('Assign_Face_DoF');
%%%
afd = afd.Append_CR(obj.String.Separator);
afd = afd.Append_CR('/* allocate the face DoFs */');
afd = afd.Append_CR('int EDA::Assign_Face_DoF(TETRAHEDRON_DATA*      Tet_Data,    // inputs (list of tets)');
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
afd = afd.Append_CR('        int FACE_COUNT = 0;');
afd = afd.Append_CR('        for (fi=Tet_Data->Face_List.begin(); fi!=Tet_Data->Face_List.end(); ++fi)');
afd = afd.Append_CR('            {');
afd = afd.Append_CR('            const FACE_TO_CELL Current_FI = *fi;');
afd = afd.Append_CR('            const bool NEW_FACE = (Prev_FI.face_info[0]!=Current_FI.face_info[0]) ||');
afd = afd.Append_CR('                                  (Prev_FI.face_info[1]!=Current_FI.face_info[1]) ||');
afd = afd.Append_CR('                                  (Prev_FI.face_info[2]!=Current_FI.face_info[2]);');
afd = afd.Append_CR('            const unsigned int cell_index       = Current_FI.face_info[3];');
afd = afd.Append_CR('            const unsigned int local_face_index = Current_FI.face_info[4];');
afd = afd.Append_CR('');
afd = afd.Append_CR('            // if this face has NOT been visited yet');
afd = afd.Append_CR('            if (NEW_FACE)');
afd = afd.Append_CR('                {');
afd = afd.Append_CR('                FACE_COUNT++;');
afd = afd.Append_CR('                Prev_FI = Current_FI; // update previous');
afd = afd.Append_CR('');
afd = afd.Append_CR('                // generate new DoF''s');

% the Face_List is sorted so that every unique face of the mesh appears in
% pairs: one for each tet that shares that face
%
% therefore, the first face (in the pair) is treated as the "positively"
% oriented one.  moreover, its DoF can be allocated in an arbitrary manner.
%
% the second face (in the pair) is then treated as "negatively" oriented.  thus,
% its DoFs must be allocated in a consistent way relative to the first face.
%
% example:  A,B,C are the vertices of the faces:
%           F_1 = [A, B, C], F_2 = [B, A, C], (in original unsorted ordering)
%           and numbers are DoFs:
%
%               C                  C
%               *                  *
%             3/ \2              2/ \3
%            4/   \1            1/   \4
%            / F_1 \            / F_2 \
%          A*-------*B        B*-------*A
%              5 6                6 5
%
% The local edges of F_1 are: E_1 = [B, C], E_2 = [C, A], E_3 = [A, B]
% The local edges of F_2 are: E_1 = [A, C], E_2 = [C, B], E_3 = [B, A]
%
% Therefore,
%    the DoFs on E_1 of F_1 get mapped to
%    the DoFs on E_2 of F_2 in *reverse* order
%
%    the DoFs on E_2 of F_2 get mapped to
%    the DoFs on E_1 of F_2 in *reverse* order
%
%    the DoFs on E_3 of F_1 get mapped to
%    the DoFs on E_3 of F_2 in *reverse* order
%
% so, after allocating DoFs on the first face, we obtain the DoFs on the second
% face by reversing the order of the DoFs on each edge of the face, AND by
% swapping two of the edges.  Which two edges depends on how the faces were
% initially defined.
%
% There are three possibilities for this:
%
%    (1)   F_1 = [A, B, C],   F_2 = [A, C, B]  (do NOT swap edge 1)
%    (2)   F_1 = [A, B, C],   F_2 = [C, B, A]  (do NOT swap edge 2)
%    (3)   F_1 = [A, B, C],   F_2 = [B, A, C]  (do NOT swap edge 3)
%
% This is implemented below by first determining which edge NOT to swap.


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
afd = afd.Append_CR('            else');
afd = afd.Append_CR('                {');
afd = afd.Append_CR('                // if the same face is contained in the same cell as the previous');
afd = afd.Append_CR('                if (Prev_FI.face_info[3]==cell_index)');
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
afd = afd.Append_CR('            // allocate DoFs on new (first) face (in an arbitrary order)');
afd = afd.Append_CR('            if (NEW_FACE)');
afd = afd.Append_CR('                {');

% face DoF
Num_Set = 0;
TAB = '                ';
afd = afd.Append_CR([TAB, obj.String.BEGIN_Auto_Gen]);
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).F)
        Num_Set = Num_Set + 1;
        Set_Ind_str = num2str(Num_Set);
        afd = afd.Append_CR([TAB, '// Set ', Set_Ind_str, ': write DoFs in an arbitrary, but fixed order']);
        for di=1:size(Elem_Nodal_Top(nnt).F{ind},2)
            afd = afd.Append_CR([TAB, 'cell_dof[ Node.F[', Set_Ind_str, '][local_face_index][', num2str(di),...
                                      '] ][cell_index] = ',...
                                      'SF_DoF[', Set_Ind_str, '][', num2str(di), '];']);
        end
    end
end
afd = afd.Append_CR([TAB, obj.String.END_Auto_Gen]);

afd = afd.Append_CR('                }');
afd = afd.Append_CR('            // allocate DoFs on opposite (second) face in *reverse* order (with respect to each edge) and swap two of the edges');
afd = afd.Append_CR('            else');
afd = afd.Append_CR('                {');
afd = afd.Append_CR('                const unsigned int NOT_SWAP = Tet_Data->Determine_Edge_NOT_To_Swap_In_Face(Prev_FI.face_info[5],Current_FI.face_info[5]);');

afd = afd.Append_CR('                if (NOT_SWAP==1) // swap edges 2 & 3');
afd = afd.Append_CR('                    {');
%afd = afd.Append_CR('                    mexPrintf("SWAP 2 & 3.\\n");');
% face DoF
Num_Set = 0;
TAB = '                    ';
afd = afd.Append_CR([TAB, obj.String.BEGIN_Auto_Gen]);
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).F)
        Num_Set = Num_Set + 1;
        afd = assign_local_face_dof_reverse(afd,TAB,Num_Set,Elem_Nodal_Top(nnt).F{ind},[1 3 2]);
    end
end
afd = afd.Append_CR([TAB, obj.String.END_Auto_Gen]);
afd = afd.Append_CR('                    }');


afd = afd.Append_CR('                else if (NOT_SWAP==2) // swap edges 1 & 3');
afd = afd.Append_CR('                    {');
%afd = afd.Append_CR('                    mexPrintf("SWAP 1 & 3.\\n");');
% face DoF
Num_Set = 0;
afd = afd.Append_CR([TAB, obj.String.BEGIN_Auto_Gen]);
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).F)
        Num_Set = Num_Set + 1;
        afd = assign_local_face_dof_reverse(afd,TAB,Num_Set,Elem_Nodal_Top(nnt).F{ind},[3 2 1]);
    end
end
afd = afd.Append_CR([TAB, obj.String.END_Auto_Gen]);
afd = afd.Append_CR('                    }');


afd = afd.Append_CR('                else // if (NOT_SWAP==3) // swap edges 1 & 2');
afd = afd.Append_CR('                    {');
%afd = afd.Append_CR('                    mexPrintf("SWAP 1 & 2.\\n");');
% face DoF
Num_Set = 0;
afd = afd.Append_CR([TAB, obj.String.BEGIN_Auto_Gen]);
for nnt=1:Num_Separate_Nodal_Top
    for ind=1:length(Elem_Nodal_Top(nnt).F)
        Num_Set = Num_Set + 1;
        afd = assign_local_face_dof_reverse(afd,TAB,Num_Set,Elem_Nodal_Top(nnt).F{ind},[2 1 3]);
    end
end
afd = afd.Append_CR([TAB, obj.String.END_Auto_Gen]);
afd = afd.Append_CR('                    }');


afd = afd.Append_CR('                }');
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

function afd = assign_local_face_dof_reverse(afd,TAB,Num_Set,F,edge_map)
%
%   This allocates the DoFs for the "negatively" oriented face, using the
%   pre-allocated DoFs for the "positively" oriented face.
%
%   Note: the first "new" face is considered to be "positively" oriented.  The
%         next face with the same vertices is "negatively" oriented.
%
%   example:
%   afd = assign_local_face_dof_reverse(afd,TAB,Num_Set,Elem_Nodal_Top(nnt).F{ind},[1 3 2]);

Set_Ind_str = num2str(Num_Set);

% get face (w.r.t. 3 edges) DoF info
Num_DoF_per_Face = size(F,2);

if (Num_DoF_per_Face==1) % special case
    % the DoF is at the CENTER of the face, so it is NOT associated with the
    % edges of the face
    
    % example of: setting a *single* DoF on a face
    %
    % // Set k: write DoF for center of face
    % cell_dof[ Node.F[k][local_face_index][1] ][cell_index] = SF_DoF[k][1];
    %%%%
    afd = afd.Append_CR([TAB, '// Set ', Set_Ind_str, ': write DoF for center of face']);
    afd = afd.Append_CR([TAB, 'cell_dof[ Node.F[', Set_Ind_str, '][local_face_index][', num2str(1),...
                              '] ][cell_index] = SF_DoF[', Set_Ind_str, '][', num2str(1), '];']);
else
    
    Num_DoF_per_Edge = Num_DoF_per_Face/3;
    if (round(Num_DoF_per_Edge)~=(Num_DoF_per_Edge))
        error('Number of DoFs per face must be one OR a multiple of three!  Else it is NOT a legal finite element.');
    end
    
    temp = (1:1:Num_DoF_per_Edge);
    Edof_ref = [];
    for ei = 1:3
        Edof_ref = [Edof_ref; temp + (ei-1)*Num_DoF_per_Edge];
    end
    
    % reverse and map edge DoFs
    Edof = Edof_ref(:,end:-1:1);
    Edof = Edof(edge_map,:);
    
    % example of: edge map [1 2 3] -> [1 3 2] (swap edges 2 & 3)
    %
    % // Set 1: write DoFs in reverse order from before
    % // edge 1
    % cell_dof[ Node.F[1][local_face_index][2] ][cell_index] = SF_DoF[1][1];
    % cell_dof[ Node.F[1][local_face_index][1] ][cell_index] = SF_DoF[1][2];
    % // edge 2
    % cell_dof[ Node.F[1][local_face_index][6] ][cell_index] = SF_DoF[1][3];
    % cell_dof[ Node.F[1][local_face_index][5] ][cell_index] = SF_DoF[1][4];
    % // edge 3
    % cell_dof[ Node.F[1][local_face_index][4] ][cell_index] = SF_DoF[1][5];
    % cell_dof[ Node.F[1][local_face_index][3] ][cell_index] = SF_DoF[1][6];
    %%%%
    afd = afd.Append_CR([TAB, '// Set ', Set_Ind_str, ': write DoFs in reverse order from before']);
    for ei=1:3
        afd = afd.Append_CR([TAB, '// edge ', num2str(ei)]);
        for di=1:Num_DoF_per_Edge
            afd = afd.Append_CR([TAB, 'cell_dof[ Node.F[', Set_Ind_str, '][local_face_index][', num2str(Edof(ei,di)),...
                '] ][cell_index] = SF_DoF[', Set_Ind_str, '][', num2str(Edof_ref(ei,di)), '];']);
        end
    end
end

end