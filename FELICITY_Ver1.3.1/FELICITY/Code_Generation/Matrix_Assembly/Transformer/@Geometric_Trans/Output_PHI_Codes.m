function CODE = Output_PHI_Codes(obj,PHI_Struct,Num_Basis)
%Output_PHI_Codes
%
%   This outputs an array of structs, each of which contains the C++ code for
%   implementing that quantity.
%
%   Note: these must be stored in order of dependencies, i.e. the ones that
%   don't depend on anything come first, etc...
%   Note: PHI_Struct is a struct with the same fields as given by
%         Output_PHI_Struct.

% Copyright (c) 04-03-2018,  Shawn W. Walker

CODE = obj.PHI_Val_C_Code(1); % init

INDEX = 0; % init
if PHI_Struct.Mesh_Size
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Mesh_Size_C_Code(Num_Basis);
end
if PHI_Struct.Val
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Val_C_Code(Num_Basis);
end
if PHI_Struct.Grad
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Grad_C_Code(Num_Basis);
end
if PHI_Struct.Metric
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Metric_C_Code;
end
if PHI_Struct.Det_Metric
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Det_Metric_C_Code;
end
if PHI_Struct.Inv_Det_Metric
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Inv_Det_Metric_C_Code;
end
if PHI_Struct.Inv_Metric
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Inv_Metric_C_Code;
end
if PHI_Struct.Det_Jacobian
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Det_Jac_C_Code;
end
if PHI_Struct.Det_Jacobian_with_quad_weight
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Det_Jac_w_Weight_C_Code;
end
if PHI_Struct.Inv_Det_Jacobian
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Inv_Det_Jac_C_Code;
end
if PHI_Struct.Inv_Grad
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Inv_Grad_C_Code;
end
if PHI_Struct.Tangent_Vector
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Tangent_Vector_C_Code;
end
if PHI_Struct.Normal_Vector
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Normal_Vector_C_Code;
end
if PHI_Struct.Tangent_Space_Projection
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Tan_Space_Proj_C_Code;
end
if PHI_Struct.Hess
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Hess_C_Code(Num_Basis);
end
if PHI_Struct.Hess_Inv_Map
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Hess_Inv_Map_C_Code;
end
if PHI_Struct.Grad_Metric
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Grad_Metric_C_Code;
end
if PHI_Struct.Grad_Inv_Metric
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Grad_Inv_Metric_C_Code;
end
if PHI_Struct.Christoffel_2nd_Kind
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Christoffel_2nd_Kind_C_Code;
end
if PHI_Struct.Second_Fund_Form
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_2nd_Fund_Form_C_Code;
end
if PHI_Struct.Det_Second_Fund_Form
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Det_2nd_Fund_Form_C_Code;
end
if PHI_Struct.Inv_Det_Second_Fund_Form
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Inv_Det_2nd_Fund_Form_C_Code;
end
if and(obj.TopDim==1,obj.GeoDim==3) % curve in 3-D
    if PHI_Struct.Total_Curvature_Vector
        INDEX = INDEX + 1;
        CODE(INDEX) = obj.PHI_Total_Curvature_Vector_C_Code;
    end
    if PHI_Struct.Total_Curvature
        INDEX = INDEX + 1;
        CODE(INDEX) = obj.PHI_Total_Curvature_C_Code;
    end
else % else we must compute the scalar (total) curvature first
    if PHI_Struct.Total_Curvature
        INDEX = INDEX + 1;
        CODE(INDEX) = obj.PHI_Total_Curvature_C_Code;
    end
    if PHI_Struct.Total_Curvature_Vector
        INDEX = INDEX + 1;
        CODE(INDEX) = obj.PHI_Total_Curvature_Vector_C_Code;
    end
end
if PHI_Struct.Gauss_Curvature
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Gauss_Curvature_C_Code;
end
if PHI_Struct.Shape_Operator
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.PHI_Shape_Operator_C_Code;
end

if (INDEX==0)
    CODE = []; % output nothing...
end

%                         Mesh_Size: [1x1 sym]
%                               Val: [3x1 sym]
%                              Grad: [3x2 sym]
%                            Metric: [2x2 sym]
%                        Det_Metric: [1x1 sym]
%                    Inv_Det_Metric: [1x1 sym]
%                        Inv_Metric: [2x2 sym]
%                      Det_Jacobian: [1x1 sym]
%     Det_Jacobian_with_quad_weight: [1x1 sym]
%                  Inv_Det_Jacobian: [1x1 sym]
%                          Inv_Grad: []
%                    Tangent_Vector: []
%                     Normal_Vector: [3x1 sym]
%          Tangent_Space_Projection: [3x3 sym]
%                              Hess: [2x2x3 sym]
%                      Hess_Inv_Map: []
%                       Grad_Metric: [2x2x2 sym]
%                   Grad_Inv_Metric: [2x2x2 sym]
%                  Second_Fund_Form: [2x2 sym]
%              Det_Second_Fund_Form: [1x1 sym]
%          Inv_Det_Second_Fund_Form: [1x1 sym]
%            Total_Curvature_Vector: [3x1 sym]
%                   Total_Curvature: [1x1 sym]
%                   Gauss_Curvature: [1x1 sym]
%                    Shape_Operator: [3x3 sym]
%                       Orientation: [] (sometimes)

end