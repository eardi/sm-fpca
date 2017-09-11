function CODE = PHI_Tan_Space_Proj_C_Code(obj)
%PHI_Tan_Space_Proj_C_Code
%
%   Generate C-code for direct evaluation of PHI.Tangent_Space_Projection.
%      PHI_Tangent_Space_Projection_ij(qp) = matrix entries
%                        1 <= i,j <= GeoDim,
%                        and qp are the coordinates of a quadrature point.
%   In Euclidean space, TSP is the identity matrix.
%   On a curve, TSP = \tv \otimes \tv.
%   On a surface, TSP = \vI - \nv \otimes \nv.

% Copyright (c) 02-20-2012,  Shawn W. Walker

% make var string
CODE.Var_Name(1).line = []; % init
CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Tangent_Space_Projection');
Map_TSP_Eval_str = [CODE.Var_Name(1).line, '_qp_i'];

% need the tangent vector
if ~isempty(obj.PHI.Tangent_Vector)
    Map_TV_str = obj.Output_CPP_Var_Name('Tangent_Vector');
    Map_TV_Eval_str = [Map_TV_str, '[qp_i]'];
else
    Map_TV_Eval_str = [];
end

% need the normal vector
if ~isempty(obj.PHI.Normal_Vector)
    Map_NV_str = obj.Output_CPP_Var_Name('Normal_Vector');
    Map_NV_Eval_str = [Map_NV_str, '[qp_i]'];
else
    Map_NV_Eval_str = [];
end

% define evaluation snippets
EVAL_STR(1).line = []; % init
if (obj.GeoDim==1)
    if (obj.TopDim==1)
        EVAL_STR(1).line = [Map_TSP_Eval_str, '.m[0][0]', ' = 1.0;'];
    else
        error('Not valid!');
    end
elseif (obj.GeoDim==2)
    if (obj.TopDim==1)
        EVAL_STR(1).line = ['Compute_Tangent_Space_Projection_TopDim_1(',...
                            Map_TV_Eval_str, ', ', Map_TSP_Eval_str, ');'];
    elseif (obj.TopDim==2)
        EVAL_STR(1).line = ['Compute_Tangent_Space_Projection_TopDim_2(',...
                            Map_TSP_Eval_str, ');'];
    else
        error('Not valid!');
    end
elseif (obj.GeoDim==3)
    if (obj.TopDim==1)
        EVAL_STR(1).line = ['Compute_Tangent_Space_Projection_TopDim_1(',...
                            Map_TV_Eval_str, ', ', Map_TSP_Eval_str, ');'];
    elseif (obj.TopDim==2)
        EVAL_STR(1).line = ['Compute_Tangent_Space_Projection_TopDim_2(',...
                            Map_NV_Eval_str, ', ', Map_TSP_Eval_str, ');'];
    elseif (obj.TopDim==3)
        EVAL_STR(1).line = ['Compute_Tangent_Space_Projection_TopDim_3(',...
                            Map_TSP_Eval_str, ');'];
    else
        error('Not valid!');
    end
else
    error('Not Implemented!');
end

% define the data type
TYPE_str = obj.Get_CPP_Matrix_Data_Type_Name(obj.GeoDim,obj.GeoDim);
Defn_Hdr = '// the (tangential) gradient of the identity map on the manifold';
Loop_Hdr = '// compute gradient of the identity map (on the manifold)';
Loop_Comment = [];
CONST_VAR = obj.Lin_PHI_TF;
CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                            Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%

end