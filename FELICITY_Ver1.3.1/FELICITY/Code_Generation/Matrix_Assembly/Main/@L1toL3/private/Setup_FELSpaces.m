function FS = Setup_FELSpaces(obj,Domain_Info)
%Setup_FELSpaces
%
%   This inits the FELSpaces object.

% Copyright (c) 03-24-2017,  Shawn W. Walker

check_geometric_element_domain_geodim_consistency(obj.MATS.GeoElem.Tensor_Comp,Domain_Info);

% create geometric element for the Hold-All container domain
DEBUG = true;
Geom_Elem = ReferenceFiniteElement(obj.MATS.GeoElem.Elem,DEBUG);

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
    REF_ELEM = ReferenceFiniteElement(FS_struct.Elem,DEBUG);
    FS = FS.Append_FEM_Space(FS_struct.Domain,FS_struct.Space_Name,REF_ELEM,FS_struct.Tensor_Comp);
end

% include any coefficient functions
FS = obj.Setup_FELCoefs(FS);

% include any extra geoemtric functions
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