function clss = Elem_DoF_Allocator_class_declaration_1D_interval(obj)
%Elem_DoF_Allocator_class_declaration_1D_interval
%
%   This stores lines of code for sub-sections of the
%   'Elem_DoF_Allocator.cc' C++ code file.

% Copyright (c) 12-01-2010,  Shawn W. Walker

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
clss = clss.Append_CR('class EDA');
clss = clss.Append_CR('{');
clss = clss.Append_CR('public:');
clss = clss.Append_CR('    char*    Name;              // name of finite element space');
clss = clss.Append_CR('    int      Dim;               // intrinsic dimension');
clss = clss.Append_CR('    char*    Domain;            // type of domain: "interval", "triangle", "tetrahedron"');
clss = clss.Append_CR('');
clss = clss.Append_CR('    NODAL_TOPOLOGY   Node;      // Nodal DoF arrangment');
clss = clss.Append_CR('');
clss = clss.Append_CR('    EDA ();  // constructor');
clss = clss.Append_CR('    ~EDA (); // DE-structor');
clss = clss.Append_CR('    mxArray* Init_DoF_Map(int);');
clss = clss.Append_CR('    void  Fill_DoF_Map  (EDGE_POINT_SEARCH*);');
clss = clss.Append_CR('    int  Assign_Vtx_DoF (EDGE_POINT_SEARCH*, const int);');
clss = clss.Append_CR('    int  Assign_Edge_DoF(EDGE_POINT_SEARCH*, const int);');
clss = clss.Append_CR('    int  Assign_Face_DoF(EDGE_POINT_SEARCH*, const int);');
clss = clss.Append_CR('    int  Assign_Tet_DoF (EDGE_POINT_SEARCH*, const int);');
clss = clss.Append_CR('    void  Error_Check_DoF_Map(const int&);');
clss = clss.Append_CR('');
clss = clss.Append_CR('private:');
clss = clss.Append_CR('    int*  cell_dof[Total_DoF_Per_Cell+1];');
clss = clss.Append_CR('};');
clss = clss.Append_CR('');

end