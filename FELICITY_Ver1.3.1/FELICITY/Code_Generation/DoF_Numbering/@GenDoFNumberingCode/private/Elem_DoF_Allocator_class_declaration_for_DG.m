function clss = Elem_DoF_Allocator_class_declaration_for_DG(obj,Elem)
%Elem_DoF_Allocator_class_declaration_for_DG
%
%   This stores lines of code for sub-sections of the
%   'Elem_DoF_Allocator.cc' C++ code file.

% Copyright (c) 12-01-2010,  Shawn W. Walker

% get dimension
Dim = Elem.Dim;

if (Dim==1)
    FILL_DOF_MAP_str = '    void  Fill_DoF_Map  (EDGE_POINT_SEARCH*);';
elseif (Dim==2)
    FILL_DOF_MAP_str = '    void  Fill_DoF_Map  (TRIANGLE_EDGE_SEARCH*);';
elseif (Dim==3)
    FILL_DOF_MAP_str = '    void  Fill_DoF_Map  (TETRAHEDRON_DATA*);';
else
    error('NOT implemented!');
end

clss = FELtext('class declaration');

clss = clss.Append_CR(obj.String.Separator);
clss = clss.Append_CR('class EDA');
clss = clss.Append_CR('{');
clss = clss.Append_CR('public:');
clss = clss.Append_CR('    char*    Name;              // name of finite element space');
clss = clss.Append_CR('    int      Dim;               // intrinsic dimension');
clss = clss.Append_CR('    char*    Domain;            // type of domain: "interval", "triangle", "tetrahedron"');
clss = clss.Append_CR('');
clss = clss.Append_CR('    EDA ();  // constructor');
clss = clss.Append_CR('    ~EDA (); // DE-structor');
clss = clss.Append_CR('    mxArray* Init_DoF_Map(int);');
clss = clss.Append_CR(FILL_DOF_MAP_str);
clss = clss.Append_CR('    void  Error_Check_DoF_Map(const int&);');
clss = clss.Append_CR('');
clss = clss.Append_CR('private:');
clss = clss.Append_CR('    int*  cell_dof[Total_DoF_Per_Cell+1];');
clss = clss.Append_CR('};');
clss = clss.Append_CR('');

end