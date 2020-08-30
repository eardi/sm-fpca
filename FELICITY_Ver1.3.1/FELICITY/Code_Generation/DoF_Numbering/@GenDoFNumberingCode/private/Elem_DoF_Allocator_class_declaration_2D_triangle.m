function clss = Elem_DoF_Allocator_class_declaration_2D_triangle(obj,Elem)
%Elem_DoF_Allocator_class_declaration_2D_triangle
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
ei_to_tail_vi = [2 3 1];
% map from local edge to head vertex index
ei_to_head_vi = [3 1 2];

if ~isempty(Elem_Nodal_Top.E{1})
    Num_Sets = length(Elem_Nodal_Top.E);
    for si = 1:Num_Sets
        Edge_DoF_Set = Elem_Nodal_Top.E{si};
        if (size(Edge_DoF_Set,1)~=3)
            error('Incorrect number of edges in DoF set!');
        end
        % within each set, figure out the permutation maps between
        % different local edges
        % (also account for changes in orientation)
        cei_index = [-3 -2 -1 1 2 3];
        init_ei_index = cei_index;
        
        % check all combinations
        for ii = 1:6 % loop through "current" edges
            cei = cei_index(ii);
            for jj = 1:6 % loop through "init" edges
                init_ei = init_ei_index(jj);
                % 		// DoF set #1, (current) -3 ---> (init) -1
                clss = clss.Append_CR(['        ', '// DoF set #', num2str(si), ', (current) ', num2str(cei), ' ---> (init) ', num2str(init_ei)]);
                % get current and init edge DoFs
                cei_DoFs     = Edge_DoF_Set(abs(cei),:);
                init_ei_DoFs = Edge_DoF_Set(abs(init_ei),:);
                
                % for the "current" edge, get the tail vertex BC coordinate
                cei_vi  = ei_to_tail_vi(abs(cei));
                cei_BCs = get_vtx_barycentric_coordinate(cei_DoFs,Elem_Nodal_Var,cei_vi);
                
                % for the "init" edge, get the tail or head vertex BC coordinate
                % (depending on whether the edge orientation is different)
                if (cei*init_ei < 0) % change in orientation
                    init_ei_vi = ei_to_head_vi(abs(init_ei));
                else
                    init_ei_vi = ei_to_tail_vi(abs(init_ei));
                end
                init_ei_BCs = get_vtx_barycentric_coordinate(init_ei_DoFs,Elem_Nodal_Var,init_ei_vi);
                % Note: these lists of barycentric coordinates are in the
                % order of cei_DoFs/init_ei_DoFs
                
                % getting permutation of DoFs from comparing BC lists
                DoF_perm = get_DoF_permutation(cei_BCs,init_ei_BCs);
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
    Num_Sets = 0;
end

clss = clss.Append_CR(['        ', obj.String.END_Auto_Gen]);
clss = clss.Append_CR('        }');
clss = clss.Append_CR('');
clss = clss.Append_CR('    inline const int* Get_Map (const int& dof_set, const int& new_edge, const int& init_edge) const');
clss = clss.Append_CR('        {');
clss = clss.Append_CR('        // error check');
clss = clss.Append_CR('        if ((new_edge==0) || (new_edge < -3) || (new_edge > 3))');
clss = clss.Append_CR('            {');
clss = clss.Append_CR('            mexPrintf("new_edge must be = +/- 1,2,3.\\n");');
clss = clss.Append_CR('            mexErrMsgTxt("Invalid local edge index!\\n");');
clss = clss.Append_CR('            }');
clss = clss.Append_CR('        if ((init_edge==0) || (init_edge < -3) || (init_edge > 3))');
clss = clss.Append_CR('            {');
clss = clss.Append_CR('            mexPrintf("init_edge must be = +/- 1,2,3.\\n");');
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
if (Num_Sets > 0)
    clss = clss.Append_CR('    SINGLE_EDGE_PERM_MAP perm[Num_Edge_Sets][NUM_EDGE][2][NUM_EDGE][2];');
else
    clss = clss.Append_CR('    // NOTE: this is not used b/c there are no edge sets!');
    clss = clss.Append_CR('    SINGLE_EDGE_PERM_MAP perm[1][NUM_EDGE][2][NUM_EDGE][2];');
end
clss = clss.Append_CR('};');
clss = clss.Append_CR('');

clss = clss.Append_CR(obj.String.Separator);
clss = clss.Append_CR('class EDA');
clss = clss.Append_CR('{');
clss = clss.Append_CR('public:');
clss = clss.Append_CR('    char*    Name;              // name of finite element space');
clss = clss.Append_CR('    int      Dim;               // intrinsic dimension');
clss = clss.Append_CR('    char*    Domain;            // type of domain: "interval", "triangle", "tetrahedron"');
clss = clss.Append_CR('');
clss = clss.Append_CR('    NODAL_TOPOLOGY         Node;          // Nodal DoF arrangment');
clss = clss.Append_CR('    EDGE_DOF_PERMUTATION   Edge_DoF_Perm; // permutation maps for local edge DoFs:');
clss = clss.Append_CR('                                          // this is for allocating DoFs on edges');
clss = clss.Append_CR('                                          //      consistently between elements.');
clss = clss.Append_CR('');
clss = clss.Append_CR('    EDA ();  // constructor');
clss = clss.Append_CR('    ~EDA (); // DE-structor');
clss = clss.Append_CR('    mxArray* Init_DoF_Map(int);');
clss = clss.Append_CR('    void  Fill_DoF_Map  (TRIANGLE_EDGE_SEARCH*);');
clss = clss.Append_CR('    int  Assign_Vtx_DoF (TRIANGLE_EDGE_SEARCH*, const int);');
clss = clss.Append_CR('    int  Assign_Edge_DoF(TRIANGLE_EDGE_SEARCH*, const int);');
clss = clss.Append_CR('    int  Assign_Face_DoF(TRIANGLE_EDGE_SEARCH*, const int);');
clss = clss.Append_CR('    int  Assign_Tet_DoF (TRIANGLE_EDGE_SEARCH*, const int);');
clss = clss.Append_CR('    void  Error_Check_DoF_Map(const int&);');
clss = clss.Append_CR('');
clss = clss.Append_CR('private:');
clss = clss.Append_CR('    int*  cell_dof[Total_DoF_Per_Cell+1];');
clss = clss.Append_CR('};');
clss = clss.Append_CR('');

end

function BCs = get_vtx_barycentric_coordinate(DoFs,Nodal_Var,vi)

% get the vertex BC coordinate for each DoF
Num_DoFs = length(DoFs);
BCs = zeros(Num_DoFs,1);
for di = 1:Num_DoFs
    Nodal_Var_Data = Nodal_Var(DoFs(di)).Data;
    BC_all = Nodal_Var_Data{1};
    BCs(di,1) = BC_all(vi);
end

end

function DoF_perm = get_DoF_permutation(cei_BCs,init_ei_BCs)

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