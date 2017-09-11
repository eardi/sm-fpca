function FS = Setup_FELSpaces(obj,Domain_Info)
%Setup_FELSpaces
%
%   This inits the FELSpaces object.

% Copyright (c) 05-29-2012,  Shawn W. Walker

% create geometric element for the Hold-All container domain
DEBUG = true;
Geom_Elem = ReferenceFiniteElement(obj.MATS.GeoElem.Elem,obj.MATS.GeoElem.Tensor_Comp,DEBUG);

% initialize
FS = FELSpaces(Domain_Info,Geom_Elem);

% get unique list of FEM spaces
MAP = containers.Map();
Num_Matrix = length(obj.MATS.Matrix_Data);
for ind = 1:Num_Matrix
    FORM = obj.MATS.Matrix_Data{ind};
    if ~isa(FORM,'Real')
        if ~isempty(FORM.Test_Space)
            MAP = Insert_Element_Struct_Into_MAP(FORM.Test_Space,MAP);
        end
        if ~isempty(FORM.Trial_Space)
            MAP = Insert_Element_Struct_Into_MAP(FORM.Trial_Space,MAP);
        end
    end
    % must loop over matrices for the Real case
    for ir = 1:size(FORM,1)
        for ic = 1:size(FORM,2)
            ID = FORM(ir,ic).Integral;
            for int_i = 1:length(ID)
                for ci = 1:length(ID(int_i).CoefF)
                    MAP = Insert_Element_Struct_Into_MAP(ID(int_i).CoefF(ci).Element,MAP);
                end
            end
        end
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

% include any extra geoemtric functions
FS = obj.Setup_FELGeoms(FS);

end