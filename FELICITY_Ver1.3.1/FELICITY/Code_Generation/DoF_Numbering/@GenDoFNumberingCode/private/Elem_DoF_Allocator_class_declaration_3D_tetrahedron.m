function clss = Elem_DoF_Allocator_class_declaration_3D_tetrahedron(obj,Elem)
%Elem_DoF_Allocator_class_declaration_3D_tetrahedron
%
%   This stores lines of code for sub-sections of the
%   'Elem_DoF_Allocator.cc' C++ code file.

% Copyright (c) 10-14-2016,  Shawn W. Walker

Elem_Nodal_Top = Elem.Nodal_Top;
Elem_Nodal_Var = Elem.Nodal_Var;

%%%%%%%
clss = FELtext('class declaration');

clss = clss.Append_CR(obj.String.Separator);
clss = clss.Append_CR('// data structure containing information on the local element DoF numbering');
clss = clss.Append_CR('typedef struct');
clss = clss.Append_CR('{');
clss = clss.Append_CR('    int  V[Num_Vtx_Sets +1][NUM_VTX +1][Max_DoF_Per_Vtx +1];    // nodes associated with each vertex');
clss = clss.Append_CR('    int  E[Num_Edge_Sets+1][NUM_EDGE+1][Max_DoF_Per_Edge+1];    // nodes associated with each edge');
clss = clss.Append_CR('    int  F[Num_Face_Sets+1][NUM_FACE+1][Max_DoF_Per_Face+1];    // nodes associated with each face');
clss = clss.Append_CR('    int  T[Num_Tet_Sets +1][NUM_TET +1][Max_DoF_Per_Tet +1];    // nodes associated with each tetrahedron');
clss = clss.Append_CR('}');
clss = clss.Append_CR('NODAL_TOPOLOGY;');
clss = clss.Append_CR('');

% BEGIN: edge DoF permutations

clss = clss.Append_CR(obj.String.Separator);
clss = clss.Append_CR('// data structure containing *one* permutation map');
clss = clss.Append_CR('typedef struct');
clss = clss.Append_CR('{');
clss = clss.Append_CR('    int map[Max_DoF_Per_Edge+1];');
clss = clss.Append_CR('}');
clss = clss.Append_CR('SINGLE_EDGE_PERM_MAP;');
clss = clss.Append_CR('');
clss = clss.Append_CR(obj.String.Separator);
clss = clss.Append_CR('// data structure for containing permutation maps of local edge DoFs from');
clss = clss.Append_CR('//      one local edge to another.');
clss = clss.Append_CR('struct EDGE_DOF_PERMUTATION');
clss = clss.Append_CR('{');
clss = clss.Append_CR('    EDGE_DOF_PERMUTATION () {} // default constructor');
clss = clss.Append_CR('');
clss = clss.Append_CR('    void Setup_Maps ()');
clss = clss.Append_CR('        {');
clss = clss.Append_CR('        // init to all zero');
clss = clss.Append_CR('        for (int di = 0; (di < Num_Edge_Sets); di++)');
clss = clss.Append_CR('        for (int ii = 0; (ii < NUM_EDGE); ii++)');
clss = clss.Append_CR('        for (int si = 0; (si < 2); si++)');
clss = clss.Append_CR('        for (int jj = 0; (jj < NUM_EDGE); jj++)');
clss = clss.Append_CR('        for (int sj = 0; (sj < 2); sj++)');
clss = clss.Append_CR('        for (int kk = 0; (kk <= Max_DoF_Per_Edge); kk++)');
clss = clss.Append_CR('            perm[di][ii][si][jj][sj].map[kk] = 0;');
clss = clss.Append_CR('');
clss = clss.Append_CR('        // define all edge DoF permutation maps');
clss = clss.Append_CR('        // map goes from "current" to "init" local edge');
clss = clss.Append_CR(['        ', obj.String.BEGIN_Auto_Gen]);

% map from local edge to tail vertex index
ei_to_tail_vi = [1 1 1 2 3 4];
% map from local edge to head vertex index
ei_to_head_vi = [2 3 4 3 4 2];

if ~isempty(Elem_Nodal_Top.E{1})
    Num_Edge_Sets = length(Elem_Nodal_Top.E);
    for si = 1:Num_Edge_Sets
        Edge_DoF_Set = Elem_Nodal_Top.E{si};
        if (size(Edge_DoF_Set,1)~=6)
            error('Incorrect number of edges in DoF set!');
        end
        % within each set, figure out the permutation maps between
        % different local edges
        % (also account for changes in orientation)
        cei_index = [-6 -5 -4 -3 -2 -1 1 2 3 4 5 6];
        init_ei_index = cei_index;
        
        % check all combinations
        for ii = 1:12 % loop through "current" edges
            cei = cei_index(ii);
            for jj = 1:12 % loop through "init" edges
                init_ei = init_ei_index(jj);
                % 		// DoF set #1, (current) -6 ---> (init) -1
                clss = clss.Append_CR(['        ', '// DoF set #', num2str(si), ', (current) ', num2str(cei), ' ---> (init) ', num2str(init_ei)]);
                % get current and init edge DoFs
                cei_DoFs     = Edge_DoF_Set(abs(cei),:);
                init_ei_DoFs = Edge_DoF_Set(abs(init_ei),:);
                
                % for the "current" edge, get the tail vertex BC coordinate
                cei_vi  = ei_to_tail_vi(abs(cei));
                cei_BCs = get_vtx_barycentric_coordinate_on_edge(cei_DoFs,Elem_Nodal_Var,cei_vi);
                
                % for the "init" edge, get the tail or head vertex BC coordinate
                % (depending on whether the edge orientation is different)
                if (cei*init_ei < 0) % change in orientation
                    init_ei_vi = ei_to_head_vi(abs(init_ei));
                else
                    init_ei_vi = ei_to_tail_vi(abs(init_ei));
                end
                init_ei_BCs = get_vtx_barycentric_coordinate_on_edge(init_ei_DoFs,Elem_Nodal_Var,init_ei_vi);
                % Note: these lists of barycentric coordinates are in the
                % order of cei_DoFs/init_ei_DoFs
                
                % getting permutation of DoFs from comparing BC lists
                DoF_perm = get_DoF_permutation_on_edge(cei_BCs,init_ei_BCs);
                for kk = 1:length(DoF_perm)
                    if cei > 0
                        sign_cei = 1;
                    else
                        sign_cei = 0;
                    end
                    if init_ei > 0
                        sign_init_ei = 1;
                    else
                        sign_init_ei = 0;
                    end
                    clss = clss.Append_CR(['        ', 'perm[', num2str(si-1), '][',...
                                     num2str(abs(cei)-1),     '][', num2str(sign_cei), '][',...
                                     num2str(abs(init_ei)-1), '][', num2str(sign_init_ei), '].map[',...
                                     num2str(kk), '] = ', num2str(DoF_perm(kk)), ';']);
                end
                clss = clss.Append_CR('');
            end
        end
    end
else
    Num_Edge_Sets = 0;
end

clss = clss.Append_CR(['        ', obj.String.END_Auto_Gen]);
clss = clss.Append_CR('        }');
clss = clss.Append_CR('');
clss = clss.Append_CR('    inline const int* Get_Map (const int& dof_set, const int& new_edge, const int& init_edge) const');
clss = clss.Append_CR('        {');
clss = clss.Append_CR('        // error check');
clss = clss.Append_CR('        if ((new_edge==0) || (new_edge < -6) || (new_edge > 6))');
clss = clss.Append_CR('            {');
clss = clss.Append_CR('            mexPrintf("new_edge must be = +/- 1,2,3,4,5,6.\\n");');
clss = clss.Append_CR('            mexErrMsgTxt("Invalid local edge index!\\n");');
clss = clss.Append_CR('            }');
clss = clss.Append_CR('        if ((init_edge==0) || (init_edge < -6) || (init_edge > 6))');
clss = clss.Append_CR('            {');
clss = clss.Append_CR('            mexPrintf("init_edge must be = +/- 1,2,3,4,5,6.\\n");');
clss = clss.Append_CR('            mexErrMsgTxt("Invalid local edge index!\\n");');
clss = clss.Append_CR('            }');
clss = clss.Append_CR('        if ((dof_set < 1) || (dof_set > Num_Edge_Sets))');
clss = clss.Append_CR('            {');
clss = clss.Append_CR('            mexPrintf("dof_set must be >= 1 and <= %%d.\\n",Num_Edge_Sets);');
clss = clss.Append_CR('            mexErrMsgTxt("Invalid dof_set index!\\n");');
clss = clss.Append_CR('            }');
clss = clss.Append_CR('');
clss = clss.Append_CR('        // massage input');
clss = clss.Append_CR('        const int ne = abs_index( new_edge) - 1; // C-style indexing');
clss = clss.Append_CR('        const int ie = abs_index(init_edge) - 1; // C-style indexing');
clss = clss.Append_CR('        int sign_ne = 1; // init to positive');
clss = clss.Append_CR('        int sign_ie = 1; // init to positive');
clss = clss.Append_CR('        if ( new_edge < 0) sign_ne = 0; // set to negative sign');
clss = clss.Append_CR('        if (init_edge < 0) sign_ie = 0; // set to negative sign');
clss = clss.Append_CR('');
clss = clss.Append_CR('        return perm[dof_set-1][ne][sign_ne][ie][sign_ie].map;');
clss = clss.Append_CR('        }');
clss = clss.Append_CR('');
clss = clss.Append_CR('private:');
clss = clss.Append_CR('    // contains all of the permutation maps');
clss = clss.Append_CR('    // input: [dof_set][new_edge_index][sign of new_edge][init_edge_index][sign of init_edge]');
if (Num_Edge_Sets > 0)
    clss = clss.Append_CR('    SINGLE_EDGE_PERM_MAP perm[Num_Edge_Sets][NUM_EDGE][2][NUM_EDGE][2];');
else
    clss = clss.Append_CR('    // NOTE: this is not used b/c there are no edge sets!');
    clss = clss.Append_CR('    SINGLE_EDGE_PERM_MAP perm[1][NUM_EDGE][2][NUM_EDGE][2];');
end
clss = clss.Append_CR('};');
clss = clss.Append_CR('');

% END: edge DoF permutations

% BEGIN: face DoF permutations

clss = clss.Append_CR(obj.String.Separator);
clss = clss.Append_CR('// data structure containing *one* face-DoF permutation map');
clss = clss.Append_CR('typedef struct');
clss = clss.Append_CR('{');
clss = clss.Append_CR('    int map[Max_DoF_Per_Face+1];');
clss = clss.Append_CR('}');
clss = clss.Append_CR('SINGLE_FACE_PERM_MAP;');
clss = clss.Append_CR('');
clss = clss.Append_CR(obj.String.Separator);
clss = clss.Append_CR('// data structure for containing permutation maps of local face DoFs from');
clss = clss.Append_CR('//      one local face to another.');
clss = clss.Append_CR('struct FACE_DOF_PERMUTATION');
clss = clss.Append_CR('{');
clss = clss.Append_CR('    FACE_DOF_PERMUTATION () {} // default constructor');
clss = clss.Append_CR('');
clss = clss.Append_CR('    void Setup_Maps ()');
clss = clss.Append_CR('        {');
clss = clss.Append_CR('        // init to all zero');
clss = clss.Append_CR('        for (int di = 0; (di < Num_Face_Sets); di++)');
clss = clss.Append_CR('        for (int ii = 0; (ii < NUM_FACE); ii++)');
clss = clss.Append_CR('        for (int si = 0; (si < 6); si++)');
clss = clss.Append_CR('        for (int jj = 0; (jj < NUM_FACE); jj++)');
clss = clss.Append_CR('        for (int sj = 0; (sj < 6); sj++)');
clss = clss.Append_CR('        for (int kk = 0; (kk <= Max_DoF_Per_Face); kk++)');
clss = clss.Append_CR('            perm[di][ii][si][jj][sj].map[kk] = 0;');
clss = clss.Append_CR('');
clss = clss.Append_CR('        // define all face DoF permutation maps');
clss = clss.Append_CR('        // map goes from "current" to "init" local face');
clss = clss.Append_CR(['        ', obj.String.BEGIN_Auto_Gen]);

% map from local face index to set of three vertex indices
fi_to_vtx = [2 3 4;
             1 4 3;
             1 2 4;
             1 3 2];
%

% define the 6 permutations
face_perm = [1 2 3;  % 1
             3 1 2;  % 2
             2 3 1;  % 3
             3 2 1;  % 4
             2 1 3;  % 5
             1 3 2]; % 6
%

if ~isempty(Elem_Nodal_Top.F{1})
    Num_Face_Sets = length(Elem_Nodal_Top.F);
    for si = 1:Num_Face_Sets
        Face_DoF_Set = Elem_Nodal_Top.F{si};
        if (size(Face_DoF_Set,1)~=4)
            error('Incorrect number of faces in DoF set!');
        end
        
        % within each set, figure out the permutation maps between
        % different local faces
        % (check all combinations)
        
        % loop through "current" faces
        for cfi = 1:4
        for perm_cfi_index = 1:6 % all permutations
            perm_cfi = face_perm(perm_cfi_index,:);
            % loop through "init" faces
            for init_fi = 1:4
            for perm_init_index = 1:6 % all permutations
                perm_init = face_perm(perm_init_index,:);
                %init_ei = init_ei_index(jj);
                % 		// DoF set #1, (current: face, perm) 2, 4 ---> (init: face, perm) 1, 2
                clss = clss.Append_CR(['        ', '// DoF set #', num2str(si), ', (current: face, perm) ',...
                                                                                  num2str(cfi), ', [', num2str(perm_cfi), ']',...
                                                                            ' ---> (init: face, perm) ',...
                                                                                  num2str(init_fi), ', [', num2str(perm_init), ']']);
                % get current and init face DoFs
                cfi_DoFs     = Face_DoF_Set(cfi,:);
                init_fi_DoFs = Face_DoF_Set(init_fi,:);
                
                % for the "current" face, get the (permuted) BC coordinates
                current_face_vertices = fi_to_vtx(cfi,:);
                cfi_BCs = get_vtx_barycentric_coordinates_on_face(cfi_DoFs,Elem_Nodal_Var,current_face_vertices(1,perm_cfi));
                % for the "init" face, get the (permuted) BC coordinates
                init_face_vertices = fi_to_vtx(init_fi,:);
                init_fi_BCs = get_vtx_barycentric_coordinates_on_face(init_fi_DoFs,Elem_Nodal_Var,init_face_vertices(1,perm_init));
                
                % get permutation of DoFs by comparing BC coordinates
                DoF_perm = get_DoF_permutation_on_face(cfi_BCs,init_fi_BCs);
                for kk = 1:length(DoF_perm)
                    clss = clss.Append_CR(['        ', 'perm[', num2str(si-1), '][',...
                                     num2str(cfi-1),     '][', num2str(perm_cfi_index-1), '][',...
                                     num2str(init_fi-1), '][', num2str(perm_init_index-1), '].map[',...
                                     num2str(kk), '] = ', num2str(DoF_perm(kk)), ';']);
                end
                clss = clss.Append_CR('');
            end
            end
        end
        end
    end
else
    Num_Face_Sets = 0;
end

clss = clss.Append_CR(['        ', obj.String.END_Auto_Gen]);
clss = clss.Append_CR('        }');
clss = clss.Append_CR('');
clss = clss.Append_CR('    inline const int* Get_Map (const int& dof_set, const int& new_face,  const int& perm_new,');
clss = clss.Append_CR('                                                   const int& init_face, const int& perm_init) const');
clss = clss.Append_CR('        {');
clss = clss.Append_CR('        // error check');
clss = clss.Append_CR('        if ((new_face < 1) || (new_face > 4))');
clss = clss.Append_CR('            {');
clss = clss.Append_CR('            mexPrintf("new_face must be = 1,2,3,4.\\n");');
clss = clss.Append_CR('            mexErrMsgTxt("Invalid local face index!\\n");');
clss = clss.Append_CR('            }');
clss = clss.Append_CR('        if ((perm_new < 1) || (perm_new > 6))');
clss = clss.Append_CR('            {');
clss = clss.Append_CR('            mexPrintf("perm_new must be = 1,2,3,4,5,6.\\n");');
clss = clss.Append_CR('            mexErrMsgTxt("Invalid permutation index!\\n");');
clss = clss.Append_CR('            }');
clss = clss.Append_CR('        if ((init_face < 1) || (init_face > 4))');
clss = clss.Append_CR('            {');
clss = clss.Append_CR('            mexPrintf("init_face must be = 1,2,3,4.\\n");');
clss = clss.Append_CR('            mexErrMsgTxt("Invalid local face index!\\n");');
clss = clss.Append_CR('            }');
clss = clss.Append_CR('        if ((perm_init < 1) || (perm_init > 6))');
clss = clss.Append_CR('            {');
clss = clss.Append_CR('            mexPrintf("perm_init must be = 1,2,3,4,5,6.\\n");');
clss = clss.Append_CR('            mexErrMsgTxt("Invalid permutation index!\\n");');
clss = clss.Append_CR('            }');
clss = clss.Append_CR('        if ((dof_set < 1) || (dof_set > Num_Face_Sets))');
clss = clss.Append_CR('            {');
clss = clss.Append_CR('            mexPrintf("dof_set must be >= 1 and <= %%d.\\n",Num_Face_Sets);');
clss = clss.Append_CR('            mexErrMsgTxt("Invalid dof_set index!\\n");');
clss = clss.Append_CR('            }');
clss = clss.Append_CR('');
clss = clss.Append_CR('        return perm[dof_set-1][new_face-1][perm_new-1][init_face-1][perm_init-1].map;');
clss = clss.Append_CR('        }');
clss = clss.Append_CR('');
clss = clss.Append_CR('private:');
clss = clss.Append_CR('    // contains all of the permutation maps');
clss = clss.Append_CR('    // input: [dof_set][new_face_index][perm of new_face][init_face_index][perm of init_face]');
if (Num_Face_Sets > 0)
    clss = clss.Append_CR('    SINGLE_FACE_PERM_MAP perm[Num_Face_Sets][NUM_FACE][6][NUM_FACE][6];');
else
    clss = clss.Append_CR('    // NOTE: this is not used b/c there are no face sets!');
    clss = clss.Append_CR('    SINGLE_FACE_PERM_MAP perm[1][NUM_FACE][6][NUM_FACE][6];');
end
clss = clss.Append_CR('};');
clss = clss.Append_CR('');

% END: face DoF permutations

clss = clss.Append_CR(obj.String.Separator);
clss = clss.Append_CR('class EDA');
clss = clss.Append_CR('{');
clss = clss.Append_CR('public:');
clss = clss.Append_CR('    char*    Name;              // name of finite element space');
clss = clss.Append_CR('    int      Dim;               // intrinsic dimension');
clss = clss.Append_CR('    char*    Domain;            // type of domain: "interval", "triangle", "tetrahedron"');
clss = clss.Append_CR('');
clss = clss.Append_CR('    NODAL_TOPOLOGY   Node;      // Nodal DoF arrangment');
clss = clss.Append_CR('    EDGE_DOF_PERMUTATION   Edge_DoF_Perm; // permutation maps for local edge DoFs:');
clss = clss.Append_CR('                                          // this is for allocating DoFs on edges');
clss = clss.Append_CR('                                          //      consistently between elements.');
clss = clss.Append_CR('    FACE_DOF_PERMUTATION   Face_DoF_Perm; // permutation maps for local face DoFs:');
clss = clss.Append_CR('                                          // this is for allocating DoFs on faces');
clss = clss.Append_CR('                                          //      consistently between elements.');
clss = clss.Append_CR('');
clss = clss.Append_CR('    EDA ();  // constructor');
clss = clss.Append_CR('    ~EDA (); // DE-structor');
clss = clss.Append_CR('    mxArray* Init_DoF_Map(int);');
clss = clss.Append_CR('    void  Fill_DoF_Map  (TETRAHEDRON_DATA*);');
clss = clss.Append_CR('    int  Assign_Vtx_DoF (TETRAHEDRON_DATA*, const int);');
clss = clss.Append_CR('    int  Assign_Edge_DoF(TETRAHEDRON_DATA*, const int);');
clss = clss.Append_CR('    int  Assign_Face_DoF(TETRAHEDRON_DATA*, const int);');
clss = clss.Append_CR('    int  Assign_Tet_DoF (TETRAHEDRON_DATA*, const int);');
clss = clss.Append_CR('    void  Error_Check_DoF_Map(const int&);');
clss = clss.Append_CR('');
clss = clss.Append_CR('private:');
clss = clss.Append_CR('    int*  cell_dof[Total_DoF_Per_Cell+1];');
clss = clss.Append_CR('};');
clss = clss.Append_CR('');

end

function BCs = get_vtx_barycentric_coordinate_on_edge(DoFs,Nodal_Var,vi)

% get the vertex BC coordinate for each DoF
Num_DoFs = length(DoFs);
BCs = zeros(Num_DoFs,1);
for di = 1:Num_DoFs
    Nodal_Var_Data = Nodal_Var(DoFs(di)).Data;
    BC_all = Nodal_Var_Data{1};
    BCs(di,1) = BC_all(vi);
end

end

function DoF_perm = get_DoF_permutation_on_edge(cei_BCs,init_ei_BCs)

Num_DoF = length(cei_BCs);
DoF_perm = zeros(Num_DoF,1);
% compare the BC coordinates of each DoF in cei and init_ei
for cc_BC_index = 1:Num_DoF
    cc_BC_value = cei_BCs(cc_BC_index);
    for ii_BC_index = 1:Num_DoF
        ii_BC_value = init_ei_BCs(ii_BC_index);
        if ( abs(cc_BC_value - ii_BC_value) < 1e-15 )
            DoF_perm(cc_BC_index) = ii_BC_index; % map "current" to "init"
            break;
        end
    end
end

if min(DoF_perm)==0
    error('At least one DoF was not matched up!');
end
if (length(unique(DoF_perm))~=Num_DoF)
    error('Some DoFs got duplicated!');
end

end

function BCs = get_vtx_barycentric_coordinates_on_face(DoFs,Nodal_Var,face_vertices)

% get the vertex BC coordinates for each DoF (in the face)
Num_DoFs = length(DoFs);
BCs = zeros(Num_DoFs,3);
for di = 1:Num_DoFs
    Nodal_Var_Data = Nodal_Var(DoFs(di)).Data;
    BC_all = Nodal_Var_Data{1};
    BCs(di,:) = BC_all(1,face_vertices);
end

end

function DoF_perm = get_DoF_permutation_on_face(cfi_BCs,init_fi_BCs)

Num_DoF = size(cfi_BCs,1);
DoF_perm = zeros(Num_DoF,1);
% compare the BC coordinates of each DoF in cfi and init_fi
for cc_BC_index = 1:Num_DoF
    cc_BC_value = cfi_BCs(cc_BC_index,:);
    for ii_BC_index = 1:Num_DoF
        ii_BC_value = init_fi_BCs(ii_BC_index,:);
        % compute norm of difference
        Diff_1 = max(abs(cc_BC_value - ii_BC_value));
        if ( Diff_1 < 1e-15 )
            DoF_perm(cc_BC_index) = ii_BC_index; % map "current" to "init"
            break;
        end
    end
end

if min(DoF_perm)==0
    error('At least one DoF was not matched up!');
end
if (length(unique(DoF_perm))~=Num_DoF)
    error('Some DoFs got duplicated!');
end

end