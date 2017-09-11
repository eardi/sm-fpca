function obj = Read_In_Element_Struct(obj,Elem)
%Read_In_Element_Struct
%
%   This converts the Elem struct to something that the class/object can
%   use.

% Copyright (c) 01-01-2011,  Shawn W. Walker

% this is a NON-element!
if strcmp(Elem.Type,'constant_one')
    obj.Top_Dim      = [];
    obj.Simplex_Type = [];
    obj.Simplex_Vtx  = [];
    obj.Element_Type = Elem.Type;
    obj.Element_Name = Elem.Name;
    obj.Element_Degree = 0;
    obj.Num_Basis = 1;
    obj.Basis(1).phi = sym('1');
    obj.Nodal_BC_Coord = [];
    return;
end

obj.Top_Dim = Elem.Dim;
obj.Simplex_Type = Elem.Domain;
if strcmp(obj.Simplex_Type,'interval')
    obj.Simplex_Vtx = [0; 1];
elseif strcmp(obj.Simplex_Type,'triangle')
    obj.Simplex_Vtx = [0, 0; 1, 0; 0, 1];
elseif strcmp(obj.Simplex_Type,'tetrahedron')
    obj.Simplex_Vtx = [0, 0, 0; 1, 0, 0; 0, 1, 0; 0, 0, 1];
else
    error(['ERROR: The domain type ''', obj.Simplex_Type, ''' is invalid!']);
end

obj.Element_Type   = Elem.Type;
obj.Element_Name   = Elem.Name;
obj.Element_Degree = Elem.Degree;

obj.Num_Basis    = size(Elem.Basis.Func,1);

% nodal barycentric coordinates
obj.Nodal_BC_Coord = zeros(obj.Num_Basis,obj.Top_Dim+1);
% convert to symbolic variables
for ind = 1:obj.Num_Basis
    obj.Basis(ind).phi = sym(Elem.Basis.Func{ind,1});
    DIM_CHK = max(abs(size(obj.Basis(ind).phi) - size(obj.Basis(1).phi)));
    if DIM_CHK > 0
        error('All basis functions (in a set) must have the same component dimensions!');
    end
    obj.Nodal_BC_Coord(ind,:) = Elem.Nodal_Var.Basis{ind,2};
end
obj.Num_Vec_Comp = size(obj.Basis(1).phi,1);
obj.Transformation = Elem.Basis.Transformation;

% topological arrangment
obj.Nodal_Top = Elem.Nodal_Top;

end