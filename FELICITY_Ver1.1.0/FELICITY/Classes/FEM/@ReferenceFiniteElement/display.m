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
%disp(['        Num_Func : Number of Distinct Functions              =  ',num2str(obj(oi).Num_Func),'']);
disp(['        Num_Comp : Number of Tensor Components               =  ',num2str(obj(oi).Num_Comp),'']);
disp(['     Num_Vec_Comp: Number of (intrinsic) Vector Components   =  ',num2str(obj(oi).Num_Vec_Comp),'']);
disp(['        Num_Basis: Number of Local Basis Functions           =  ',num2str(obj(oi).Num_Basis),'']);
disp(['            Basis: Set of Local Basis Functions (symbolic)      ', '']);
disp(['   Transformation: Type of Local Transformation To Use       =  ''',obj(oi).Transformation,'''']);
disp(['   Nodal_BC_Coord: Barycentric Coordinates of Nodal DoFs        ','Number of Nodal DoFs: ',num2str(size(obj(oi).Nodal_BC_Coord,1))]);
disp(['        Nodal_Top: Topological Arrangement of Nodal DoFs        ','SIZE = ',num2str(size(obj(oi).Nodal_Top))]);
disp('');

if obj(oi).DEBUG
    DEBUG = 'TRUE';
else
    DEBUG = 'FALSE';
end

disp(['            DEBUG: Perform Debugging Checks                  =  ',DEBUG]);

disp('');
disp('------------------------------------------');
disp('');

end

end