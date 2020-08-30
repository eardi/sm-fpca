function FS = Setup_FELSpaces(obj,Domain_Info)
%Setup_FELSpaces
%
%   This inits the FELSpaces object.

% Copyright (c) 01-28-2013,  Shawn W. Walker

check_geometric_element_domain_geodim_consistency(obj.INTERP.GeoElem.Tensor_Comp,Domain_Info);

% create geometric element for the Hold-All container domain
DEBUG = true;
Geom_Elem = ReferenceFiniteElement(obj.INTERP.GeoElem.Elem,DEBUG);

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
    REF_ELEM = ReferenceFiniteElement(FS_struct.Elem,DEBUG);
    FS = FS.Append_FEM_Space(FS_struct.Domain,FS_struct.Space_Name,REF_ELEM,FS_struct.Tensor_Comp);
end

% include any coefficient functions
FS = obj.Setup_FELCoefs(FS);

% include any extra geometric functions
FS = obj.Setup_FELGeoms(FS);

end

function check_geometric_element_domain_geodim_consistency(Tensor_Comp,Domain_Array)

% make sure there is consistency in the geometric dimension
for kk = 1:length(Domain_Array)
    Domain_GD = Domain_Array(kk).Integration_Domain.GeoDim;
    if (Tensor_Comp~=Domain_GD)
        err = FELerror;
        err = err.Add_Comment(['The ', 'Geometric', ' Element space does not have the']);
        err = err.Add_Comment('same vector dimension as the Domain of Integration.');
        err = err.Add_Comment(['Element space has dim = ', num2str(Tensor_Comp)]);
        err = err.Add_Comment(['Domain of Integration has dim = ', num2str(Domain_GD)]);
        err = err.Add_Comment('Check your Domain definitions!');
        err.Error;
        error('stop!');
    end
end

end