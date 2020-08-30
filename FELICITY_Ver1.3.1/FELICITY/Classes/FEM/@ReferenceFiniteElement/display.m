function display(obj)

% get number of finite element spaces
Num_Ref_Elem = length(obj);

for oi=1:Num_Ref_Elem

disp('------------------------------------------');
disp(['ReferenceFiniteElement(',num2str(oi),')']);
disp('');

disp(['          Top_Dim: Topological Dimension                     =  ',num2str(obj(oi).Top_Dim),'']);
disp(['     Simplex_Type: Type of Simplex                           =  ''',obj(oi).Simplex_Type,'''']);
disp(['     Simplex_Vtx : Vertices of Simplex                          ','Number of Vertices: ',num2str(size(obj(oi).Simplex_Vtx,1))]);
disp(['     Element_Type: Continuous or Discontinuous Galerkin      =  ''',obj(oi).Element_Type,'''']);
disp(['     Element_Name: Name of Finite Element Space              =  ''',obj(oi).Element_Name,'''']);
disp(['   Element_Degree: Degree of Finite Element Space            =  ',num2str(obj(oi).Element_Degree),'']);
disp(['       Basis_Size: Matrix Size of Local Basis Function       =  [', num2str(obj(oi).Basis_Size(1)),', ', num2str(obj(oi).Basis_Size(2)),']']);
disp(['        Num_Basis: Number of Local Basis Functions           =  ',num2str(obj(oi).Num_Basis),'']);
disp(['            Basis: Set of Local Basis Functions (symbolic)      ', '']);
disp(['   Transformation: Type of Local Transformation To Use       =  ''',obj(oi).Transformation,'''']);
disp(['       Nodal_Data: Nodal Variable Data of all DoFs         ','Number of Nodal DoFs: ',num2str(size(obj(oi).Nodal_Data.BC_Coord,1))]);
obj(oi).Nodal_Data
disp(['        Nodal_Top: Topological Arrangement of Nodal DoFs        ','SIZE = ',num2str(size(obj(oi).Nodal_Top))]);
disp('');

if obj(oi).USE_SYM
    USE_SYM_str = 'TRUE';
else
    USE_SYM_str = 'FALSE';
end

disp(['          USE_SYM: Allowed to use Symbolic Computing Toolbox =  ',USE_SYM_str]);

disp('');
disp('------------------------------------------');
disp('');

end

end