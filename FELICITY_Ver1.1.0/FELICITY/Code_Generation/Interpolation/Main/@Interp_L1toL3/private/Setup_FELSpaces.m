function FS = Setup_FELSpaces(obj,Domain_Info)
%Setup_FELSpaces
%
%   This inits the FELSpaces object.

% Copyright (c) 01-28-2013,  Shawn W. Walker

% create geometric element for the Hold-All container domain
DEBUG = true;
Geom_Elem = ReferenceFiniteElement(obj.INTERP.GeoElem.Elem,obj.INTERP.GeoElem.Tensor_Comp,DEBUG);

% initialize
FS = FELSpaces(Domain_Info,Geom_Elem);

% get unique list of FEM spaces
MAP = containers.Map();
Num_Expr = length(obj.INTERP.Interp_Expr);
for ind = 1:Num_Expr
    I_Expr = obj.INTERP.Interp_Expr{ind};
    
    for ci = 1:length(I_Expr.CoefF)
        MAP = Insert_Element_Struct_Into_MAP(I_Expr.CoefF(ci).Element,MAP);
    end
end

% append those spaces
FS_cell = MAP.values;
for ind = 1:length(FS_cell)
    FS_struct = FS_cell{ind};
    REF_ELEM = ReferenceFiniteElement(FS_struct.Elem,FS_struct.Tensor_Comp,DEBUG);
    FS = FS.Append_FEM_Space(FS_struct.Domain,FS_struct.Space_Name,REF_ELEM);
end

% include any coefficient functions
FS = obj.Setup_FELCoefs(FS);

% include any extra geometric functions
FS = obj.Setup_FELGeoms(FS);

end