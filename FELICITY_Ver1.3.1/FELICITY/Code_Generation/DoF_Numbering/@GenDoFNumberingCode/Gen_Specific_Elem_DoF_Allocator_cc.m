function CPP_Data_Type_str = Gen_Specific_Elem_DoF_Allocator_cc(obj,Elem_Num)
%Gen_Specific_Elem_DoF_Allocator_cc
%
%   This generates the file: "<Specific>_Elem_DoF_Allocator.cc".

% Copyright (c) 12-10-2010,  Shawn W. Walker

if strcmpi(obj.Elem(Elem_Num).Type,'CG')
    if and(obj.Elem(Elem_Num).Dim==1,strcmpi(obj.Elem(Elem_Num).Domain,'interval'))
        CPP_Data_Type_str = Gen_Specific_Elem_DoF_Allocator_On_1D_Interval(obj,Elem_Num);
    elseif and(obj.Elem(Elem_Num).Dim==2,strcmpi(obj.Elem(Elem_Num).Domain,'triangle'))
        CPP_Data_Type_str = Gen_Specific_Elem_DoF_Allocator_On_2D_Triangle(obj,Elem_Num);
    elseif and(obj.Elem(Elem_Num).Dim==3,strcmpi(obj.Elem(Elem_Num).Domain,'tetrahedron'))
        CPP_Data_Type_str = Gen_Specific_Elem_DoF_Allocator_On_3D_Tetrahedron(obj,Elem_Num);
    else
        error('Not implemented!');
    end
elseif strcmpi(obj.Elem(Elem_Num).Type,'DG')
    CPP_Data_Type_str = Gen_Specific_Elem_DoF_Allocator_For_DG(obj,Elem_Num);
else
    error('Element Type must be CG or DG!');
end

end