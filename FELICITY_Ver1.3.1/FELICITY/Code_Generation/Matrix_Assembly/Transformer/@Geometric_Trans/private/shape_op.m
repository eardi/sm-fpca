function obj = shape_op(obj)
%shape_op
%
%   Get the shape operator (matrix) for a manifold described by PHI.

% Copyright (c) 05-19-2016,  Shawn W. Walker

if (obj.GeoDim > obj.TopDim)
    obj.PHI.Shape_Operator = sym('Shape_Op_%d%d',[obj.GeoDim, obj.GeoDim]);
else
    obj.PHI.Shape_Operator = []; % not valid in this case!
end

end